-- Migration 025: sparse UNIQUE constraint on profiles.phone
-- Empty strings are treated as "no phone" (allow many), NULLs too.
-- Only non-empty, non-null values must be unique.
-- Run in Supabase SQL Editor.

-- 1. Normalise: replace '' with NULL so existing "no phone" rows
--    do not conflict with each other.
UPDATE public.profiles
SET phone = NULL
WHERE phone IS NOT NULL AND phone = '';

-- 2. Sparse unique index: ignores NULL and empty-string rows.
--    Using an index (not ALTER TABLE ADD CONSTRAINT) so we can add
--    the WHERE clause.
CREATE UNIQUE INDEX IF NOT EXISTS profiles_phone_unique_idx
  ON public.profiles (phone)
  WHERE phone IS NOT NULL AND phone <> '';

-- 3. Helpful comment for future developers.
COMMENT ON COLUMN public.profiles.phone IS
  'E.164 phone number, e.g. +998901234567.
   NULL = not yet provided (allowed for existing / social-auth users).
   Non-null values must be globally unique (see profiles_phone_unique_idx).';
