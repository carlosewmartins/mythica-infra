# Mythica Infra

Este repositório integra:
- **[mythica-frontend](https://github.com/carlosewmartins/mythica-frontend)** (Angular 20, hospedado no Vercel)
- **[mythica-backend](https://github.com/carlosewmartins/mythica-backend)** (FastAPI, rodando em Docker)

A ideia é separar responsabilidades:
- **Frontend** → buildado e publicado no [Vercel](https://vercel.com).
- **Backend** → rodando em container Docker, exposto em :8000 (API). <-- (Por enquanto)

---

## 🚀 Clonar com submódulos
```bash
git clone --recurse-submodules git@github.com:carlosewmartins/mythica-infra.git
cd mythica-infra
```

Se já clonou sem recurse:
```bash
git submodule update --init --recursive
```

---

## 💻 Rodar Backend em DEV (hot reload)
O backend (FastAPI) + frontend (Angular dev-server) podem rodar juntos via container.

```bash
docker compose up --build
```

- Frontend (ng serve): [http://localhost:4200](http://localhost:4200)
- Backend: [http://localhost:8000/api/health](http://localhost:8000/api/health)

> Em DEV o Angular chama a API em `http://localhost:8000`.

---

## 📦 Rodar Backend em PROD
1. Edite o `compose.yaml`:
```yaml
build:
  target: prod
```

2. Suba:
```bash
docker compose up --build
```

- API disponível em [http://localhost:8000/api](http://localhost:8000/api)
- O frontend **não é servido pelo backend** — ficará no Vercel.

---

## 🌐 Frontend no Vercel

WIP
---

## 🔄 Atualizar submódulos
Quando houver novos commits no frontend ou backend:
```bash
git submodule update --remote --merge
git add frontend backend
git commit -m "chore: update submodules"
git push
```

---

## 📌 Observações
- Em **DEV** → front roda em `:4200`, back em `:8000`.
- Em **PROD** → back roda no Docker em `:8000`; front no Vercel.
- Habilite CORS no FastAPI para o domínio do Vercel:

---