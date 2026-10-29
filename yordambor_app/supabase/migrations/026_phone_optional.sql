-- 026: A phone number is optional, and unique when given.
--
-- People who sign in with Google or Telegram have no phone yet; they add
-- one on the profile setup screen. Until now profiles.phone had to be set
-- and unique, so a second such person could not get a profile at all.
--
--   1. phone may be empty (NULL); "" is stored as NULL.
--   2. Two profiles cannot share the same number.
--
-- Safe to run twice. (From the Mac's 025_phone_unique, renumbered after
-- 025_server_side_rules.)

alter table public.profiles alter column phone drop not null;

update public.profiles
set phone = null
where phone is not null and btrim(phone) = '';

-- The old rule (unique on every value) is replaced by one that skips
-- missing numbers.
alter table public.profiles drop constraint if exists profiles_phone_key;

create unique index if not exists profiles_phone_unique_idx
  on public.profiles (phone)
  where phone is not null and phone <> '';

comment on column public.profiles.phone is
  'E.164 number, e.g. +998901234567. NULL until given (Google and Telegram '
  'sign-ins); two profiles never share one (profiles_phone_unique_idx).';

notify pgrst, 'reload schema';
