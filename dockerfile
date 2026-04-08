# ══ STAGE 1 : BUILDER ══
FROM python:3.12-slim AS builder

WORKDIR /build

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# ══ STAGE 2 : RUNTIME ══
FROM python:3.12-slim

WORKDIR /app

COPY --from=builder /usr/local /usr/local
COPY app/ ./app/

# Create non-root user
RUN adduser --system --uid 1001 --no-create-home appuser && \
    chown -R appuser /app

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=10s --start-period=15s \
  --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app.main:app"]