-- Product support and private app feedback (separate from abuse reports)

create table if not exists support_tickets (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles(id) on delete cascade,
  category text not null check (category in ('bug', 'account', 'payment', 'other')),
  description text not null check (char_length(trim(description)) >= 10),
  app_version text,
  platform text,
  screenshot_url text,
  status text not null default 'open' check (status in ('open', 'closed')),
  created_at timestamptz not null default now()
);

create index if not exists support_tickets_user_id_idx
  on support_tickets (user_id, created_at desc);

create table if not exists feedback_submissions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id) on delete set null,
  rating int check (rating between 1 and 5),
  message text not null check (char_length(trim(message)) >= 3),
  app_version text,
  platform text,
  created_at timestamptz not null default now()
);

create index if not exists feedback_submissions_created_at_idx
  on feedback_submissions (created_at desc);

alter table support_tickets enable row level security;
alter table feedback_submissions enable row level security;

drop policy if exists "support_tickets_insert_own" on support_tickets;
create policy "support_tickets_insert_own"
  on support_tickets for insert
  with check (auth.uid() = user_id);

drop policy if exists "support_tickets_select_own" on support_tickets;
create policy "support_tickets_select_own"
  on support_tickets for select
  using (auth.uid() = user_id);

drop policy if exists "feedback_submissions_insert_auth" on feedback_submissions;
create policy "feedback_submissions_insert_auth"
  on feedback_submissions for insert
  with check (auth.uid() = user_id);

drop policy if exists "feedback_submissions_select_own" on feedback_submissions;
create policy "feedback_submissions_select_own"
  on feedback_submissions for select
  using (auth.uid() = user_id);

create table if not exists profile_achievements (
  profile_id uuid not null references profiles(id) on delete cascade,
  achievement_id text not null,
  unlocked_at timestamptz not null default now(),
  primary key (profile_id, achievement_id)
);

alter table profile_achievements enable row level security;

drop policy if exists "profile_achievements_public_read" on profile_achievements;
create policy "profile_achievements_public_read"
  on profile_achievements for select
  using (true);

drop policy if exists "profile_achievements_insert_own" on profile_achievements;
create policy "profile_achievements_insert_own"
  on profile_achievements for insert
  with check (auth.uid() = profile_id);
