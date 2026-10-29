-- 026 and 027: phones optional but unique; repeating appointments.
\set ON_ERROR_STOP 1
\pset footer off
\pset tuples_only on

create temporary table results (n serial, name text, ok boolean);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000a1', 'g1@x'),
  ('00000000-0000-0000-0000-0000000000a2', 'g2@x'),
  ('00000000-0000-0000-0000-0000000000a3', 'p@x');

do $$
begin
  insert into profiles (id, full_name, email, phone) values
    ('00000000-0000-0000-0000-0000000000a1', 'G1', 'g1@x', null),
    ('00000000-0000-0000-0000-0000000000a2', 'G2', 'g2@x', '');
  insert into results (name, ok) values ('two people without a phone get profiles', true);
exception when others then
  insert into results (name, ok) values ('two people without a phone get profiles — ' || sqlerrm, false);
end $$;

insert into profiles (id, full_name, email, phone)
values ('00000000-0000-0000-0000-0000000000a3', 'P', 'p@x', '+998901112233');

do $$
begin
  update profiles set phone = '+998901112233' where id = '00000000-0000-0000-0000-0000000000a1';
  insert into results (name, ok) values ('a number already taken is refused', false);
exception when unique_violation then
  insert into results (name, ok) values ('a number already taken is refused', true);
end $$;

do $$
begin
  insert into kelishuvlar (party_a_id, party_b_id, initiator_id, recur_rule)
  values ('00000000-0000-0000-0000-0000000000a1', '00000000-0000-0000-0000-0000000000a3',
          '00000000-0000-0000-0000-0000000000a1', 'daily');
  insert into results (name, ok) values ('an unknown repeat is refused', false);
exception when check_violation then
  insert into results (name, ok) values ('an unknown repeat is refused', true);
end $$;

insert into kelishuvlar (party_a_id, party_b_id, initiator_id, recur_rule, recur_until)
values ('00000000-0000-0000-0000-0000000000a1', '00000000-0000-0000-0000-0000000000a3',
        '00000000-0000-0000-0000-0000000000a1', 'weekly', current_date + 60);
insert into results (name, ok) values ('a weekly appointment is kept', true);

select case when ok then 'ok       ' else 'PROBLEM  ' end || name from results order by n;
