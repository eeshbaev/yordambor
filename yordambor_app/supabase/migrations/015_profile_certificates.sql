-- Provider licenses and certificates on public profile

create table if not exists profile_certificates (
  id uuid primary key default gen_random_uuid(),
  profile_id uuid not null references profiles(id) on delete cascade,
  title text not null,
  issuer text,
  image_url text not null,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  constraint profile_certificates_title_len check (char_length(trim(title)) >= 2)
);

create index if not exists profile_certificates_profile_id_idx
  on profile_certificates (profile_id, sort_order, created_at desc);

comment on table profile_certificates is
  'Licenses and certificates uploaded by providers for public profile display';

alter table profile_certificates enable row level security;

drop policy if exists "profile_certificates_public_read" on profile_certificates;
create policy "profile_certificates_public_read"
  on profile_certificates for select
  using (true);

drop policy if exists "profile_certificates_insert_own" on profile_certificates;
create policy "profile_certificates_insert_own"
  on profile_certificates for insert
  with check (auth.uid() = profile_id);

drop policy if exists "profile_certificates_update_own" on profile_certificates;
create policy "profile_certificates_update_own"
  on profile_certificates for update
  using (auth.uid() = profile_id);

drop policy if exists "profile_certificates_delete_own" on profile_certificates;
create policy "profile_certificates_delete_own"
  on profile_certificates for delete
  using (auth.uid() = profile_id);
