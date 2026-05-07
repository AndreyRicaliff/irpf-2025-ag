# Setup — IRPF 2025 AG

## 1. Supabase: habilitar Google OAuth

1. Acesse `Dashboard → Authentication → Providers → Google` no projeto Supabase (`tcmesdxcnlmksrqytpdj`).
2. **Enable Sign in with Google**.
3. **Client IDs (for OAuth)** — campo "Authorized Client IDs":
   ```
   353720892078-14r0l8kpftkai4tg5q59ss4loinuria9.apps.googleusercontent.com
   ```
4. **Skip nonce checks**: ON (necessário pro fluxo `signInWithIdToken` direto do navegador).
5. Salvar.

## 2. Google Cloud Console: autorizar a origem

No projeto Google que tem o Client ID acima → **APIs & Services → Credentials → OAuth 2.0 Client → Authorized JavaScript origins**, adicionar:

- `http://localhost:3000` (dev)
- `https://<seu-dominio-vercel>.vercel.app` (após deploy)
- `https://irpf.agconsultorialtda.com` (se mapear domínio próprio)

## 3. Banco: aplicar migration de RLS

No Supabase → **SQL Editor** → cole o conteúdo de `migrations/2026_05_07_lock_rls_authenticated.sql` → Run.

> ⚠️ Após aplicar, anon perde acesso. O app **só funciona via login**. Confirme que o passo 1 está pronto antes de rodar.

## 4. Deploy

```
vercel deploy --prod
```

## 5. Smoke test

1. Abra a URL → aparece tela de login Google.
2. Faça login com `seu-email@agconsultorialtda.com` → app aparece.
3. Tente login com Gmail pessoal → bloqueia com mensagem.
4. Botão `⏻` no header faz logout → volta pra tela de login.
