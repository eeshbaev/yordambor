-- 024: Appointments, prices and help-request alerts.
--
--   1. Phones people chose to show. get_public_phone(user) and
--      get_xizmat_public_phone(service) return a phone only when its owner
--      made it visible to everyone, only to signed-in people, and never
--      between people who blocked each other.
--   2. When an agreed deal (an appointment) is cancelled, the other side
--      gets a clear "Uchrashuv bekor qilindi" notice at once. The person
--      who cancelled gets none.
--   3. Prices. Services can also be priced per day, per month or per unit,
--      and help requests keep how their price is meant (pricing_model).
--   4. Help-request alerts for providers. Every service subscribes its owner
--      to new help requests in its sub-sector and city, and the existing
--      services are subscribed now. Each alert can still be switched off
--      under Notifications.
--   5. Busy hours on a service page. A provider can let everyone see which
--      hours their agreed appointments take (xizmatlar.show_busy_hours, off
--      by default). get_xizmat_busy_hours() returns only those time ranges:
--      no names, prices or anything else about the deals.
--
-- Safe to run twice. Undo: supabase/undo/024_undo.sql.
-- Check: supabase/checks/024_check.sql.

-- 1. Phones people chose to show ------------------------------------------

create or replace function public.get_public_phone(p_user uuid)
returns text
language sql
stable
security definer
set search_path = public
as $$
  select nullif(trim(p.phone), '')
  from profiles p
  where p.id = p_user
    and p.show_phone
    and auth.uid() is not null
    and not exists (
      select 1
      from blocks b
      where (b.blocker_id = p_user and b.blocked_id = auth.uid())
         or (b.blocker_id = auth.uid() and b.blocked_id = p_user)
    );
$$;

create or replace function public.get_xizmat_public_phone(p_xizmat uuid)
returns text
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    case when x.show_contact_phone then nullif(trim(x.contact_phone), '') end,
    case when p.show_phone then nullif(trim(p.phone), '') end
  )
  from xizmatlar x
  join profiles p on p.id = x.owner_id
  where x.id = p_xizmat
    and auth.uid() is not null
    and not exists (
      select 1
      from blocks b
      where (b.blocker_id = x.owner_id and b.blocked_id = auth.uid())
         or (b.blocker_id = auth.uid() and b.blocked_id = x.owner_id)
    );
$$;

revoke all on function public.get_public_phone(uuid) from public, anon;
revoke all on function public.get_xizmat_public_phone(uuid) from public, anon;
grant execute on function public.get_public_phone(uuid) to authenticated;
grant execute on function public.get_xizmat_public_phone(uuid) to authenticated;

-- 2. Cancelled appointments ------------------------------------------------

create or replace function public.notify_kelishuv_status()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  actor uuid := auth.uid();
  what text;
  who text;
  at_text text;
begin
  if new.status = old.status then
    return new;
  end if;

  if new.status = 'jarayonda' and old.status = 'muzokarada' then
    insert into notifications (user_id, type, payload) values
    (
      new.party_a_id,
      'kelishuv_accept',
      jsonb_build_object(
        'title', 'Kelishuv boshlandi',
        'body', 'Ikki tomon ham qabul qildi — ish jarayoni boshlandi',
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id
      )
    ),
    (
      new.party_b_id,
      'kelishuv_accept',
      jsonb_build_object(
        'title', 'Kelishuv boshlandi',
        'body', 'Ikki tomon ham qabul qildi — ish jarayoni boshlandi',
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id
      )
    );
  elsif new.status = 'bajarildi' then
    insert into notifications (user_id, type, payload) values
    (
      new.party_a_id,
      'kelishuv_complete',
      jsonb_build_object(
        'title', 'Ish yakunlandi',
        'body', 'Kelishuv bajarildi deb belgilandi',
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id
      )
    ),
    (
      new.party_b_id,
      'kelishuv_complete',
      jsonb_build_object(
        'title', 'Ish yakunlandi',
        'body', 'Kelishuv bajarildi deb belgilandi',
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id
      )
    );
  elsif new.status = 'bekor' and old.status = 'jarayonda' then
    -- An agreed appointment was cancelled: tell the other side right away.
    select coalesce(
      (select x.name from xizmatlar x where x.id = new.xizmat_id),
      (select y.title from yordam_kerak_posts y where y.id = new.yordam_kerak_post_id),
      ''
    ) into what;
    select nullif(trim(p.full_name), '') into who
    from profiles p
    where p.id = actor;
    at_text := case
      when new.start_date is null then null
      else to_char(new.start_date, 'DD.MM.YYYY')
        || coalesce(' ' || to_char(new.start_time, 'HH24:MI'), '')
    end;

    insert into notifications (user_id, type, payload)
    select
      party,
      'kelishuv_appointment_cancelled',
      jsonb_build_object(
        'title', 'Uchrashuv bekor qilindi',
        'body', concat_ws(' · ', nullif(what, ''), at_text, who),
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id,
        'cancelled_by', actor
      )
    from unnest(array[new.party_a_id, new.party_b_id]) as party
    where actor is null or party <> actor;
  elsif new.status in ('bekor', 'rad') then
    insert into notifications (user_id, type, payload) values
    (
      new.party_a_id,
      'kelishuv_closed',
      jsonb_build_object(
        'title', 'Kelishuv yopildi',
        'body', 'Kelishuv holati: ' || new.status,
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id
      )
    ),
    (
      new.party_b_id,
      'kelishuv_closed',
      jsonb_build_object(
        'title', 'Kelishuv yopildi',
        'body', 'Kelishuv holati: ' || new.status,
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id
      )
    );
  end if;

  return new;
end;
$$;

-- 3. Prices -----------------------------------------------------------------

do $$
declare
  c record;
begin
  for c in
    select conname
    from pg_constraint
    where conrelid = 'public.xizmatlar'::regclass
      and contype = 'c'
      and pg_get_constraintdef(oid) like '%pricing_model%'
  loop
    execute format('alter table public.xizmatlar drop constraint %I', c.conname);
  end loop;
end $$;

alter table public.xizmatlar
  add constraint xizmatlar_pricing_model_check
  check (pricing_model in ('negotiable', 'fixed', 'hourly', 'daily', 'monthly', 'unit'));

alter table public.yordam_kerak_posts
  add column if not exists pricing_model text not null default 'negotiable';

do $$
declare
  c record;
begin
  for c in
    select conname
    from pg_constraint
    where conrelid = 'public.yordam_kerak_posts'::regclass
      and contype = 'c'
      and pg_get_constraintdef(oid) like '%pricing_model%'
  loop
    execute format('alter table public.yordam_kerak_posts drop constraint %I', c.conname);
  end loop;
end $$;

alter table public.yordam_kerak_posts
  add constraint yordam_kerak_posts_pricing_model_check
  check (pricing_model in ('negotiable', 'fixed', 'hourly', 'daily', 'monthly', 'unit'));

-- Requests written before this had an amount for the whole job, or none.
update public.yordam_kerak_posts
set pricing_model = 'fixed'
where pricing_model = 'negotiable'
  and price is not null
  and price > 0;

comment on column public.yordam_kerak_posts.pricing_model is
  'negotiable | fixed (whole job) | hourly | daily | monthly | unit';
comment on column public.xizmatlar.pricing_model is
  'negotiable | fixed (whole job) | hourly | daily | monthly | unit';

-- 4. Help-request alerts for providers --------------------------------------

alter table public.subsector_alert_subscriptions
  add column if not exists service_city text,
  add column if not exists from_service boolean not null default false;

comment on column public.subsector_alert_subscriptions.service_city is
  'Only requests in this city (null: any city)';
comment on column public.subsector_alert_subscriptions.from_service is
  'Made for the person''s own service, not by hand';

create or replace function public.subscribe_owner_to_help_posts()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.category_id is null or new.subcategory_id is null then
    return new;
  end if;

  insert into subsector_alert_subscriptions (
    user_id, category_id, subcategory_id, provider_type,
    alert_help_post, service_city, from_service
  )
  values (
    new.owner_id, new.category_id, new.subcategory_id, new.provider_type,
    true, new.service_city, true
  )
  on conflict (user_id, category_id, subcategory_id, provider_type)
  do update set service_city = excluded.service_city
  where subsector_alert_subscriptions.from_service;

  return new;
end;
$$;

drop trigger if exists trg_subscribe_owner_to_help_posts on public.xizmatlar;
create trigger trg_subscribe_owner_to_help_posts
  after insert or update of category_id, subcategory_id, provider_type, service_city
  on public.xizmatlar
  for each row execute function public.subscribe_owner_to_help_posts();

-- The services that already exist.
insert into public.subsector_alert_subscriptions (
  user_id, category_id, subcategory_id, provider_type,
  alert_help_post, service_city, from_service
)
select distinct on (x.owner_id, x.category_id, x.subcategory_id, x.provider_type)
  x.owner_id, x.category_id, x.subcategory_id, x.provider_type,
  true, x.service_city, true
from public.xizmatlar x
where x.category_id is not null
  and x.subcategory_id is not null
order by x.owner_id, x.category_id, x.subcategory_id, x.provider_type, x.created_at
on conflict (user_id, category_id, subcategory_id, provider_type) do nothing;

create or replace function public.notify_subsector_help_post()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status is distinct from 'open' then
    return new;
  end if;
  if new.subcategory_id is null or new.category_id is null then
    return new;
  end if;

  insert into notifications (user_id, type, payload)
  select distinct on (s.user_id)
    s.user_id,
    'subsector_help_post',
    jsonb_build_object(
      'title', 'Yordam kerak',
      'body', left(new.title, 120),
      'post_id', new.id,
      'category_id', new.category_id,
      'subcategory_id', new.subcategory_id,
      'service_city', new.service_city,
      'own_field', s.from_service
    )
  from subsector_alert_subscriptions s
  where s.alert_help_post
    and s.user_id <> new.author_id
    and s.category_id = new.category_id
    and s.subcategory_id = new.subcategory_id
    and (
      s.service_city is null
      or new.service_city is null
      or s.service_city = new.service_city
    )
    and public._subsector_users_not_blocked(s.user_id, new.author_id)
  order by s.user_id, s.from_service desc;

  return new;
end;
$$;

-- 5. Busy hours on a service page --------------------------------------------

alter table public.xizmatlar
  add column if not exists show_busy_hours boolean not null default false;

comment on column public.xizmatlar.show_busy_hours is
  'Everyone may see which hours the owner''s agreed appointments take';

create or replace function public.get_xizmat_busy_hours(
  p_xizmat uuid,
  p_from date,
  p_to date
)
returns table (day date, starts time, ends time)
language sql
stable
security definer
set search_path = public
as $$
  select
    k.start_date,
    k.start_time,
    case
      when k.start_time
           + make_interval(mins => coalesce(nullif(k.duration_minutes, 0), 60))
           < k.start_time
        then time '23:59'
      else k.start_time
           + make_interval(mins => coalesce(nullif(k.duration_minutes, 0), 60))
    end
  from xizmatlar x
  join kelishuvlar k
    on k.status = 'jarayonda'
   and (k.party_a_id = x.owner_id or k.party_b_id = x.owner_id)
  where x.id = p_xizmat
    and x.show_busy_hours
    and k.start_time is not null
    and k.start_date between p_from and least(p_to, p_from + 62)
  order by 1, 2;
$$;

revoke all on function public.get_xizmat_busy_hours(uuid, date, date) from public;
grant execute on function public.get_xizmat_busy_hours(uuid, date, date)
  to anon, authenticated;

-- New columns become readable through the API (see migration 023).
do $$
begin
  if to_regprocedure('public.refresh_public_column_grants()') is not null then
    perform public.refresh_public_column_grants();
  end if;
end $$;

notify pgrst, 'reload schema';
