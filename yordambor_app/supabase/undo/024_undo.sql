-- Undo 024 only if the app misbehaves after it. The app keeps working
-- either way: it falls back when these functions and columns are missing.
--
-- What is lost: help-request alerts made for services (from_service), the
-- busy-hours switch on services, and price units on help requests.
-- Services priced per day, month or piece become per job (fixed), the
-- closest price model before 024.

-- 1. Phones people chose to show.
drop function if exists public.get_public_phone(uuid);
drop function if exists public.get_xizmat_public_phone(uuid);

-- 2. Cancelled appointments: the deal notice as before (migration 010).
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

-- 3. Prices.
update public.xizmatlar
set pricing_model = 'fixed'
where pricing_model in ('daily', 'monthly', 'unit');

alter table public.xizmatlar
  drop constraint if exists xizmatlar_pricing_model_check;
alter table public.xizmatlar
  add constraint xizmatlar_pricing_model_check
  check (pricing_model in ('negotiable', 'fixed', 'hourly'));

alter table public.yordam_kerak_posts
  drop constraint if exists yordam_kerak_posts_pricing_model_check;
alter table public.yordam_kerak_posts
  drop column if exists pricing_model;

-- 4. Help-request alerts for providers.
drop trigger if exists trg_subscribe_owner_to_help_posts on public.xizmatlar;
drop function if exists public.subscribe_owner_to_help_posts();

-- Only the alerts 024 made for services; the ones people set up stay.
delete from public.subsector_alert_subscriptions where from_service;

alter table public.subsector_alert_subscriptions
  drop column if exists service_city,
  drop column if exists from_service;

-- The help-request alert as before (migration 018).
create or replace function public.notify_subsector_help_post()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.status is distinct from 'open' then
    return new;
  end if;
  if new.subcategory_id is null or new.category_id is null then
    return new;
  end if;

  insert into notifications (user_id, type, payload)
  select
    s.user_id,
    'subsector_help_post',
    jsonb_build_object(
      'title', 'Yordam kerak',
      'body', left(new.title, 120),
      'post_id', new.id,
      'category_id', new.category_id,
      'subcategory_id', new.subcategory_id
    )
  from subsector_alert_subscriptions s
  where s.alert_help_post
    and s.user_id <> new.author_id
    and s.category_id = new.category_id
    and s.subcategory_id = new.subcategory_id
    and public._subsector_users_not_blocked(s.user_id, new.author_id);

  return new;
end;
$$;

-- 5. Busy hours on a service page.
drop function if exists public.get_xizmat_busy_hours(uuid, date, date);
alter table public.xizmatlar
  drop column if exists show_busy_hours;

do $$
begin
  if to_regprocedure('public.refresh_public_column_grants()') is not null then
    perform public.refresh_public_column_grants();
  end if;
end $$;

notify pgrst, 'reload schema';
