-- Include xizmat_id in notification payloads for deep linking

create or replace function public.notify_kelishuv_message()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  kelishuv_row kelishuvlar%rowtype;
  recipient_id uuid;
begin
  select * into kelishuv_row from kelishuvlar where id = new.kelishuv_id;
  if not found then
    return new;
  end if;

  if new.sender_id = kelishuv_row.party_a_id then
    recipient_id := kelishuv_row.party_b_id;
  else
    recipient_id := kelishuv_row.party_a_id;
  end if;

  insert into notifications (user_id, type, payload)
  values (
    recipient_id,
    'kelishuv_message',
    jsonb_build_object(
      'title', 'Yangi xabar',
      'body', left(new.content, 120),
      'kelishuv_id', new.kelishuv_id,
      'xizmat_id', kelishuv_row.xizmat_id
    )
  );

  return new;
end;
$$;

create or replace function public.notify_kelishuv_status()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status = old.status then
    return new;
  end if;

  if new.status = 'jarayonda' and old.status = 'muzokarada' then
    insert into notifications (user_id, type, payload) values
    (
      new.party_a_id,
      'kelishuv_accept',
      jsonb_build_object(
        'title', 'Kelishuv boshlandi',
        'body', 'Ikki tomon ham qabul qildi — ish jarayoni boshlandi',
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id
      )
    ),
    (
      new.party_b_id,
      'kelishuv_accept',
      jsonb_build_object(
        'title', 'Kelishuv boshlandi',
        'body', 'Ikki tomon ham qabul qildi — ish jarayoni boshlandi',
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id
      )
    );
  elsif new.status = 'bajarildi' then
    insert into notifications (user_id, type, payload) values
    (
      new.party_a_id,
      'kelishuv_complete',
      jsonb_build_object(
        'title', 'Ish yakunlandi',
        'body', 'Kelishuv bajarildi deb belgilandi',
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id
      )
    ),
    (
      new.party_b_id,
      'kelishuv_complete',
      jsonb_build_object(
        'title', 'Ish yakunlandi',
        'body', 'Kelishuv bajarildi deb belgilandi',
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id
      )
    );
  elsif new.status in ('bekor', 'rad') then
    insert into notifications (user_id, type, payload) values
    (
      new.party_a_id,
      'kelishuv_closed',
      jsonb_build_object(
        'title', 'Kelishuv yopildi',
        'body', 'Kelishuv holati: ' || new.status,
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id
      )
    ),
    (
      new.party_b_id,
      'kelishuv_closed',
      jsonb_build_object(
        'title', 'Kelishuv yopildi',
        'body', 'Kelishuv holati: ' || new.status,
        'kelishuv_id', new.id,
        'xizmat_id', new.xizmat_id
      )
    );
  end if;

  return new;
end;
$$;

create or replace function public.notify_kelishuv_created()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  recipient_id uuid;
begin
  if new.initiator_id = new.party_a_id then
    recipient_id := new.party_b_id;
  else
    recipient_id := new.party_a_id;
  end if;

  insert into notifications (user_id, type, payload)
  values (
    recipient_id,
    'kelishuv_new',
    jsonb_build_object(
      'title', 'Yangi taklif',
      'body', coalesce(left(new.message, 120), 'Yangi kelishuv taklifi'),
      'kelishuv_id', new.id,
      'xizmat_id', new.xizmat_id
    )
  );

  return new;
end;
$$;
