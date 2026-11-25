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
