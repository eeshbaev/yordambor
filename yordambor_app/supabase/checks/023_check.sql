-- Run after 023. Every row should say OK.
select
  check_name as "Check",
  case when actual = expected then 'OK' else 'PROBLEM' end as "Result"
from (
  values
    (1, 'Phone numbers hidden from visitors',
        not has_column_privilege('anon', 'public.profiles', 'phone', 'select'), true),
    (2, 'Emails hidden from visitors',
        not has_column_privilege('anon', 'public.profiles', 'email', 'select'), true),
    (3, 'Phone numbers hidden from other signed-in users',
        not has_column_privilege('authenticated', 'public.profiles', 'phone', 'select'), true),
    (4, 'Emails hidden from other signed-in users',
        not has_column_privilege('authenticated', 'public.profiles', 'email', 'select'), true),
    (5, 'Listing contact phones hidden',
        not has_column_privilege('anon', 'public.xizmatlar', 'contact_phone', 'select'), true),
    (6, 'Help-request contact phones hidden',
        not has_column_privilege('anon', 'public.yordam_kerak_posts', 'contact_phone', 'select'), true),
    (7, 'Names and photos still visible',
        has_column_privilege('anon', 'public.profiles', 'full_name', 'select')
        and has_column_privilege('anon', 'public.profiles', 'avatar_url', 'select'), true),
    (8, 'Listings and help requests still visible',
        has_column_privilege('anon', 'public.xizmatlar', 'name', 'select')
        and has_column_privilege('anon', 'public.yordam_kerak_posts', 'title', 'select'), true),
    (9, 'Phone sign-in function installed',
        exists (select 1 from pg_proc where proname = 'login_email_for_phone'), true),
    (10, 'Own-profile function installed',
        exists (select 1 from pg_proc where proname = 'get_my_profile'), true),
    (11, 'Every other column readable (no columns left out)',
        not exists (
          select 1
          from information_schema.columns c
          where c.table_schema = 'public'
            and (c.table_name, c.column_name) not in (
              ('profiles', 'email'), ('profiles', 'phone'),
              ('xizmatlar', 'contact_phone'), ('yordam_kerak_posts', 'contact_phone')
            )
            and c.table_name in ('profiles', 'xizmatlar', 'yordam_kerak_posts')
            and not has_column_privilege('anon',
                  format('public.%I', c.table_name), c.column_name, 'select')
        ), true)
) as t(n, check_name, actual, expected)
order by n;
