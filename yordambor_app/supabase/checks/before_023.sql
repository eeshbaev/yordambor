-- Run before 023: which earlier updates your database already has.
-- Any "no" in the second column: run that migration file first.
select
  item as "Update",
  case when present then 'yes' else 'no' end as "Installed"
from (
  values
    (1, '019 offers expire after 10 days',
        coalesce(
          (select pg_get_functiondef(p.oid) like '%''rad''%'
           from pg_proc p join pg_namespace n on n.oid = p.pronamespace
           where n.nspname = 'public' and p.proname = 'archive_stale_kelishuvlar'
           limit 1),
          false)),
    (2, '020 city on help requests',
        exists (select 1 from information_schema.columns
                where table_schema = 'public' and table_name = 'yordam_kerak_posts'
                  and column_name = 'service_city')),
    (3, '021 contact card on requests',
        exists (select 1 from information_schema.columns
                where table_schema = 'public' and table_name = 'kelishuvlar'
                  and column_name = 'contact_phone')),
    (4, '022 shared calendar and working hours',
        exists (select 1 from information_schema.tables
                where table_schema = 'public' and table_name = 'provider_day_marks')),
    (5, '023 phone numbers and emails hidden',
        not has_column_privilege('anon', 'public.profiles', 'phone', 'select'))
) as t(n, item, present)
order by n;
