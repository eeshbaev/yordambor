-- 022: Free and busy days that clients can see, working hours, and at most
-- five services per account.
--
-- Before this runs the app keeps free/busy days and working hours on the
-- device only (as it always did) and uses the server as soon as these exist.

-- 1. Free and busy days, per person. "slots" holds the hours when only part
--    of the day is meant, e.g. [{"from": "10:00", "to": "12:00"}]; null means
--    the whole working day.
create table if not exists public.provider_day_marks (
  owner_id uuid not null references public.profiles(id) on delete cascade,
  day date not null,
  status text not null check (status in ('available', 'busy')),
  slots jsonb check (slots is null or jsonb_typeof(slots) = 'array'),
  updated_at timestamptz not null default now(),
  primary key (owner_id, day)
);

alter table public.provider_day_marks enable row level security;

-- Seeing when someone is free is the point, so anyone may read the marks;
-- only the person writes their own.
drop policy if exists "provider_day_marks_read" on public.provider_day_marks;
create policy "provider_day_marks_read" on public.provider_day_marks
  for select using (true);

drop policy if exists "provider_day_marks_insert_own" on public.provider_day_marks;
create policy "provider_day_marks_insert_own" on public.provider_day_marks
  for insert with check (auth.uid() = owner_id);

drop policy if exists "provider_day_marks_update_own" on public.provider_day_marks;
create policy "provider_day_marks_update_own" on public.provider_day_marks
  for update using (auth.uid() = owner_id) with check (auth.uid() = owner_id);

drop policy if exists "provider_day_marks_delete_own" on public.provider_day_marks;
create policy "provider_day_marks_delete_own" on public.provider_day_marks
  for delete using (auth.uid() = owner_id);

-- 2. Working hours: the person's usual day, and optionally a service's own
--    (for people with several services). A list of {"from", "to"} ranges;
--    null means the standard 9:00–13:00 and 14:00–18:00 (or, for a service,
--    its owner's hours).
alter table public.profiles
  add column if not exists working_hours jsonb
  check (working_hours is null or jsonb_typeof(working_hours) = 'array');

alter table public.xizmatlar
  add column if not exists working_hours jsonb
  check (working_hours is null or jsonb_typeof(working_hours) = 'array');

-- 3. At most five services per account. The app says so before the form;
--    this keeps it true on the server too.
create or replace function public.enforce_xizmat_limit()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if (select count(*) from xizmatlar where owner_id = new.owner_id) >= 5 then
    raise exception 'Maksimal 5 ta xizmat yaratish mumkin'
      using errcode = 'P0001';
  end if;
  return new;
end;
$$;

drop trigger if exists xizmatlar_limit_per_owner on public.xizmatlar;
create trigger xizmatlar_limit_per_owner
  before insert on public.xizmatlar
  for each row execute function public.enforce_xizmat_limit();

-- If 023 (hidden phones and emails) already ran, let the API read the new
-- column too.
do $$
begin
  if to_regprocedure('public.refresh_public_column_grants()') is not null then
    perform public.refresh_public_column_grants();
  end if;
end $$;

-- Let the API see the new table and columns at once.
notify pgrst, 'reload schema';
