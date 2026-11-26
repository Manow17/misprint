-- Misprint community levels.
-- Paste this whole file into Supabase -> SQL Editor -> New query, then press Run. Safe to run again.

create table if not exists public.levels (
  id         uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  name       text not null check (char_length(name) between 1 and 40),
  author     text not null check (char_length(author) between 1 and 20),
  seed       text not null check (seed ~ '^[0-9A-Za-z]{1,6}$'),
  tier       smallint not null check (tier between 0 and 4),
  data       jsonb not null check (jsonb_typeof(data -> 'objs') = 'array' and octet_length(data::text) < 64000)
);

-- Row Level Security: the website's public key can read levels and add new ones,
-- but nobody can edit or delete levels through it.
alter table public.levels enable row level security;

drop policy if exists "levels are public" on public.levels;
create policy "levels are public" on public.levels
  for select to anon, authenticated using (true);

drop policy if exists "anyone can publish" on public.levels;
create policy "anyone can publish" on public.levels
  for insert to anon, authenticated with check (true);

grant select, insert on public.levels to anon, authenticated;

-- Publish limit: at most 15 levels per connection (IP address) per 24 hours.
-- The IP comes from cf-connecting-ip / sb-forwarded-for, which Supabase's edge sets and
-- clients can't fake (x-forwarded-for can be faked, so it isn't used). Only a salted
-- SHA-256 hash of the IP is stored, in a table the public key can't read.
create table if not exists public.publish_log (ip_hash text not null, at timestamptz not null default now());
create index if not exists publish_log_ip_at on public.publish_log (ip_hash, at);
alter table public.publish_log enable row level security;
revoke all on public.publish_log from anon, authenticated;

create or replace function public.levels_rate_limit() returns trigger
language plpgsql security definer set search_path = public as $$
declare
  h json := coalesce(nullif(current_setting('request.headers', true), '')::json, '{}'::json);
  ip text := coalesce(nullif(h->>'cf-connecting-ip', ''), nullif(h->>'sb-forwarded-for', ''), 'unknown');
  who text := encode(sha256(convert_to(ip || '|misprint', 'UTF8')), 'hex');
  n int;
begin
  perform pg_advisory_xact_lock(hashtext(who));
  delete from publish_log where at < now() - interval '2 days';
  select count(*) into n from publish_log where ip_hash = who and at > now() - interval '24 hours';
  if n >= 15 then
    raise exception 'Daily limit reached: you can publish 15 levels a day. Try again tomorrow.' using errcode = 'P0001';
  end if;
  insert into publish_log (ip_hash) values (who);
  return new;
end $$;
revoke execute on function public.levels_rate_limit() from public, anon, authenticated;

drop trigger if exists levels_rate_limit on public.levels;
create trigger levels_rate_limit before insert on public.levels
  for each row execute function public.levels_rate_limit();
