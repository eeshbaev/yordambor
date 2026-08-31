-- Row Level Security policies (v1 baseline)

alter table profiles enable row level security;
alter table xizmatlar enable row level security;
alter table portfolio_items enable row level security;
alter table yordam_kerak_posts enable row level security;
alter table kelishuvlar enable row level security;
alter table kelishuv_messages enable row level security;
alter table reviews enable row level security;
alter table favorites enable row level security;
alter table blocks enable row level security;
alter table reports enable row level security;
alter table notifications enable row level security;
alter table analytics_events enable row level security;

-- Public read: categories (no RLS — reference data)
-- Public read: xizmatlar + portfolio for discovery
create policy "xizmatlar_public_read" on xizmatlar for select using (true);
create policy "portfolio_public_read" on portfolio_items for select using (true);
create policy "reviews_public_read" on reviews for select using (true);
create policy "posts_public_read" on yordam_kerak_posts for select using (status = 'open');

-- Profiles: read all, update own
create policy "profiles_read" on profiles for select using (true);
create policy "profiles_update_own" on profiles for update using (auth.uid() = id);
create policy "profiles_insert_own" on profiles for insert with check (auth.uid() = id);

-- Xizmatlar: owner CRUD
create policy "xizmatlar_insert_own" on xizmatlar for insert with check (auth.uid() = owner_id);
create policy "xizmatlar_update_own" on xizmatlar for update using (auth.uid() = owner_id);
create policy "xizmatlar_delete_own" on xizmatlar for delete using (auth.uid() = owner_id);

-- Portfolio: owner manages via xizmat ownership
create policy "portfolio_insert" on portfolio_items for insert
  with check (exists (select 1 from xizmatlar x where x.id = xizmat_id and x.owner_id = auth.uid()));
create policy "portfolio_update" on portfolio_items for update
  using (exists (select 1 from xizmatlar x where x.id = xizmat_id and x.owner_id = auth.uid()));
create policy "portfolio_delete" on portfolio_items for delete
  using (exists (select 1 from xizmatlar x where x.id = xizmat_id and x.owner_id = auth.uid()));

-- Kelishuv: participants only
create policy "kelishuv_read" on kelishuvlar for select
  using (auth.uid() = party_a_id or auth.uid() = party_b_id);
create policy "kelishuv_insert" on kelishuvlar for insert
  with check (auth.uid() = party_a_id or auth.uid() = party_b_id);
create policy "kelishuv_update" on kelishuvlar for update
  using (auth.uid() = party_a_id or auth.uid() = party_b_id);

create policy "kelishuv_msg_read" on kelishuv_messages for select
  using (exists (
    select 1 from kelishuvlar k where k.id = kelishuv_id
    and (k.party_a_id = auth.uid() or k.party_b_id = auth.uid())
  ));
create policy "kelishuv_msg_insert" on kelishuv_messages for insert
  with check (auth.uid() = sender_id);

-- Favorites: own
create policy "favorites_own" on favorites for all using (auth.uid() = user_id);

-- Notifications: own
create policy "notifications_own" on notifications for all using (auth.uid() = user_id);

-- Yordam kerak posts: author manages
create policy "posts_insert" on yordam_kerak_posts for insert with check (auth.uid() = author_id);
create policy "posts_update" on yordam_kerak_posts for update using (auth.uid() = author_id);
