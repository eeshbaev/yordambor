\set ON_ERROR_STOP 1
\pset footer off
begin;
insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000a1', 'p@x'), ('00000000-0000-0000-0000-0000000000b2', 'c@x');
insert into profiles (id, full_name, email, phone, show_phone, avatar_url) values
  ('00000000-0000-0000-0000-0000000000a1', 'Provider', 'p@x', '+998901111111', true, 'https://a/p.png'),
  ('00000000-0000-0000-0000-0000000000b2', 'Client', 'c@x', '+998902222222', false, null)
  on conflict (id) do update set show_phone = excluded.show_phone, avatar_url = excluded.avatar_url;
insert into xizmatlar (id, owner_id, name, provider_type, category_id, subcategory_id, service_city, pricing_model, base_price, show_busy_hours)
select '00000000-0000-0000-0000-0000000000c3', '00000000-0000-0000-0000-0000000000a1', 'Tozalash', 'individual', c.id, 'cleaning', 'toshkent', 'daily', 300000, true
from categories c limit 1;
\echo == service auto-subscribed its owner to help requests (from_service)
select user_id = '00000000-0000-0000-0000-0000000000a1' as owner, from_service, service_city from subsector_alert_subscriptions;
\echo == a help request in that trade and city alerts the provider
insert into yordam_kerak_posts (author_id, title, category_id, subcategory_id, service_city, price, pricing_model)
select '00000000-0000-0000-0000-0000000000b2', 'Uy tozalash kerak', category_id, subcategory_id, 'toshkent', 50000, 'daily' from xizmatlar;
select user_id = '00000000-0000-0000-0000-0000000000a1' as to_provider, type, payload->>'own_field' as own_field from notifications where type = 'subsector_help_post';
\echo == an agreed deal with a time: busy hours show only times
insert into kelishuvlar (id, party_a_id, party_b_id, initiator_id, xizmat_id, status, start_date, start_time, duration_minutes, jarayonda_at)
values ('00000000-0000-0000-0000-0000000000d4', '00000000-0000-0000-0000-0000000000b2', '00000000-0000-0000-0000-0000000000a1', '00000000-0000-0000-0000-0000000000b2',
        '00000000-0000-0000-0000-0000000000c3', 'jarayonda', current_date + 1, '23:30', 90, now());
set local role anon;
select * from get_xizmat_busy_hours('00000000-0000-0000-0000-0000000000c3', current_date, current_date + 13);
\echo == visitors cannot read phones; signed-in people get the shown one only
select has_function_privilege('anon', 'get_public_phone(uuid)', 'execute') as anon_can_ask;
reset role;
set local role authenticated;
set local request.jwt.claim.sub = '00000000-0000-0000-0000-0000000000b2';
select get_public_phone('00000000-0000-0000-0000-0000000000a1') as provider_phone,
       get_public_phone('00000000-0000-0000-0000-0000000000b2') as hidden_phone,
       get_xizmat_public_phone('00000000-0000-0000-0000-0000000000c3') as service_phone;
\echo == the app reads these columns (fetchAppointments, busy-hours switch)
select k.start_time, x.category_id is not null as has_cat, x.show_busy_hours, p.avatar_url
from kelishuvlar k join xizmatlar x on x.id = k.xizmat_id join profiles p on p.id = k.party_b_id;
reset role;
\echo == cancelling the agreed deal notifies only the other side
set local request.jwt.claim.sub = '00000000-0000-0000-0000-0000000000b2';
update kelishuvlar set status = 'bekor' where id = '00000000-0000-0000-0000-0000000000d4';
select user_id = '00000000-0000-0000-0000-0000000000a1' as to_provider, payload->>'title' as title, payload->>'body' as body
from notifications where type = 'kelishuv_appointment_cancelled';
rollback;
