FROM python:3.11-slim as builder

WORKDIR /app

RUN pip install poetry=1.6.1
COPY pyproject.toml poetry.lock* ./
RUN poetry config virtualenvs.in-project true && poetry install --only main --no-root


FROM python:3.11-slim as runtime


WORKDIR /app

#* Create non-root user
RUN groupadd -r appuser && useradd -r -g appuser appuser

#* Copy virtual envirorment from builder
COPY --from=buffer /app/.venv .venv
COPY . .

#* Ensure .venv is accessible
ENV PATH="/app/.venv/bin:$PATH"

#* crete logs directory
RUN mkdir -p /app/logs && chown -R appuser:appuser /app

USER appuser

EXPOSE 8001

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 CMD curl -f http://localhost:8001/health || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8001", "==workers", "2"]