-- Optional pricing model on provider xizmat listings.
alter table public.xizmatlar
  add column if not exists pricing_model text not null default 'negotiable'
    check (pricing_model in ('negotiable', 'fixed', 'hourly')),
  add column if not exists base_price numeric,
  add column if not exists min_duration_minutes integer;

comment on column public.xizmatlar.pricing_model is
  'negotiable | fixed | hourly — chosen by the provider';
comment on column public.xizmatlar.base_price is
  'Fixed total or hourly rate when pricing_model is fixed/hourly';
comment on column public.xizmatlar.min_duration_minutes is
  'Minimum booking duration for hourly pricing (optional)';
