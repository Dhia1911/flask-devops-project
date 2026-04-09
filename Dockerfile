# ══ STAGE 1 : BUILDER ══
FROM python:3.12-slim AS builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# ══ STAGE 2 : RUNTIME ══
FROM python:3.12-slim

WORKDIR /app

# Copier les libs Python installées
COPY --from=builder /usr/local /usr/local

# Copier le code de l'application
COPY app/ ./app/

# Créer un user non-root (UID 1001)
RUN adduser --system --uid 1001 --no-create-home appuser && \
    chown -R appuser /app

USER appuser

EXPOSE 5000

# Healthcheck sur /health
HEALTHCHECK --interval=30s --timeout=10s --start-period=15s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# Lancer l'appli avec gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app.main:app"]
RUN pip install flask
