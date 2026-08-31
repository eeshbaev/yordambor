-- RLS for blocks and reports

create policy "blocks_read_involving_me" on blocks for select
  using (auth.uid() = blocker_id or auth.uid() = blocked_id);

create policy "blocks_insert_own" on blocks for insert
  with check (auth.uid() = blocker_id and blocker_id <> blocked_id);

create policy "blocks_delete_own" on blocks for delete
  using (auth.uid() = blocker_id);

create policy "reports_insert_own" on reports for insert
  with check (auth.uid() = reporter_id);

create policy "reports_read_own" on reports for select
  using (auth.uid() = reporter_id);
