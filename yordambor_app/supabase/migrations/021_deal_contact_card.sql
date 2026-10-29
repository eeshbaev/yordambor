-- 021: A request carries the sender's card: name, family name and phone,
-- prefilled from their profile, so the other side can reach them.
--
-- Until this runs, the app puts the card at the top of the request message
-- instead; once these columns exist it uses them.

alter table public.kelishuvlar
  add column if not exists contact_first_name text,
  add column if not exists contact_last_name text,
  add column if not exists contact_phone text;

-- Kept short: a name and a phone number, nothing else.
alter table public.kelishuvlar
  drop constraint if exists kelishuvlar_contact_lengths_check;
alter table public.kelishuvlar
  add constraint kelishuvlar_contact_lengths_check
  check (
    coalesce(char_length(contact_first_name), 0) <= 80
    and coalesce(char_length(contact_last_name), 0) <= 80
    and coalesce(char_length(contact_phone), 0) <= 32
  );

-- Let the API see the new columns at once.
notify pgrst, 'reload schema';
