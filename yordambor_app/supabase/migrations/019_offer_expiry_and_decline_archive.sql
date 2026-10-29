-- 019: Offers wait 10 days for an answer; declined and cancelled deals stay
-- visible for 5 days, then move to the archive.
--
-- The app records the sender's acceptance with every offer (and with new
-- terms), so the offer's time is the latest acceptance, else the creation.
-- If the other side neither accepts, declines nor sends new terms within
-- 10 days, the offer is cancelled ('bekor'); the status trigger then tells
-- both people. The app applies the same rule whenever it loads a deal, so
-- the result is the same before this job first runs.

create or replace function public.archive_stale_kelishuvlar()
returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  changed integer := 0;
  batch integer;
begin
  -- Unanswered offers: cancelled 10 days after they were sent.
  update kelishuvlar
  set
    status = 'bekor',
    updated_at = now()
  where status = 'muzokarada'
    and greatest(
      case when accept_a then accept_a_at end,
      case when accept_b then accept_b_at end,
      created_at
    ) < now() - interval '10 days';
  get diagnostics batch = row_count;
  changed := changed + batch;

  -- Declined and cancelled deals: in notifications for 5 days, then archived.
  update kelishuvlar
  set
    status = 'archived',
    archive_at = now(),
    delete_at = now() + interval '10 days',
    updated_at = now()
  where status in ('bekor', 'rad')
    and updated_at < now() - interval '5 days';
  get diagnostics batch = row_count;
  changed := changed + batch;

  -- Finished deals: archived after 10 days (as before).
  update kelishuvlar
  set
    status = 'archived',
    archive_at = coalesce(archive_at, now()),
    delete_at = now() + interval '30 days',
    updated_at = now()
  where status = 'bajarildi'
    and coalesce(bajarildi_at, updated_at) < now() - interval '10 days';
  get diagnostics batch = row_count;
  changed := changed + batch;

  -- As before: archived rows are removed once their delete_at has passed.
  delete from kelishuvlar
  where delete_at is not null
    and delete_at < now()
    and status = 'archived';

  return changed;
end;
$$;

-- Run it daily. Enable pg_cron first (Supabase Dashboard → Database →
-- Extensions), then run once in the SQL editor:
-- select cron.schedule(
--   'archive-stale-kelishuvlar',
--   '0 3 * * *',
--   $$ select public.archive_stale_kelishuvlar(); $$
-- );
