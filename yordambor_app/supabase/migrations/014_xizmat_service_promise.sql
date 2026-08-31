-- Provider-written service motto (not a platform warranty).
alter table public.xizmatlar
  add column if not exists show_service_promise boolean not null default false,
  add column if not exists service_promise text;

comment on column public.xizmatlar.show_service_promise is
  'When true and service_promise is set, show provider motto publicly';
comment on column public.xizmatlar.service_promise is
  'Provider self-advertised promise; YordamBor does not warrant it';
