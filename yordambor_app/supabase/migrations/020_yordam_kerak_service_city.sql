-- 020: Every help request has a city, like every service (017).
--
-- The app asks for the city on every new request and filters both feeds by
-- it. Until this runs, the app leaves the city out (requests still load and
-- save); once the column exists it is used straight away.

alter table public.yordam_kerak_posts
  add column if not exists service_city text;

-- Only the city ids the app knows (lib/core/constants/service_cities.dart).
-- Older requests without a city stay valid.
alter table public.yordam_kerak_posts
  drop constraint if exists yordam_kerak_posts_service_city_check;
alter table public.yordam_kerak_posts
  add constraint yordam_kerak_posts_service_city_check
  check (
    service_city is null
    or service_city in (
      'toshkent', 'toshkent_viloyati', 'samarqand', 'buxoro', 'nukus',
      'namangan', 'andijon', 'fargona', 'qarshi', 'urganch', 'termiz',
      'jizzax', 'navoiy', 'qoqon', 'guliston', 'boshqa'
    )
  );

-- The feed asks for open requests in one city, newest first.
create index if not exists yordam_kerak_posts_open_city_idx
  on public.yordam_kerak_posts (service_city, created_at desc)
  where status = 'open';

-- If 023 (hidden phones and emails) already ran, let the API read the new
-- column too.
do $$
begin
  if to_regprocedure('public.refresh_public_column_grants()') is not null then
    perform public.refresh_public_column_grants();
  end if;
end $$;

-- Let the API see the new column at once.
notify pgrst, 'reload schema';
