-- 027: Appointments that repeat.
--
-- A deal can repeat weekly, every two weeks or monthly, until a given day
-- (or with no end). Deals that happen once leave both columns empty.
--
-- Safe to run twice. (From the Mac's 026_recurring_appointments,
-- renumbered.)

alter table public.kelishuvlar
  add column if not exists recur_rule text,
  add column if not exists recur_until date;

do $$
begin
  if not exists (
    select 1 from pg_constraint where conname = 'kelishuvlar_recur_rule_check'
  ) then
    alter table public.kelishuvlar
      add constraint kelishuvlar_recur_rule_check
      check (recur_rule is null or recur_rule in ('weekly', 'biweekly', 'monthly'));
  end if;
  if not exists (
    select 1 from pg_constraint where conname = 'recur_until_requires_rule'
  ) then
    alter table public.kelishuvlar
      add constraint recur_until_requires_rule
      check (recur_until is null or recur_rule is not null);
  end if;
end $$;

comment on column public.kelishuvlar.recur_rule is
  'Repeats: weekly | biweekly | monthly. NULL = once.';
comment on column public.kelishuvlar.recur_until is
  'Last day (inclusive) an occurrence may start. NULL = no end.';

-- New columns become readable through the API (see migration 023).
do $$
begin
  if to_regprocedure('public.refresh_public_column_grants()') is not null then
    perform public.refresh_public_column_grants();
  end if;
end $$;

notify pgrst, 'reload schema';
