# ─────────────────────────────────────────────────────────────
#  Dockerfile — MAHIR BD Bot Squad Panel
#  FastAPI + Uvicorn (ASGI) for Railway
# ─────────────────────────────────────────────────────────────

FROM python:3.11-slim

# System deps (aiohttp, cryptography, protobuf build এর জন্য দরকারি)
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        gcc \
        libssl-dev \
        libffi-dev \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Working dir
WORKDIR /app

# Python env
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# ── Dependencies ──
# Railway এ $PORT অটো inject হয়, তাই ENV এ হার্ডকোড না করাই ভালো
COPY requirements.txt /app/requirements.txt

RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# ── App files ──
COPY . /app

# Railway dynamically PORT দেয় (default 8080)
EXPOSE 8080

# ── ASGI server (FastAPI-এর জন্য সঠিক) ──
# Railway এর $PORT ব্যবহার করছি, fallback 8080
CMD ["sh", "-c", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-8080}"]