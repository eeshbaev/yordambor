alter table xizmatlar
  add column if not exists contact_phone text,
  add column if not exists show_contact_phone boolean not null default false,
  add column if not exists show_profile boolean not null default true;

alter table yordam_kerak_posts
  add column if not exists contact_phone text,
  add column if not exists show_contact_phone boolean not null default false,
  add column if not exists show_profile boolean not null default true;
