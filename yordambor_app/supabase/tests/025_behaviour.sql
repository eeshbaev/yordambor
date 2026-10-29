-- 025: what the app does still works; what it never does is refused.
-- Prints one line per case: "ok" for each, "PROBLEM" for any that is not.
\set ON_ERROR_STOP 1
\pset footer off
\pset tuples_only on

create temporary table results (n serial, name text, ok boolean);
grant all on results to authenticated, anon;
grant usage on sequence results_n_seq to authenticated, anon;

-- Runs [sql] as whoever is acting now; it should succeed, and a change
-- should change a row.
create or replace function pg_temp.should_work(name text, sql text)
returns void language plpgsql as $$
declare
  changed integer;
begin
  execute sql;
  get diagnostics changed = row_count;
  insert into results (name, ok)
  values (name, changed > 0 or sql ~* '^\s*select');
exception when others then
  insert into results (name, ok) values (name || ' — ' || sqlerrm, false);
end $$;

-- Runs [sql] as whoever is acting now; it should be refused (an error,
-- or nothing changed).
create or replace function pg_temp.should_fail(name text, sql text)
returns void language plpgsql as $$
declare
  changed integer;
begin
  execute sql;
  get diagnostics changed = row_count;
  insert into results (name, ok) values (name, changed = 0);
exception when others then
  insert into results (name, ok) values (name, true);
end $$;

create or replace function pg_temp.act_as(who text)
returns void language sql as $$
  select set_config('request.jwt.claim.sub', who, false);
$$;

-- People: A client, B provider, C outsider, D another provider.
insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-00000000000a', 'a@x'),
  ('00000000-0000-0000-0000-00000000000b', 'b@x'),
  ('00000000-0000-0000-0000-00000000000c', 'c@x'),
  ('00000000-0000-0000-0000-00000000000d', 'd@x');
insert into profiles (id, full_name, email, phone) values
  ('00000000-0000-0000-0000-00000000000a', 'A', 'a@x', '+1'),
  ('00000000-0000-0000-0000-00000000000b', 'B', 'b@x', '+2'),
  ('00000000-0000-0000-0000-00000000000c', 'C', 'c@x', '+3'),
  ('00000000-0000-0000-0000-00000000000d', 'D', 'd@x', '+4')
on conflict do nothing;
insert into xizmatlar (id, owner_id, name, provider_type, category_id, subcategory_id)
select '00000000-0000-0000-0000-0000000000f1', '00000000-0000-0000-0000-00000000000b',
       'B svc', 'individual', id, 'cleaning' from categories limit 1;
insert into xizmatlar (id, owner_id, name, provider_type, category_id, subcategory_id)
select '00000000-0000-0000-0000-0000000000f2', '00000000-0000-0000-0000-00000000000d',
       'D svc', 'individual', id, 'cleaning' from categories limit 1;

set role authenticated;

-- The honest path, as the app takes it.
select pg_temp.act_as('00000000-0000-0000-0000-00000000000a');
select pg_temp.should_work('client sends an offer', $q$
  insert into kelishuvlar (id, xizmat_id, party_a_id, party_b_id, initiator_id, status, price)
  values ('00000000-0000-0000-0000-0000000000e1', '00000000-0000-0000-0000-0000000000f1',
          '00000000-0000-0000-0000-00000000000a', '00000000-0000-0000-0000-00000000000b',
          '00000000-0000-0000-0000-00000000000a', 'muzokarada', 100000) $q$);
select pg_temp.should_work('client accepts their own offer', $q$
  update kelishuvlar set accept_a = true where id = '00000000-0000-0000-0000-0000000000e1' $q$);
select pg_temp.should_fail('a second open offer for the same service', $q$
  insert into kelishuvlar (xizmat_id, party_a_id, party_b_id, initiator_id, status)
  values ('00000000-0000-0000-0000-0000000000f1', '00000000-0000-0000-0000-00000000000a',
          '00000000-0000-0000-0000-00000000000b', '00000000-0000-0000-0000-00000000000a', 'muzokarada') $q$);
select pg_temp.should_work('client writes in the chat', $q$
  insert into kelishuv_messages (kelishuv_id, sender_id, content)
  values ('00000000-0000-0000-0000-0000000000e1', '00000000-0000-0000-0000-00000000000a', 'salom') $q$);

select pg_temp.act_as('00000000-0000-0000-0000-00000000000b');
select pg_temp.should_work('provider sends new terms', $q$
  update kelishuvlar set price = 120000, accept_b = true, accept_a = false
  where id = '00000000-0000-0000-0000-0000000000e1' $q$);
select pg_temp.act_as('00000000-0000-0000-0000-00000000000a');
select pg_temp.should_work('client accepts: the deal is agreed', $q$
  update kelishuvlar set accept_a = true, status = 'jarayonda'
  where id = '00000000-0000-0000-0000-0000000000e1' $q$);
select pg_temp.should_fail('done the same day', $q$
  update kelishuvlar set complete_a = true where id = '00000000-0000-0000-0000-0000000000e1' $q$);

-- Three days pass.
reset role;
select pg_temp.act_as('');
update kelishuvlar set jarayonda_at = now() - interval '4 days'
where id = '00000000-0000-0000-0000-0000000000e1';
set role authenticated;
select pg_temp.act_as('00000000-0000-0000-0000-00000000000a');

select pg_temp.should_fail('client says the provider is done', $q$
  update kelishuvlar set complete_b = true where id = '00000000-0000-0000-0000-0000000000e1' $q$);
select pg_temp.should_fail('client marks it done alone', $q$
  update kelishuvlar set complete_a = true, status = 'bajarildi'
  where id = '00000000-0000-0000-0000-0000000000e1' $q$);
select pg_temp.should_work('client confirms done', $q$
  update kelishuvlar set complete_a = true where id = '00000000-0000-0000-0000-0000000000e1' $q$);
select pg_temp.act_as('00000000-0000-0000-0000-00000000000b');
select pg_temp.should_work('provider confirms: the deal is done', $q$
  update kelishuvlar set complete_b = true, status = 'bajarildi'
  where id = '00000000-0000-0000-0000-0000000000e1' $q$);
select pg_temp.should_fail('provider sets their own count', $q$
  update xizmatlar set completed_count = 99, rating_avg = 5
  where id = '00000000-0000-0000-0000-0000000000f1' and (completed_count = 99 or rating_avg = 5) $q$);
select pg_temp.should_fail('provider reviews their own service', $q$
  insert into reviews (kelishuv_id, reviewer_id, xizmat_id, rating)
  values ('00000000-0000-0000-0000-0000000000e1', '00000000-0000-0000-0000-00000000000b',
          '00000000-0000-0000-0000-0000000000f1', 5) $q$);

select pg_temp.act_as('00000000-0000-0000-0000-00000000000a');
select pg_temp.should_fail('client reviews another service with this deal', $q$
  insert into reviews (kelishuv_id, reviewer_id, xizmat_id, rating)
  values ('00000000-0000-0000-0000-0000000000e1', '00000000-0000-0000-0000-00000000000a',
          '00000000-0000-0000-0000-0000000000f2', 1) $q$);
select pg_temp.should_work('client reviews the service', $q$
  insert into reviews (id, kelishuv_id, reviewer_id, xizmat_id, rating)
  values ('00000000-0000-0000-0000-0000000000a9', '00000000-0000-0000-0000-0000000000e1',
          '00000000-0000-0000-0000-00000000000a', '00000000-0000-0000-0000-0000000000f1', 4) $q$);
select pg_temp.should_fail('a closed deal changes', $q$
  update kelishuvlar set price = 1 where id = '00000000-0000-0000-0000-0000000000e1' $q$);

select pg_temp.act_as('00000000-0000-0000-0000-00000000000b');
select pg_temp.should_work('provider replies to the review', $q$
  update reviews set provider_reply = 'Rahmat' where id = '00000000-0000-0000-0000-0000000000a9' $q$);
select pg_temp.should_fail('provider changes the rating', $q$
  update reviews set rating = 5 where id = '00000000-0000-0000-0000-0000000000a9' $q$);

reset role;
select pg_temp.act_as('');
insert into results (name, ok)
select 'rating and counts kept by the server',
       rating_avg = 4 and review_count = 1 and completed_count = 1
from xizmatlar where id = '00000000-0000-0000-0000-0000000000f1';
set role authenticated;

-- What only someone calling the API directly would try.
select pg_temp.act_as('00000000-0000-0000-0000-00000000000c');
select pg_temp.should_fail('an outsider writes in a deal chat', $q$
  insert into kelishuv_messages (kelishuv_id, sender_id, content)
  values ('00000000-0000-0000-0000-0000000000e1', '00000000-0000-0000-0000-00000000000c', 'spam') $q$);
select pg_temp.should_fail('a deal that starts as done', $q$
  insert into kelishuvlar (xizmat_id, party_a_id, party_b_id, initiator_id, status, accept_a, accept_b, complete_a, complete_b)
  values ('00000000-0000-0000-0000-0000000000f2', '00000000-0000-0000-0000-00000000000c',
          '00000000-0000-0000-0000-00000000000d', '00000000-0000-0000-0000-00000000000c',
          'bajarildi', true, true, true, true) $q$);
select pg_temp.should_fail('a deal sent in someone else''s name', $q$
  insert into kelishuvlar (xizmat_id, party_a_id, party_b_id, initiator_id, status)
  values ('00000000-0000-0000-0000-0000000000f2', '00000000-0000-0000-0000-00000000000c',
          '00000000-0000-0000-0000-00000000000d', '00000000-0000-0000-0000-00000000000d', 'muzokarada') $q$);
select pg_temp.should_fail('a deal about a service with someone not its owner', $q$
  insert into kelishuvlar (xizmat_id, party_a_id, party_b_id, initiator_id, status)
  values ('00000000-0000-0000-0000-0000000000f2', '00000000-0000-0000-0000-00000000000c',
          '00000000-0000-0000-0000-00000000000a', '00000000-0000-0000-0000-00000000000c', 'muzokarada') $q$);

select pg_temp.should_work('C sends an honest offer to D', $q$
  insert into kelishuvlar (id, xizmat_id, party_a_id, party_b_id, initiator_id, status)
  values ('00000000-0000-0000-0000-0000000000e2', '00000000-0000-0000-0000-0000000000f2',
          '00000000-0000-0000-0000-00000000000c', '00000000-0000-0000-0000-00000000000d',
          '00000000-0000-0000-0000-00000000000c', 'muzokarada') $q$);
select pg_temp.should_fail('C accepts for D', $q$
  update kelishuvlar set accept_b = true where id = '00000000-0000-0000-0000-0000000000e2' $q$);
select pg_temp.should_fail('C agrees the deal alone', $q$
  update kelishuvlar set accept_a = true, status = 'jarayonda' where id = '00000000-0000-0000-0000-0000000000e2' $q$);
select pg_temp.should_fail('C swaps the other side', $q$
  update kelishuvlar set party_b_id = '00000000-0000-0000-0000-00000000000b' where id = '00000000-0000-0000-0000-0000000000e2' $q$);
select pg_temp.should_work('C cancels the offer', $q$
  update kelishuvlar set status = 'bekor' where id = '00000000-0000-0000-0000-0000000000e2' $q$);

-- Views: once a day, never by the owner.
select pg_temp.should_work('a view', $q$
  insert into analytics_events (xizmat_id, event_type) values ('00000000-0000-0000-0000-0000000000f1', 'view') $q$);
select pg_temp.should_fail('the same view again is not counted', $q$
  insert into analytics_events (xizmat_id, event_type) values ('00000000-0000-0000-0000-0000000000f1', 'view') $q$);
reset role;
select pg_temp.act_as('');
insert into results (name, ok)
select 'a view counts once a day', count(*) = 1
from analytics_events where xizmat_id = '00000000-0000-0000-0000-0000000000f1';
set role authenticated;

-- The provider deletes their account: past deal, review and all.
select pg_temp.act_as('00000000-0000-0000-0000-00000000000b');
select pg_temp.should_work('a provider with past deals deletes their account', $q$
  select public.delete_user_account() $q$);
reset role;
select pg_temp.act_as('');
insert into results (name, ok)
select 'their profile, service and sign-in are gone',
       not exists (select 1 from profiles where id = '00000000-0000-0000-0000-00000000000b')
   and not exists (select 1 from xizmatlar where owner_id = '00000000-0000-0000-0000-00000000000b')
   and not exists (select 1 from auth.users where id = '00000000-0000-0000-0000-00000000000b');

-- The nightly clean-up clears an old reviewed deal.
insert into kelishuvlar (id, xizmat_id, party_a_id, party_b_id, initiator_id, status, bajarildi_at, delete_at)
values ('00000000-0000-0000-0000-0000000000e3', '00000000-0000-0000-0000-0000000000f2',
        '00000000-0000-0000-0000-00000000000a', '00000000-0000-0000-0000-00000000000d',
        '00000000-0000-0000-0000-00000000000a', 'archived', now() - interval '60 days', now() - interval '1 day');
insert into reviews (kelishuv_id, reviewer_id, xizmat_id, rating)
values ('00000000-0000-0000-0000-0000000000e3', '00000000-0000-0000-0000-00000000000a',
        '00000000-0000-0000-0000-0000000000f2', 5);
select pg_temp.should_work('clean-up removes an old reviewed deal', $q$
  select public.archive_stale_kelishuvlar() $q$);
insert into results (name, ok)
select 'the review stays', exists (
  select 1 from reviews where xizmat_id = '00000000-0000-0000-0000-0000000000f2' and kelishuv_id is null);

select case when ok then 'ok       ' else 'PROBLEM  ' end || name from results order by n;
