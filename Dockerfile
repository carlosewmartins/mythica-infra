# --------- DEV: Node + Python + supervisord (ng serve + uvicorn) ---------
FROM node:20-bullseye AS dev
RUN apt-get update && apt-get install -y python3 python3-pip python3-venv supervisor && rm -rf /var/lib/apt/lists/*
WORKDIR /workspace

# Venv com deps do backend
COPY backend/requirements.txt backend/requirements.txt
RUN python3 -m venv /venv \
&& /venv/bin/pip install --upgrade pip \
&& /venv/bin/pip install -r backend/requirements.txt
ENV PATH="/venv/bin:${PATH}"

# Angular CLI
COPY frontend/package*.json frontend/
WORKDIR /workspace/frontend
RUN npm i -g @angular/cli && npm install
WORKDIR /workspace

# Copy backend and frontend source code
COPY backend/ backend/
COPY frontend/ frontend/

# Supervisord roda uvicorn + ng serve no mesmo container (dev)
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 8000 4200
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# --------- PROD: só API (uvicorn) ---------
FROM python:3.12-slim AS prod
WORKDIR /app

# Reutiliza a /venv de DEV
COPY --from=dev /venv /venv
ENV PATH="/venv/bin:${PATH}"

# Copia apenas o backend (estrutura simples: app/ e requirements.txt na raiz do submódulo)
COPY backend/ ./backend/
WORKDIR /app/backend
EXPOSE 8000
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]

# Lembrar de hospedar o front no Vercel/Netlify para prod