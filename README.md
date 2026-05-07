# IRPF 2025 — AG Consultoria

Dashboard interno para acompanhamento das declarações de IRPF dos clientes da AG Consultoria.

- **Stack:** HTML único + Supabase (REST + Realtime)
- **Deadline:** 29/05/2026
- **Time:** Edinho, Monica, Renata, Ruan, Alisson

## Estrutura

- `index.html` — aplicação completa (UI + JS embutido)
- `vercel.json` — config de deploy estático

## Variáveis embutidas

A `SUPABASE_URL` e a `SUPABASE_KEY` (anon) ficam no HTML porque é SPA estática. A segurança real vem das **Row Level Security policies** do Supabase, que precisam estar configuradas para restringir o que a anon role pode fazer.

> ⚠️ Hoje a tabela `irpf_clientes` aceita SELECT/INSERT/UPDATE/DELETE de anon sem restrição. Antes de tornar o site público, aplicar policies (ou colocar atrás de Vercel password / Supabase Auth).

## Deploy

```
vercel deploy --prod
```

## Schema esperado (irpf_clientes)

| coluna | tipo |
|---|---|
| id | text PK |
| cnpj | text |
| nome_fantasia | text |
| socios | text |
| cpf | text |
| senha_ogv | text |
| contador_id | text |
| data_reuniao | text |
| status | text |
| telefone | text |
| email | text |
| obs | text |
| created_at | timestamptz default now() |
