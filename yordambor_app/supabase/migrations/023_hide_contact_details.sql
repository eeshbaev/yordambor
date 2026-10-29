-- 023: Phone numbers and emails are no longer readable by everyone.
--
-- Until now any copy of the app (its public key is inside every install)
-- could read every user's email and phone, and the contact phone on every
-- listing and help request, straight from the database. After this:
--
--   * profiles.email, profiles.phone, xizmatlar.contact_phone and
--     yordam_kerak_posts.contact_phone can't be read, filtered or sorted on
--     through the API by anyone. Everything else stays readable as before.
--   * You read your own profile through get_my_profile(), and the phone on
--     your own listing through get_my_xizmat_contact_phone().
--   * Signing in with a phone number goes through login_email_for_phone():
--     it gives the account's email only to someone who also gives the right
--     password, and allows 5 wrong tries per number in 15 minutes.
--
-- Writing is unchanged: people still save their own phone and email.
--
-- Run it only after the app version that reads through these functions is
-- installed (it works before and after this migration). Safe to run twice.
-- Undo: supabase/undo/023_undo.sql. Check: supabase/checks/023_check.sql.
--
-- For later migrations: a new column on profiles, xizmatlar or
-- yordam_kerak_posts is not readable through the API until you run
--   select public.refresh_public_column_grants();

create extension if not exists pgcrypto with schema extensions;

-- 1. Which columns the API may read: all, except the private ones.
create or replace function public.refresh_public_column_grants()
returns void
language plpgsql
set search_path = public
as $$
declare
  target record;
  readable text;
begin
  for target in
    select *
    from (values
      ('profiles', array['email', 'phone']),
      ('xizmatlar', array['contact_phone']),
      ('yordam_kerak_posts', array['contact_phone'])
    ) as t(table_name, private_columns)
  loop
    select string_agg(quote_ident(c.column_name), ', ' order by c.ordinal_position)
      into readable
    from information_schema.columns c
    where c.table_schema = 'public'
      and c.table_name = target.table_name
      and c.column_name <> all (target.private_columns);

    execute format(
      'revoke select on public.%I from anon, authenticated',
      target.table_name
    );
    execute format(
      'revoke select (%s) on public.%I from anon, authenticated',
      (select string_agg(quote_ident(col), ', ') from unnest(target.private_columns) col),
      target.table_name
    );
    execute format(
      'grant select (%s) on public.%I to anon, authenticated',
      readable,
      target.table_name
    );
  end loop;
end;
$$;

-- Only the database owner runs this, from migrations.
revoke all on function public.refresh_public_column_grants() from public, anon, authenticated;

select public.refresh_public_column_grants();

-- 2. Your own profile, with your email and phone.
create or replace function public.get_my_profile()
returns setof public.profiles
language sql
stable
security definer
set search_path = public
as $$
  select * from public.profiles where id = auth.uid();
$$;

revoke all on function public.get_my_profile() from public, anon;
grant execute on function public.get_my_profile() to authenticated;

-- 3. The contact phone on one of your own listings (for editing it).
create or replace function public.get_my_xizmat_contact_phone(p_xizmat_id uuid)
returns text
language sql
stable
security definer
set search_path = public
as $$
  select x.contact_phone
  from public.xizmatlar x
  where x.id = p_xizmat_id
    and x.owner_id = auth.uid();
$$;

revoke all on function public.get_my_xizmat_contact_phone(uuid) from public, anon;
grant execute on function public.get_my_xizmat_contact_phone(uuid) to authenticated;

-- 4. Signing in with a phone number.
--    Wrong tries are counted per number; nobody can read this table.
create table if not exists public.login_attempts (
  phone text not null,
  attempted_at timestamptz not null default now()
);

create index if not exists login_attempts_phone_time_idx
  on public.login_attempts (phone, attempted_at desc);

alter table public.login_attempts enable row level security;
revoke all on public.login_attempts from anon, authenticated;

create or replace function public.login_email_for_phone(
  p_phone text,
  p_password text
)
returns text
language plpgsql
volatile
security definer
set search_path = public, extensions
as $$
declare
  v_phone text := btrim(coalesce(p_phone, ''));
  v_email text;
  v_hash text;
  v_tries integer;
  -- Checked when the number is unknown too, so an answer takes as long
  -- either way and does not tell whether the number is registered.
  c_dummy constant text :=
    '$2a$10$.4D1PQshLCzteE2tzZIP2uiA84qFx7hPoM.07SmxDn5cWVotGX6/q';
begin
  if v_phone = '' or coalesce(p_password, '') = '' then
    return null;
  end if;

  select count(*) into v_tries
  from public.login_attempts
  where phone = v_phone
    and attempted_at > now() - interval '15 minutes';

  if v_tries >= 5 then
    raise exception 'too_many_attempts' using errcode = 'P0001';
  end if;

  select u.email, u.encrypted_password
    into v_email, v_hash
  from public.profiles p
  join auth.users u on u.id = p.id
  where p.phone = v_phone
  limit 1;

  if v_hash is not null
     and v_hash <> ''
     and crypt(p_password, v_hash) = v_hash then
    delete from public.login_attempts where phone = v_phone;
    return v_email;
  end if;

  perform crypt(p_password, c_dummy);
  insert into public.login_attempts (phone) values (v_phone);
  delete from public.login_attempts
  where attempted_at < now() - interval '1 day';
  return null;
end;
$$;

revoke all on function public.login_email_for_phone(text, text) from public;
grant execute on function public.login_email_for_phone(text, text) to anon, authenticated;

-- Let the API see the new functions at once.
notify pgrst, 'reload schema';
