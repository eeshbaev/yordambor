-- Dual bajarildi confirmation + account deletion RPC + pg_cron schedule

alter table kelishuvlar
  add column if not exists complete_a boolean not null default false,
  add column if not exists complete_b boolean not null default false,
  add column if not exists complete_a_at timestamptz,
  add column if not exists complete_b_at timestamptz;

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

grant execute on function public.delete_user_account() to authenticated;

-- Enable pg_cron in Supabase Dashboard → Database → Extensions, then run:
-- select cron.schedule(
--   'archive-stale-kelishuvlar',
--   '0 3 * * *',
--   $$ select public.archive_stale_kelishuvlar(); $$
-- );
