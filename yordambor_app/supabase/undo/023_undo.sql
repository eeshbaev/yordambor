-- Undo 023 only if the app misbehaves after it. This puts back the old,
-- unsafe state: phone numbers and emails become readable by anyone again.
-- The current app keeps working either way.

grant select on public.profiles, public.xizmatlar, public.yordam_kerak_posts
  to anon, authenticated;

drop function if exists public.login_email_for_phone(text, text);
drop function if exists public.get_my_profile();
drop function if exists public.get_my_xizmat_contact_phone(uuid);
drop function if exists public.refresh_public_column_grants();
drop table if exists public.login_attempts;

notify pgrst, 'reload schema';
