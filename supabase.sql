-- 個人收支紀錄：Supabase 雲端資料表
-- 在 Supabase Dashboard → SQL Editor 貼上並執行一次即可。

create table if not exists public.finance_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{"banks":[],"cards":[],"transactions":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.finance_data enable row level security;

-- 使用者只能讀取自己的資料
create policy "finance_select_own"
on public.finance_data
for select
to authenticated
using ((select auth.uid()) = user_id);

-- 使用者只能新增自己的資料
create policy "finance_insert_own"
on public.finance_data
for insert
to authenticated
with check ((select auth.uid()) = user_id);

-- 使用者只能更新自己的資料
create policy "finance_update_own"
on public.finance_data
for update
to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);

-- 使用者只能刪除自己的資料
create policy "finance_delete_own"
on public.finance_data
for delete
to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, update, delete on public.finance_data to authenticated;
