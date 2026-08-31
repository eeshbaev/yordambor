-- Optional city/area where the provider operates (self-reported, not verified).
alter table public.xizmatlar
  add column if not exists service_city text;

comment on column public.xizmatlar.service_city is
  'Optional self-reported city or area where the service is offered.';
