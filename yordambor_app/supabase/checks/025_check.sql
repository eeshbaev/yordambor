-- Run after 025. Every row should say OK.
select
  check_name as "Check",
  case when actual = expected then 'OK' else 'PROBLEM' end as "Result"
from (
  values
    (1, 'Only the two sides write in a deal chat',
        coalesce((select pg_get_expr(polwithcheck, polrelid) from pg_policy
                  where polname = 'kelishuv_msg_insert') like '%party_a_id%', false), true),
    (2, 'Deal rules kept by the server',
        exists (select 1 from pg_trigger where tgname = 'trg_guard_kelishuv'), true),
    (3, 'Reviews only from a finished deal, for its service',
        coalesce((select pg_get_expr(polwithcheck, polrelid) from pg_policy
                  where polname = 'reviews_insert_participant') like '%xizmat_id%', false), true),
    (4, 'Providers only reply to reviews',
        exists (select 1 from pg_trigger where tgname = 'trg_guard_review'), true),
    (5, 'Ratings and counts kept by the server',
        exists (select 1 from pg_trigger where tgname = 'trg_guard_xizmat_counts')
        and exists (select 1 from pg_trigger where tgname = 'trg_review_changed')
        and exists (select 1 from pg_trigger where tgname = 'trg_kelishuv_done'), true),
    (6, 'Ratings match the reviews',
        not exists (
          select 1 from public.xizmatlar x
          where x.review_count <> (select count(*) from public.reviews r where r.xizmat_id = x.id)
        ), true),
    (7, 'Old deals and services can be removed',
        (select confdeltype from pg_constraint where conname = 'reviews_kelishuv_id_fkey') = 'n'
        and (select confdeltype from pg_constraint where conname = 'kelishuvlar_xizmat_id_fkey') = 'n', true),
    (8, 'Account deletion removes the sign-in',
        coalesce(pg_get_functiondef(to_regprocedure('public.delete_user_account()'))
                 like '%auth.users%', false), true),
    (9, 'Deal chats are live',
        exists (select 1 from pg_publication_tables
                where pubname = 'supabase_realtime' and tablename = 'kelishuv_messages')
        and exists (select 1 from pg_publication_tables
                    where pubname = 'supabase_realtime' and tablename = 'kelishuvlar'), true),
    (10, 'A view counts once a day',
        exists (select 1 from pg_trigger where tgname = 'trg_dedupe_view'), true),
    (11, 'Badges only when earned',
        exists (select 1 from pg_trigger where tgname = 'trg_guard_achievement'), true)
) as t(n, check_name, actual, expected)
order by n;
