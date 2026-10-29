-- Run after 024. Every row should say OK.
select
  check_name as "Check",
  case when actual = expected then 'OK' else 'PROBLEM' end as "Result"
from (
  values
    (1, 'Public phone functions installed',
        to_regprocedure('public.get_public_phone(uuid)') is not null
        and to_regprocedure('public.get_xizmat_public_phone(uuid)') is not null, true),
    (2, 'Visitors cannot ask for phones',
        not has_function_privilege('anon', 'public.get_public_phone(uuid)', 'execute')
        and not has_function_privilege('anon', 'public.get_xizmat_public_phone(uuid)', 'execute'), true),
    (3, 'Cancelled appointments send a notice',
        coalesce(pg_get_functiondef(to_regprocedure('public.notify_kelishuv_status()'))
                 like '%kelishuv_appointment_cancelled%', false), true),
    (4, 'Services can be priced per day, month or piece',
        exists (
          select 1 from pg_constraint
          where conname = 'xizmatlar_pricing_model_check'
            and pg_get_constraintdef(oid) like '%monthly%'
        ), true),
    (5, 'Help requests keep their price unit',
        exists (select 1 from information_schema.columns where table_schema = 'public'
                and table_name = 'yordam_kerak_posts' and column_name = 'pricing_model'), true),
    (6, 'No help request with an amount is left as negotiable',
        not exists (
          select 1 from public.yordam_kerak_posts
          where pricing_model = 'negotiable' and price > 0
        ), true),
    (7, 'New services subscribe their owner to help requests',
        exists (select 1 from pg_trigger
                where tgname = 'trg_subscribe_owner_to_help_posts'), true),
    (8, 'Every service has its help-request alert',
        not exists (
          select 1 from public.xizmatlar x
          where x.category_id is not null
            and x.subcategory_id is not null
            and not exists (
              select 1 from public.subsector_alert_subscriptions s
              where s.user_id = x.owner_id
                and s.category_id = x.category_id
                and s.subcategory_id = x.subcategory_id
                and s.provider_type = x.provider_type
            )
        ), true),
    (9, 'Busy hours off by default',
        exists (select 1 from information_schema.columns where table_schema = 'public'
                and table_name = 'xizmatlar' and column_name = 'show_busy_hours'
                and column_default = 'false'), true),
    (10, 'Busy-hours function installed',
        to_regprocedure('public.get_xizmat_busy_hours(uuid, date, date)') is not null, true)
) as t(n, check_name, actual, expected)
order by n;
