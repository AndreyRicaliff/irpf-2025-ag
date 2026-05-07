-- ============================================================
-- IRPF 2025 — Lock RLS to authenticated users only
-- Aplique no Supabase SQL Editor após habilitar Google Provider:
--   Dashboard → Authentication → Providers → Google → Enable
--   Client ID: 353720892078-14r0l8kpftkai4tg5q59ss4loinuria9.apps.googleusercontent.com
--   "Skip nonce checks" pode precisar estar ON pra signInWithIdToken
-- ============================================================

-- Garante RLS ligado
alter table public.irpf_clientes enable row level security;

-- Limpa policies antigas (idempotente)
drop policy if exists "anon all"           on public.irpf_clientes;
drop policy if exists "authenticated all"  on public.irpf_clientes;
drop policy if exists "ag domain only"     on public.irpf_clientes;

-- Bloqueia anon completamente. Sem GRANT/policy = sem acesso.
revoke all on public.irpf_clientes from anon;

-- Permite tudo a usuários autenticados
grant select, insert, update, delete on public.irpf_clientes to authenticated;

-- Defesa em profundidade: só e-mails @agconsultorialtda.com
-- (mesmo que alguém habilite outro provedor por engano, fica fora).
create policy "ag domain only"
  on public.irpf_clientes
  for all
  to authenticated
  using ((auth.jwt()->>'email') ilike '%@agconsultorialtda.com')
  with check ((auth.jwt()->>'email') ilike '%@agconsultorialtda.com');
