# Demo Coolify

Website statis sederhana (nginx) + CI/CD GitHub Actions → GHCR → Coolify.

## Jalankan lokal

```bash
docker build -t demo-coolify .
docker run --rm -p 8080:80 demo-coolify
# buka http://localhost:8080  (health check: /health)
```

## Alur CI/CD

| Event | Yang terjadi |
|-------|--------------|
| Pull request ke `main` | Build image + smoke test (`/health` & halaman utama) |
| Push ke `main` | Build & push image ke `ghcr.io/<owner>/<repo>:latest` dan `:sha-xxxx`, lalu trigger deploy Coolify |

## Setup di Coolify

1. **New Resource → Docker Image**, isi image `ghcr.io/<owner>/<repo>:latest`, port `80`.
   - Kalau package GHCR private, tambahkan registry credential di Coolify (username GitHub + PAT dengan scope `read:packages`), atau set package jadi public.
2. Set domain, health check path `/health`.
3. Buka **Webhooks** di resource → salin **Deploy Webhook URL**.
4. **Keys & Tokens → API Tokens** → buat token dengan permission *deploy*.

## Secrets di GitHub

`Settings → Secrets and variables → Actions`:

| Secret | Isi |
|--------|-----|
| `COOLIFY_WEBHOOK` | Deploy Webhook URL dari Coolify |
| `COOLIFY_TOKEN` | API token Coolify |

> Alternatif tanpa GHCR: pilih resource **Public/Private Repository (Dockerfile)** di Coolify supaya Coolify build sendiri dari repo. Job `deploy` tetap bisa dipakai untuk trigger webhook-nya.
