-- Sub-sector alert subscriptions + notification triggers

create table if not exists public.subsector_alert_subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  category_id text not null references public.categories(id),
  subcategory_id text not null,
  provider_type text not null check (provider_type in ('individual', 'institution')),
  alert_new_service boolean not null default false,
  alert_discount boolean not null default false,
  alert_help_post boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint subsector_alert_has_signal check (
    alert_new_service or alert_discount or alert_help_post
  ),
  unique (user_id, category_id, subcategory_id, provider_type)
);

create index if not exists idx_subsector_alerts_user
  on public.subsector_alert_subscriptions(user_id);

create index if not exists idx_subsector_alerts_match
  on public.subsector_alert_subscriptions(category_id, subcategory_id, provider_type);

alter table public.subsector_alert_subscriptions enable row level security;

create policy "subsector_alerts_select_own"
  on public.subsector_alert_subscriptions for select
  using (auth.uid() = user_id);

create policy "subsector_alerts_insert_own"
  on public.subsector_alert_subscriptions for insert
  with check (auth.uid() = user_id);

create policy "subsector_alerts_update_own"
  on public.subsector_alert_subscriptions for update
  using (auth.uid() = user_id);

create policy "subsector_alerts_delete_own"
  on public.subsector_alert_subscriptions for delete
  using (auth.uid() = user_id);

create or replace function public.touch_subsector_alert_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

drop trigger if exists trg_subsector_alert_updated on public.subsector_alert_subscriptions;
create trigger trg_subsector_alert_updated
  before update on public.subsector_alert_subscriptions
  for each row execute function public.touch_subsector_alert_updated_at();

create or replace function public._subsector_users_not_blocked(
  recipient uuid,
  actor uuid
)
returns boolean
language sql
stable
as $$
  select not exists (
    select 1
    from public.blocks b
    where (b.blocker_id = recipient and b.blocked_id = actor)
       or (b.blocker_id = actor and b.blocked_id = recipient)
  );
$$;

create or replace function public.notify_subsector_new_xizmat()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into notifications (user_id, type, payload)
  select
    s.user_id,
    'subsector_new_service',
    jsonb_build_object(
      'title', 'Yangi xizmat',
      'body', left(new.name, 120),
      'xizmat_id', new.id,
      'category_id', new.category_id,
      'subcategory_id', new.subcategory_id
    )
  from subsector_alert_subscriptions s
  where s.alert_new_service
    and s.user_id <> new.owner_id
    and s.category_id = new.category_id
    and s.subcategory_id = new.subcategory_id
    and s.provider_type = new.provider_type
    and public._subsector_users_not_blocked(s.user_id, new.owner_id);

  return new;
end;
$$;

drop trigger if exists trg_notify_subsector_new_xizmat on public.xizmatlar;
create trigger trg_notify_subsector_new_xizmat
  after insert on public.xizmatlar
  for each row execute function public.notify_subsector_new_xizmat();

create or replace function public.notify_subsector_xizmat_discount()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.base_price is null or old.base_price is null then
    return new;
  end if;
  if new.base_price >= old.base_price then
    return new;
  end if;

  insert into notifications (user_id, type, payload)
  select
    s.user_id,
    'subsector_discount',
    jsonb_build_object(
      'title', 'Narx pasaydi',
      'body', left(new.name, 120),
      'xizmat_id', new.id,
      'category_id', new.category_id,
      'subcategory_id', new.subcategory_id,
      'old_price', old.base_price,
      'new_price', new.base_price
    )
  from subsector_alert_subscriptions s
  where s.alert_discount
    and s.user_id <> new.owner_id
    and s.category_id = new.category_id
    and s.subcategory_id = new.subcategory_id
    and s.provider_type = new.provider_type
    and public._subsector_users_not_blocked(s.user_id, new.owner_id);

  return new;
end;
$$;

drop trigger if exists trg_notify_subsector_xizmat_discount on public.xizmatlar;
create trigger trg_notify_subsector_xizmat_discount
  after update of base_price on public.xizmatlar
  for each row execute function public.notify_subsector_xizmat_discount();

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

drop trigger if exists trg_notify_subsector_help_post on public.yordam_kerak_posts;
create trigger trg_notify_subsector_help_post
  after insert on public.yordam_kerak_posts
  for each row execute function public.notify_subsector_help_post();

alter table public.notifications replica identity full;

do $$
begin
  alter publication supabase_realtime add table public.notifications;
exception
  when duplicate_object then null;
end $$;
