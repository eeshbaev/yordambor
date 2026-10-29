-- 025: The rules of deals and reviews, kept by the server.
--
-- Until now the app alone kept them, so anyone calling the API directly
-- could write into other people's deal chats, mark a deal done alone,
-- swap who a deal is with, review any service, or change a review's
-- rating. And ratings and completed counts were worked out on the phone
-- of whoever acted last; when that was the client, the server refused
-- the write and the numbers never moved.
--
--   1. Deal chat: only the two sides of a deal write in it.
--   2. Deals: a new deal is an offer from its sender, with the service's
--      owner (or the request's author) on the other side, never between
--      people who blocked each other, and one at a time per service and
--      pair. Afterwards each side sets only its own "accepted" and "done";
--      the status follows those (agreed when both accepted, done when both
--      confirmed, three days after agreeing); nobody changes who the deal
--      is between; terms change only while the deal is open (agreed deals
--      for three days, and then they are offered afresh).
--   3. Reviews: by the client of a finished deal, about that deal's
--      service, once; the provider may add a reply and nothing else.
--   4. Ratings, review counts and completed counts are kept by the server
--      and cannot be set by hand. The current ones are counted afresh.
--   5. Removing a service or an old deal no longer fails over the deals
--      and reviews that point at it.
--   6. Account deletion works for providers with past deals and removes
--      the sign-in too. (The app deletes the person's files first.)
--   7. Deal chats and deal changes are sent live (realtime).
--   8. A service's view counts once per person per day, and not when its
--      owner opens it.
--
-- A call without a signed-in user (the dashboard, scheduled jobs) is
-- trusted, as before. Safe to run twice. Undo: supabase/undo/025_undo.sql.
-- Check: supabase/checks/025_check.sql.

-- Lets the server's own functions write the counts below.
create or replace function public._trusted_write(p_on boolean)
returns void
language sql
as $$
  select set_config('yordambor.trusted', case when p_on then 'on' else 'off' end, true);
$$;

create or replace function public._is_trusted()
returns boolean
language sql
stable
as $$
  select auth.uid() is null
      or coalesce(current_setting('yordambor.trusted', true), 'off') = 'on';
$$;

-- 1. Deal chat ---------------------------------------------------------------

drop policy if exists "kelishuv_msg_insert" on public.kelishuv_messages;
create policy "kelishuv_msg_insert" on public.kelishuv_messages for insert
  with check (
    auth.uid() = sender_id
    and exists (
      select 1 from public.kelishuvlar k
      where k.id = kelishuv_id
        and (k.party_a_id = auth.uid() or k.party_b_id = auth.uid())
    )
  );

-- 2. Deals -------------------------------------------------------------------

drop policy if exists "kelishuv_insert" on public.kelishuvlar;
create policy "kelishuv_insert" on public.kelishuvlar for insert
  with check (
    auth.uid() = initiator_id
    and (auth.uid() = party_a_id or auth.uid() = party_b_id)
  );

drop policy if exists "kelishuv_update" on public.kelishuvlar;
create policy "kelishuv_update" on public.kelishuvlar for update
  using (auth.uid() = party_a_id or auth.uid() = party_b_id)
  with check (auth.uid() = party_a_id or auth.uid() = party_b_id);

create or replace function public.guard_kelishuv()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
  owner uuid;
  author uuid;
  i_am_a boolean;
  terms_changed boolean;
begin
  if public._is_trusted() then
    return new;
  end if;

  if tg_op = 'INSERT' then
    if new.party_a_id = new.party_b_id then
      raise exception 'A deal needs two people' using errcode = '42501';
    end if;
    if new.status is distinct from 'muzokarada'
       or new.complete_a or new.complete_b
       or (new.accept_a and uid <> new.party_a_id)
       or (new.accept_b and uid <> new.party_b_id) then
      raise exception 'A new deal starts as an offer' using errcode = '42501';
    end if;
    if new.xizmat_id is not null then
      select x.owner_id into owner from xizmatlar x where x.id = new.xizmat_id;
      if owner is distinct from new.party_b_id then
        raise exception 'The service''s owner must be on the deal'
          using errcode = '42501';
      end if;
    end if;
    if new.yordam_kerak_post_id is not null then
      select y.author_id into author
      from yordam_kerak_posts y where y.id = new.yordam_kerak_post_id;
      if author is distinct from new.party_a_id then
        raise exception 'The request''s author must be on the deal'
          using errcode = '42501';
      end if;
    end if;
    if not public._subsector_users_not_blocked(new.party_a_id, new.party_b_id) then
      raise exception 'Blocked' using errcode = '42501';
    end if;
    if new.xizmat_id is not null and exists (
      select 1 from kelishuvlar k
      where k.xizmat_id = new.xizmat_id
        and k.status in ('muzokarada', 'jarayonda')
        and ((k.party_a_id = new.party_a_id and k.party_b_id = new.party_b_id)
          or (k.party_a_id = new.party_b_id and k.party_b_id = new.party_a_id))
    ) then
      raise exception 'There is already an open deal for this service'
        using errcode = '23505';
    end if;
    new.jarayonda_at := null;
    new.bajarildi_at := null;
    new.created_at := now();
    return new;
  end if;

  -- UPDATE by one of the two sides.
  if new.party_a_id is distinct from old.party_a_id
     or new.party_b_id is distinct from old.party_b_id
     or new.initiator_id is distinct from old.initiator_id
     or new.xizmat_id is distinct from old.xizmat_id
     or new.yordam_kerak_post_id is distinct from old.yordam_kerak_post_id
     or new.created_at is distinct from old.created_at then
    raise exception 'Who a deal is between does not change'
      using errcode = '42501';
  end if;

  if old.status in ('bajarildi', 'bekor', 'rad', 'archived') then
    raise exception 'This deal is closed' using errcode = '42501';
  end if;

  i_am_a := uid = old.party_a_id;

  -- The other side's "accepted" and "done" can be cleared (new terms, a
  -- new message), never set.
  if (i_am_a and ((new.accept_b and not old.accept_b)
                  or (new.complete_b and not old.complete_b)))
     or (not i_am_a and ((new.accept_a and not old.accept_a)
                         or (new.complete_a and not old.complete_a))) then
    raise exception 'Only the other side can say that' using errcode = '42501';
  end if;

  -- When each side's yes was given is the server's to say.
  if new.accept_a and not old.accept_a then new.accept_a_at := now();
  elsif not new.accept_a then new.accept_a_at := null;
  else new.accept_a_at := old.accept_a_at;
  end if;
  if new.accept_b and not old.accept_b then new.accept_b_at := now();
  elsif not new.accept_b then new.accept_b_at := null;
  else new.accept_b_at := old.accept_b_at;
  end if;

  terms_changed :=
    new.message is distinct from old.message
    or new.price is distinct from old.price
    or new.currency is distinct from old.currency
    or new.start_date is distinct from old.start_date
    or new.start_time is distinct from old.start_time
    or new.duration_minutes is distinct from old.duration_minutes;

  if terms_changed and old.status = 'jarayonda' then
    if old.jarayonda_at is not null
       and old.jarayonda_at < now() - interval '3 days' then
      raise exception 'Terms cannot change three days after agreeing'
        using errcode = '42501';
    end if;
    if new.status <> 'muzokarada' then
      raise exception 'New terms are offered afresh' using errcode = '42501';
    end if;
  end if;

  if (new.complete_a and not old.complete_a)
     or (new.complete_b and not old.complete_b) then
    if old.status <> 'jarayonda' then
      raise exception 'Only an agreed deal can be done' using errcode = '42501';
    end if;
    if old.jarayonda_at is not null
       and old.jarayonda_at > now() - interval '3 days' then
      raise exception 'Done can be confirmed three days after agreeing'
        using errcode = '42501';
    end if;
  end if;

  case new.status
    when 'muzokarada' then
      if new.complete_a or new.complete_b then
        raise exception 'An offer is not done' using errcode = '42501';
      end if;
      new.jarayonda_at := null;
    when 'jarayonda' then
      if not (new.accept_a and new.accept_b) then
        raise exception 'Both sides must accept' using errcode = '42501';
      end if;
      new.jarayonda_at := case
        when old.status = 'jarayonda' then old.jarayonda_at
        else now()
      end;
    when 'bajarildi' then
      if old.status <> 'jarayonda' or not (new.complete_a and new.complete_b) then
        raise exception 'Both sides must confirm it is done'
          using errcode = '42501';
      end if;
      new.bajarildi_at := now();
    when 'bekor' then
      null;
    when 'rad' then
      if old.status <> 'muzokarada' then
        raise exception 'Only an offer can be declined' using errcode = '42501';
      end if;
    else
      raise exception 'Not a status the app sets' using errcode = '42501';
  end case;

  if new.status <> 'bajarildi' then
    new.bajarildi_at := old.bajarildi_at;
  end if;
  new.archive_at := old.archive_at;
  new.delete_at := old.delete_at;
  return new;
end;
$$;

drop trigger if exists trg_guard_kelishuv on public.kelishuvlar;
create trigger trg_guard_kelishuv
  before insert or update on public.kelishuvlar
  for each row execute function public.guard_kelishuv();

-- 3. Reviews -----------------------------------------------------------------

drop policy if exists "reviews_insert_participant" on public.reviews;
create policy "reviews_insert_participant" on public.reviews for insert
  with check (
    auth.uid() = reviewer_id
    and rating between 1 and 5
    and exists (
      select 1
      from public.kelishuvlar k
      join public.xizmatlar x on x.id = k.xizmat_id
      where k.id = kelishuv_id
        and k.status in ('bajarildi', 'archived')
        and k.bajarildi_at is not null
        and k.xizmat_id = reviews.xizmat_id
        and (k.party_a_id = auth.uid() or k.party_b_id = auth.uid())
        and x.owner_id <> auth.uid()
    )
  );

create or replace function public.guard_review()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if public._is_trusted() then
    return new;
  end if;
  if new.kelishuv_id is distinct from old.kelishuv_id
     or new.xizmat_id is distinct from old.xizmat_id
     or new.reviewer_id is distinct from old.reviewer_id
     or new.rating is distinct from old.rating
     or new.comment is distinct from old.comment
     or new.created_at is distinct from old.created_at then
    raise exception 'A provider can only reply to a review'
      using errcode = '42501';
  end if;
  return new;
end;
$$;

drop trigger if exists trg_guard_review on public.reviews;
create trigger trg_guard_review
  before update on public.reviews
  for each row execute function public.guard_review();

-- 4. Ratings and counts, kept by the server ---------------------------------

create or replace function public.guard_xizmat_counts()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if public._is_trusted() then
    return new;
  end if;
  if tg_op = 'INSERT' then
    new.rating_avg := 0;
    new.review_count := 0;
    new.completed_count := 0;
  else
    new.rating_avg := old.rating_avg;
    new.review_count := old.review_count;
    new.completed_count := old.completed_count;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_guard_xizmat_counts on public.xizmatlar;
create trigger trg_guard_xizmat_counts
  before insert or update on public.xizmatlar
  for each row execute function public.guard_xizmat_counts();

create or replace function public.refresh_xizmat_rating(p_xizmat uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if p_xizmat is null then
    return;
  end if;
  perform public._trusted_write(true);
  update xizmatlar x
  set
    rating_avg = coalesce((
      select round(avg(r.rating)::numeric, 2) from reviews r
      where r.xizmat_id = x.id
    ), 0),
    review_count = (select count(*) from reviews r where r.xizmat_id = x.id)
  where x.id = p_xizmat;
  perform public._trusted_write(false);
end;
$$;

revoke all on function public.refresh_xizmat_rating(uuid) from public, anon, authenticated;

create or replace function public.on_review_changed()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    perform public.refresh_xizmat_rating(new.xizmat_id);
  elsif tg_op = 'DELETE' then
    perform public.refresh_xizmat_rating(old.xizmat_id);
  else
    perform public.refresh_xizmat_rating(old.xizmat_id);
    if new.xizmat_id is distinct from old.xizmat_id then
      perform public.refresh_xizmat_rating(new.xizmat_id);
    end if;
  end if;
  return null;
end;
$$;

drop trigger if exists trg_review_changed on public.reviews;
create trigger trg_review_changed
  after insert or update or delete on public.reviews
  for each row execute function public.on_review_changed();

create or replace function public.on_kelishuv_done()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status = 'bajarildi'
     and old.status is distinct from 'bajarildi'
     and new.xizmat_id is not null then
    perform public._trusted_write(true);
    update xizmatlar
    set completed_count = completed_count + 1
    where id = new.xizmat_id;
    perform public._trusted_write(false);
  end if;
  return null;
end;
$$;

drop trigger if exists trg_kelishuv_done on public.kelishuvlar;
create trigger trg_kelishuv_done
  after update of status on public.kelishuvlar
  for each row execute function public.on_kelishuv_done();

-- The numbers as they should be today.
select public._trusted_write(true);
update public.xizmatlar x
set
  rating_avg = coalesce((
    select round(avg(r.rating)::numeric, 2) from public.reviews r
    where r.xizmat_id = x.id
  ), 0),
  review_count = (select count(*) from public.reviews r where r.xizmat_id = x.id),
  completed_count = greatest(
    x.completed_count,
    (select count(*) from public.kelishuvlar k
     where k.xizmat_id = x.id
       and (k.status = 'bajarildi' or k.bajarildi_at is not null))
  );
select public._trusted_write(false);

-- 5. References that no longer block removals --------------------------------

do $$
declare
  c record;
begin
  for c in
    select tc.table_name, tc.constraint_name, kcu.column_name
    from information_schema.table_constraints tc
    join information_schema.key_column_usage kcu
      on kcu.constraint_name = tc.constraint_name
     and kcu.table_schema = tc.table_schema
    where tc.table_schema = 'public'
      and tc.constraint_type = 'FOREIGN KEY'
      and (tc.table_name, kcu.column_name) in (
        ('reviews', 'kelishuv_id'),
        ('reviews', 'xizmat_id'),
        ('kelishuvlar', 'xizmat_id'),
        ('kelishuvlar', 'yordam_kerak_post_id')
      )
  loop
    execute format('alter table public.%I drop constraint %I',
                   c.table_name, c.constraint_name);
  end loop;
end $$;

-- A review stays when its old deal is cleared away; it goes with its
-- service. A past deal stays when its service or request is removed.
alter table public.reviews
  add constraint reviews_kelishuv_id_fkey foreign key (kelishuv_id)
    references public.kelishuvlar(id) on delete set null,
  add constraint reviews_xizmat_id_fkey foreign key (xizmat_id)
    references public.xizmatlar(id) on delete cascade;
alter table public.kelishuvlar
  add constraint kelishuvlar_xizmat_id_fkey foreign key (xizmat_id)
    references public.xizmatlar(id) on delete set null,
  add constraint kelishuvlar_yordam_kerak_post_id_fkey
    foreign key (yordam_kerak_post_id)
    references public.yordam_kerak_posts(id) on delete set null;

-- 6. Account deletion ----------------------------------------------------------

create or replace function public.delete_user_account()
returns void
language plpgsql
security definer
set search_path = public, auth
as $$
declare
  uid uuid := auth.uid();
begin
  if uid is null then
    raise exception 'Not authenticated';
  end if;

  -- Trusted from here: the person's own rows, in an order the references
  -- allow.
  perform public._trusted_write(true);

  delete from reviews
  where reviewer_id = uid
     or xizmat_id in (select id from xizmatlar where owner_id = uid);

  delete from kelishuvlar
  where party_a_id = uid or party_b_id = uid;

  delete from xizmatlar where owner_id = uid;
  delete from yordam_kerak_posts where author_id = uid;
  delete from favorites where user_id = uid;
  delete from blocks where blocker_id = uid or blocked_id = uid;
  delete from notifications where user_id = uid;
  delete from reports where reporter_id = uid;
  update feedback_submissions set user_id = null where user_id = uid;

  delete from profiles where id = uid;
  -- The sign-in itself, so the email and phone are free and nothing is
  -- left to sign in to.
  delete from auth.users where id = uid;

  perform public._trusted_write(false);
end;
$$;

revoke all on function public.delete_user_account() from public, anon;
grant execute on function public.delete_user_account() to authenticated;

-- 7. Live deal chats ---------------------------------------------------------

do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public' and tablename = 'kelishuv_messages'
    ) then
      alter publication supabase_realtime add table public.kelishuv_messages;
    end if;
    if not exists (
      select 1 from pg_publication_tables
      where pubname = 'supabase_realtime'
        and schemaname = 'public' and tablename = 'kelishuvlar'
    ) then
      alter publication supabase_realtime add table public.kelishuvlar;
    end if;
  end if;
end $$;

-- 8. Views counted once ------------------------------------------------------

create or replace function public.dedupe_view()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.event_type is distinct from 'view' or auth.uid() is null then
    return new;
  end if;
  new.user_id := auth.uid();
  if exists (
       select 1 from xizmatlar x
       where x.id = new.xizmat_id and x.owner_id = auth.uid()
     )
     or exists (
       select 1 from analytics_events e
       where e.xizmat_id = new.xizmat_id
         and e.user_id = auth.uid()
         and e.event_type = 'view'
         and e.created_at > now() - interval '1 day'
     ) then
    return null;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_dedupe_view on public.analytics_events;
create trigger trg_dedupe_view
  before insert on public.analytics_events
  for each row execute function public.dedupe_view();

notify pgrst, 'reload schema';
