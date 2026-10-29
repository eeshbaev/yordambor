-- Migration 026 · Recurring appointments
-- Run in the Supabase SQL Editor (one-time).
--
-- Adds two optional columns to kelishuvlar:
--   recur_rule  – cadence: 'weekly', 'biweekly', or 'monthly'
--   recur_until – last date (inclusive) an occurrence may start on
--
-- Deals without recurrence leave both columns NULL.

alter table kelishuvlar
  add column if not exists recur_rule text
    check (recur_rule is null or recur_rule in ('weekly', 'biweekly', 'monthly')),
  add column if not exists recur_until date;

-- Ensure recur_until is only set when recur_rule is also set.
alter table kelishuvlar
  add constraint if not exists recur_until_requires_rule
    check (recur_until is null or recur_rule is not null);

comment on column kelishuvlar.recur_rule  is 'Repeating cadence: weekly | biweekly | monthly. NULL = one-off.';
comment on column kelishuvlar.recur_until is 'Last allowed occurrence start date (inclusive). NULL = open-ended recurrence.';
