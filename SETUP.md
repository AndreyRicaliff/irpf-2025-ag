# Setup — IRPF 2025 AG

App single-file gateado com Google Sign-In (padrão AG: `hd === agconsultorialtda.com`, sessão em `localStorage`).

## 1. Google Cloud Console: autorizar a origem

No projeto Google que tem o Client ID `353720892078-14r0l8kpftkai4tg5q59ss4loinuria9.apps.googleusercontent.com` → **APIs & Services → Credentials → OAuth 2.0 Client → Authorized JavaScript origins**, adicionar:

- `http://localhost:3000` (dev)
- `https://<projeto>.vercel.app` (após deploy)
- `https://irpf.agconsultorialtda.com` (se mapear domínio próprio)

Sem isso o Google bloqueia o botão de login no domínio do site.

## 2. Deploy

```
vercel deploy --prod
```

## 3. Smoke test

1. Abre a URL → tela de login Google aparece, app fica trancado atrás dela.
2. Login com `seu-email@agconsultorialtda.com` → app aparece.
3. Login com Gmail pessoal → bloqueia com mensagem "Acesso negado".
4. Botão `⏻` no header faz logout → volta pra tela de login.
5. Recarregar página com sessão válida → entra direto, sem precisar logar.

## Sessão

- Guardada em `localStorage` chave `irpf_session`
- TTL: 12h. Após expirar, pede login de novo.
- Pra invalidar manualmente: DevTools → Application → Local Storage → remover `irpf_session`.

## Camadas de proteção

| Camada | O que faz | Onde |
|---|---|---|
| `hd:` no init do GIS | Google só permite escolher conta @agconsultorialtda.com | client-side |
| Validação do JWT (`hd` + `email_verified` + sufixo do email) | Defesa em profundidade caso alguém forge a callback | client-side |
| `body.locked` CSS | App fica invisível até autenticar | client-side |

> ⚠️ A **anon key** do Supabase continua no HTML público (limitação de SPA single-file). Quem extrair a key do source consegue ler/escrever direto na tabela via REST API, ignorando a UI. A proteção atual é **gate de UI + obscuridade da URL**, não DB-level.
> Se isso virar problema, próximo passo é migrar pra Supabase Auth (`signInWithIdToken`) + RLS authenticated-only.
