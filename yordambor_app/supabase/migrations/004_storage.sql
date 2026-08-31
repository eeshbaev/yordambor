-- Storage bucket for portfolio images

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values (
  'portfolio',
  'portfolio',
  true,
  5242880,
  array['image/jpeg', 'image/png', 'image/webp']
)
on conflict (id) do update set
  public = excluded.public,
  file_size_limit = excluded.file_size_limit,
  allowed_mime_types = excluded.allowed_mime_types;

drop policy if exists "portfolio_public_read" on storage.objects;
create policy "portfolio_public_read"
  on storage.objects for select
  using (bucket_id = 'portfolio');

drop policy if exists "portfolio_auth_insert" on storage.objects;
create policy "portfolio_auth_insert"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'portfolio'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

drop policy if exists "portfolio_auth_update" on storage.objects;
create policy "portfolio_auth_update"
  on storage.objects for update
  to authenticated
  using (
    bucket_id = 'portfolio'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

drop policy if exists "portfolio_auth_delete" on storage.objects;
create policy "portfolio_auth_delete"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'portfolio'
    and auth.uid()::text = (storage.foldername(name))[1]
  );
