# Paradise AG — Deployment Guide

## Architecture

```
Netlify (Flutter web)  →  Render (NestJS API)  →  Render PostgreSQL
                                    ↓
                            Supabase (offline sync)
```

## Part 1: Backend on Render

### Option A: Using render.yaml (recommended)
1. Push the entire `Paradise AG version3` folder to GitHub
2. Go to https://dashboard.render.com → New + → Blueprint
3. Select your GitHub repo
4. Render will detect `render.yaml` and create:
   - Web service (NestJS API) — `paradise-ag-api`
   - PostgreSQL database — `paradise-ag-db`
5. Set these env vars manually in Render dashboard:
   - `JWT_SECRET` — generate with `openssl rand -hex 64`
   - `CORS_ORIGIN` — your Netlify URL (add after Netlify deploy)
6. Deploy

### Option B: Manual setup
1. Render → New + → PostgreSQL (free tier)
   - Save the connection credentials
2. Render → New + → Web Service
   - Connect GitHub repo
   - Root Directory: `paradise_ag_backend`
   - Build: `npm ci && npm run build`
   - Start: `npm run start:prod`
   - Add all env vars from `.env.production`

## Part 2: Flutter Web on Netlify

1. Go to https://app.netlify.com → Add new site → Import from Git
2. Select your GitHub repo
3. Settings:
   - Base directory: `paradise_ag`
   - Build command: (auto-detected from netlify.toml)
   - Publish directory: `build/web`
4. Add environment variables in Netlify dashboard:
   - `API_BASE_URL` = `https://paradise-ag-api.onrender.com/api`
   - `SUPABASE_URL` = `https://your-project.supabase.co`
   - `SUPABASE_ANON_KEY` = `your-anon-key`
5. Deploy

## Part 3: Supabase Setup (for offline sync)

1. Create project at https://supabase.com
2. Go to SQL Editor → paste contents of `paradise_ag/supabase_schema.sql` → Run
3. Go to Settings → API:
   - Copy `Project URL` → set as `SUPABASE_URL` in Netlify
   - Copy `anon public key` → set as `SUPABASE_ANON_KEY` in Netlify
4. Enable Row-Level Security (RLS) on all tables
5. Create RLS policies (see supabase_schema.sql comments)

## Part 4: Connect everything

1. After Netlify deploy, copy your Netlify URL
2. Update `CORS_ORIGIN` in Render to include the Netlify URL
3. Redeploy the backend on Render
4. Test: visit your Netlify URL, the app should connect to the API

## Environment Variables Summary

### Render (backend)
| Variable | Value |
|----------|-------|
| NODE_ENV | production |
| PORT | 3000 |
| DB_HOST | (from Render PostgreSQL) |
| DB_PORT | 5432 |
| DB_USERNAME | (from Render PostgreSQL) |
| DB_PASSWORD | (from Render PostgreSQL) |
| DB_DATABASE | (from Render PostgreSQL) |
| JWT_SECRET | (generate 256-bit secret) |
| CORS_ORIGIN | https://your-app.netlify.app |

### Netlify (frontend)
| Variable | Value |
|----------|-------|
| API_BASE_URL | https://paradise-ag-api.onrender.com/api |
| SUPABASE_URL | https://your-project.supabase.co |
| SUPABASE_ANON_KEY | your-anon-key |
