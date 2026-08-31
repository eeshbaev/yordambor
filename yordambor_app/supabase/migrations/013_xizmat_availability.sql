-- Provider-controlled availability on xizmat (manual only; not tied to Client Book).
alter table public.xizmatlar
  add column if not exists availability_visible boolean not null default false,
  add column if not exists availability_mode text
    check (availability_mode is null or availability_mode in ('available_now', 'busy', 'call_me')),
  add column if not exists availability_from timestamptz,
  add column if not exists availability_until timestamptz;

comment on column public.xizmatlar.availability_visible is
  'When false, no availability badge is shown publicly';
comment on column public.xizmatlar.availability_mode is
  'available_now | busy | call_me when availability_visible is true';

-- Legacy status=busy → visible busy mode.
update public.xizmatlar
set
  availability_visible = true,
  availability_mode = 'busy'
where status = 'busy';
