-- YordamBor v1 initial schema

create table if not exists categories (
  id text primary key,
  icon text not null,
  name_uz text not null,
  name_ru text not null,
  name_en text not null,
  name_zh text
);

create table if not exists subcategories (
  id text not null,
  category_id text not null references categories(id) on delete cascade,
  provider_type text not null check (provider_type in ('individual', 'institution')),
  name_uz text not null,
  name_ru text not null,
  name_en text not null,
  name_zh text,
  primary key (category_id, id, provider_type)
);

create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null,
  email text unique not null,
  phone text unique not null,
  avatar_url text,
  show_phone boolean not null default false,
  language text not null default 'uz' check (language in ('uz', 'ru', 'en', 'zh')),
  created_at timestamptz not null default now()
);

create table if not exists xizmatlar (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references profiles(id) on delete cascade,
  name text not null,
  provider_type text not null check (provider_type in ('individual', 'institution')),
  category_id text references categories(id),
  subcategory_id text not null,
  description text,
  avatar_url text,
  status text not null default 'available' check (status in ('available', 'busy')),
  currency_default text not null default 'UZS' check (currency_default in ('UZS', 'USD')),
  rating_avg numeric(3,2) not null default 0,
  review_count int not null default 0,
  completed_count int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists portfolio_items (
  id uuid primary key default gen_random_uuid(),
  xizmat_id uuid not null references xizmatlar(id) on delete cascade,
  image_url text not null,
  caption text,
  is_hero boolean not null default false,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists yordam_kerak_posts (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null references profiles(id) on delete cascade,
  title text not null,
  message text,
  price numeric,
  currency text check (currency in ('UZS', 'USD')),
  start_date date,
  start_time time,
  duration_minutes int,
  end_date date,
  category_id text references categories(id),
  subcategory_id text,
  status text not null default 'open' check (status in ('open', 'closed', 'deleted')),
  created_at timestamptz not null default now()
);

create table if not exists kelishuvlar (
  id uuid primary key default gen_random_uuid(),
  xizmat_id uuid references xizmatlar(id),
  yordam_kerak_post_id uuid references yordam_kerak_posts(id),
  party_a_id uuid not null references profiles(id),
  party_b_id uuid not null references profiles(id),
  initiator_id uuid not null references profiles(id),
  status text not null default 'muzokarada'
    check (status in ('muzokarada', 'jarayonda', 'bajarildi', 'bekor', 'rad', 'archived')),
  message text,
  price numeric,
  currency text check (currency in ('UZS', 'USD')),
  start_date date,
  start_time time,
  duration_minutes int,
  end_date date,
  accept_a boolean not null default false,
  accept_b boolean not null default false,
  accept_a_at timestamptz,
  accept_b_at timestamptz,
  jarayonda_at timestamptz,
  bajarildi_at timestamptz,
  archive_at timestamptz,
  delete_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists kelishuv_messages (
  id uuid primary key default gen_random_uuid(),
  kelishuv_id uuid not null references kelishuvlar(id) on delete cascade,
  sender_id uuid not null references profiles(id),
  content text not null,
  created_at timestamptz not null default now()
);

create table if not exists reviews (
  id uuid primary key default gen_random_uuid(),
  kelishuv_id uuid unique references kelishuvlar(id),
  xizmat_id uuid references xizmatlar(id),
  reviewer_id uuid references profiles(id),
  rating int check (rating between 1 and 5),
  comment text,
  provider_reply text,
  created_at timestamptz not null default now()
);

create table if not exists favorites (
  user_id uuid not null references profiles(id) on delete cascade,
  xizmat_id uuid not null references xizmatlar(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, xizmat_id)
);

create table if not exists blocks (
  blocker_id uuid not null references profiles(id) on delete cascade,
  blocked_id uuid not null references profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id)
);

create table if not exists reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid references profiles(id),
  target_type text not null,
  target_id uuid not null,
  reason text,
  created_at timestamptz not null default now()
);

create table if not exists notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles(id) on delete cascade,
  type text not null,
  payload jsonb,
  read boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists analytics_events (
  id uuid primary key default gen_random_uuid(),
  xizmat_id uuid references xizmatlar(id) on delete cascade,
  event_type text not null,
  user_id uuid,
  created_at timestamptz not null default now()
);

-- Max 5 xizmat per user
create or replace function check_xizmat_limit()
returns trigger as $$
begin
  if (select count(*) from xizmatlar where owner_id = new.owner_id) >= 5 then
    raise exception 'Maximum 5 xizmat allowed per user';
  end if;
  return new;
end;
$$ language plpgsql;

create trigger trg_xizmat_limit
  before insert on xizmatlar
  for each row execute function check_xizmat_limit();

create index if not exists idx_xizmatlar_owner on xizmatlar(owner_id);
create index if not exists idx_kelishuvlar_parties on kelishuvlar(party_a_id, party_b_id);
create index if not exists idx_kelishuvlar_xizmat on kelishuvlar(xizmat_id, status);
create index if not exists idx_yordam_kerak_status on yordam_kerak_posts(status, created_at desc);
