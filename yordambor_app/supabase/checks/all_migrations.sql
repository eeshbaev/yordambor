-- Which database updates your project has. Read-only: it changes nothing.
-- Any "no": run that file from supabase/migrations, in number order.
select
  migration as "Migration",
  case when present then 'yes' else 'no' end as "Installed"
from (
  values
    ('001 tables',
      to_regclass('public.profiles') is not null),
    ('002 access rules',
      exists (select 1 from pg_policies where schemaname = 'public'
              and tablename = 'profiles' and policyname = 'profiles_update_own')),
    ('003 categories',
      to_regclass('public.categories') is not null
      and exists (select 1 from public.categories)),
    ('004 photo storage',
      exists (select 1 from storage.buckets where id = 'portfolio')),
    ('005 review rules',
      exists (select 1 from pg_policies where schemaname = 'public'
              and tablename = 'reviews' and policyname = 'reviews_insert_participant')),
    ('006 blocks and reports',
      exists (select 1 from pg_policies where schemaname = 'public'
              and tablename = 'blocks' and policyname = 'blocks_insert_own')),
    ('007 deal notifications',
      exists (select 1 from pg_trigger where tgname = 'trg_notify_kelishuv_message')),
    ('008 archive and analytics',
      exists (select 1 from pg_policies where schemaname = 'public'
              and tablename = 'analytics_events' and policyname = 'analytics_insert_auth')),
    ('009 both sides confirm, account deletion',
      exists (select 1 from information_schema.columns where table_schema = 'public'
              and table_name = 'kelishuvlar' and column_name = 'complete_a')
      and to_regprocedure('public.delete_user_account()') is not null),
    ('010 notification links',
      coalesce(pg_get_functiondef(to_regprocedure('public.notify_kelishuv_created()'))
               like '%xizmat_id%', false)),
    ('011 contact preferences',
      exists (select 1 from information_schema.columns where table_schema = 'public'
              and table_name = 'xizmatlar' and column_name = 'show_contact_phone')),
    ('012 prices',
      exists (select 1 from information_schema.columns where table_schema = 'public'
              and table_name = 'xizmatlar' and column_name = 'pricing_model')),
    ('013 availability',
      exists (select 1 from information_schema.columns where table_schema = 'public'
              and table_name = 'xizmatlar' and column_name = 'availability_mode')),
    ('014 service promise',
      exists (select 1 from information_schema.columns where table_schema = 'public'
              and table_name = 'xizmatlar' and column_name = 'service_promise')),
    ('015 certificates',
      to_regclass('public.profile_certificates') is not null),
    ('016 support and feedback',
      to_regclass('public.support_tickets') is not null),
    ('017 city on services',
      exists (select 1 from information_schema.columns where table_schema = 'public'
              and table_name = 'xizmatlar' and column_name = 'service_city')),
    ('018 alerts',
      to_regclass('public.subsector_alert_subscriptions') is not null),
    ('019 offers expire after 10 days',
      coalesce(pg_get_functiondef(to_regprocedure('public.archive_stale_kelishuvlar()'))
               like '%''rad''%', false)),
    ('020 city on help requests',
      exists (select 1 from information_schema.columns where table_schema = 'public'
              and table_name = 'yordam_kerak_posts' and column_name = 'service_city')),
    ('021 contact card on requests',
      exists (select 1 from information_schema.columns where table_schema = 'public'
              and table_name = 'kelishuvlar' and column_name = 'contact_phone')),
    ('022 shared calendar and working hours',
      to_regclass('public.provider_day_marks') is not null),
    ('023 phone numbers and emails hidden',
      not has_column_privilege('anon', 'public.profiles', 'phone', 'select'))
) as t(migration, present)
order by migration;
