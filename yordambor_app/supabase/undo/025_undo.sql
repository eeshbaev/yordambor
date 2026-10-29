-- Undo 025 only if the app misbehaves after it. This puts back the old
-- state, in which the app alone keeps the rules of deals and reviews.

drop trigger if exists trg_guard_kelishuv on public.kelishuvlar;
drop trigger if exists trg_kelishuv_done on public.kelishuvlar;
drop trigger if exists trg_guard_review on public.reviews;
drop trigger if exists trg_review_changed on public.reviews;
drop trigger if exists trg_guard_xizmat_counts on public.xizmatlar;
drop trigger if exists trg_dedupe_view on public.analytics_events;
drop trigger if exists trg_guard_achievement on public.profile_achievements;
drop function if exists public.guard_kelishuv();
drop function if exists public.on_kelishuv_done();
drop function if exists public.guard_review();
drop function if exists public.on_review_changed();
drop function if exists public.refresh_xizmat_rating(uuid);
drop function if exists public.guard_xizmat_counts();
drop function if exists public.dedupe_view();
drop function if exists public.guard_achievement();

drop policy if exists "kelishuv_msg_insert" on public.kelishuv_messages;
create policy "kelishuv_msg_insert" on public.kelishuv_messages for insert
  with check (auth.uid() = sender_id);
drop policy if exists "kelishuv_insert" on public.kelishuvlar;
create policy "kelishuv_insert" on public.kelishuvlar for insert
  with check (auth.uid() = party_a_id or auth.uid() = party_b_id);
drop policy if exists "kelishuv_update" on public.kelishuvlar;
create policy "kelishuv_update" on public.kelishuvlar for update
  using (auth.uid() = party_a_id or auth.uid() = party_b_id);
drop policy if exists "reviews_insert_participant" on public.reviews;
create policy "reviews_insert_participant" on public.reviews for insert
  with check (
    auth.uid() = reviewer_id
    and exists (
      select 1 from kelishuvlar k
      where k.id = kelishuv_id
        and k.status = 'bajarildi'
        and (k.party_a_id = auth.uid() or k.party_b_id = auth.uid())
    )
  );

-- The references keep their new on-delete rules (they only stop removals
-- from failing), and deal chats stay live.

-- Account deletion as in migration 009.
create or replace function public.delete_user_account()
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  uid uuid := auth.uid();
begin
  if uid is null then
    raise exception 'Not authenticated';
  end if;

  update kelishuvlar
  set status = 'bekor', updated_at = now()
  where (party_a_id = uid or party_b_id = uid)
    and status in ('muzokarada', 'jarayonda');

  update yordam_kerak_posts
  set status = 'deleted'
  where author_id = uid and status = 'open';

  delete from xizmatlar where owner_id = uid;

  delete from reviews
  where reviewer_id = uid
     or kelishuv_id in (
       select id from kelishuvlar
       where party_a_id = uid or party_b_id = uid
     );

  delete from kelishuvlar
  where party_a_id = uid or party_b_id = uid;

  delete from favorites where user_id = uid;
  delete from blocks where blocker_id = uid or blocked_id = uid;
  delete from notifications where user_id = uid;
  delete from reports where reporter_id = uid;

  delete from profiles where id = uid;
end;
$$;

drop function if exists public._is_trusted();
drop function if exists public._trusted_write(boolean);

notify pgrst, 'reload schema';
