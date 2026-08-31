-- Archive stale kelishuvlar + analytics policies

create or replace function public.archive_stale_kelishuvlar()
returns integer
language plpgsql
security definer
set search_path = public
as $$
declare
  archived_count integer := 0;
  batch integer;
begin
  update kelishuvlar
  set
    status = 'archived',
    archive_at = now(),
    delete_at = now() + interval '15 days',
    updated_at = now()
  where status = 'muzokarada'
    and updated_at < now() - interval '10 days';
  get diagnostics batch = row_count;
  archived_count := archived_count + batch;

  update kelishuvlar
  set
    status = 'archived',
    archive_at = now(),
    delete_at = now() + interval '10 days',
    updated_at = now()
  where status = 'bekor'
    and updated_at < now() - interval '5 days';
  get diagnostics batch = row_count;
  archived_count := archived_count + batch;

  update kelishuvlar
  set
    status = 'archived',
    archive_at = coalesce(archive_at, now()),
    delete_at = now() + interval '30 days',
    updated_at = now()
  where status = 'bajarildi'
    and coalesce(bajarildi_at, updated_at) < now() - interval '10 days';
  get diagnostics batch = row_count;
  archived_count := archived_count + batch;

  delete from kelishuvlar
  where delete_at is not null
    and delete_at < now()
    and status = 'archived';

  return archived_count;
end;
$$;

-- Analytics: anyone authenticated can log views; owners can read their xizmat stats
create policy "analytics_insert_auth" on analytics_events for insert
  with check (auth.uid() is not null);

create policy "analytics_read_xizmat_owner" on analytics_events for select
  using (
    exists (
      select 1 from xizmatlar x
      where x.id = analytics_events.xizmat_id
        and x.owner_id = auth.uid()
    )
  );

create policy "favorites_read_xizmat_owner" on favorites for select
  using (
    exists (
      select 1 from xizmatlar x
      where x.id = favorites.xizmat_id
        and x.owner_id = auth.uid()
    )
  );

-- Schedule daily archive via pg_cron when available (Supabase Dashboard → Database → Extensions)
-- select cron.schedule(
--   'archive-stale-kelishuvlar',
--   '0 3 * * *',
--   $$ select public.archive_stale_kelishuvlar(); $$
-- );
