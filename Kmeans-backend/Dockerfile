# Dockerfile.backend
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
# Upgrade pip/tools first (helps pick compatible wheels) then install requirements
RUN pip install --upgrade pip setuptools wheel \
	&& pip install -r requirements.txt

COPY app.py .

EXPOSE 5000

# Use gunicorn for production-grade serving
# Render sets PORT env var, default to 5000 for local development
CMD gunicorn -w 4 -b 0.0.0.0:${PORT:-5000} app:app