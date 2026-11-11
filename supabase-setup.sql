create table if not exists public.board_editors (
  user_id uuid primary key references auth.users (id) on delete cascade
);

create table if not exists public.board_workspace (
  id smallint primary key check (id = 1),
  document jsonb not null,
  updated_at timestamptz not null default now()
);

create table if not exists public.published_board (
  id smallint primary key check (id = 1),
  title text not null,
  content jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.board_editors enable row level security;
alter table public.board_workspace enable row level security;
alter table public.published_board enable row level security;

revoke all on public.board_editors from anon, authenticated;
grant select, insert, update on public.board_workspace to authenticated;
grant select on public.published_board to anon, authenticated;
grant insert, update on public.published_board to authenticated;

create or replace function public.is_board_editor()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.board_editors
    where user_id = (select auth.uid())
  );
$$;

revoke all on function public.is_board_editor() from public;
grant execute on function public.is_board_editor() to authenticated;

drop policy if exists board_workspace_editor_access on public.board_workspace;
create policy board_workspace_editor_access
  on public.board_workspace
  for all
  to authenticated
  using ((select public.is_board_editor()))
  with check ((select public.is_board_editor()));

drop policy if exists published_board_public_read on public.published_board;
create policy published_board_public_read
  on public.published_board
  for select
  to anon, authenticated
  using (true);

drop policy if exists published_board_editor_insert on public.published_board;
create policy published_board_editor_insert
  on public.published_board
  for insert
  to authenticated
  with check ((select public.is_board_editor()));

drop policy if exists published_board_editor_update on public.published_board;
create policy published_board_editor_update
  on public.published_board
  for update
  to authenticated
  using ((select public.is_board_editor()))
  with check ((select public.is_board_editor()));
