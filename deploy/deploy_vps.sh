#!/usr/bin/env bash
set -euo pipefail

# deploy_vps.sh
# Script de despliegue para VPS usando docker compose + nginx-proxy + acme-companion
# - Pregunta dominio y email
# - Genera .env
# - Levanta los contenedores definidos en docker-compose.proxy.yml

COMPOSE_FILE="$(dirname "$0")/docker-compose.proxy.yml"
WORKDIR="$(dirname "$0")"

if [ "$EUID" -ne 0 ]; then
  echo "Advertencia: se recomienda ejecutar el script como usuario con sudo para instalar Docker si hace falta."
fi

read -p "Dominio principal (ej. example.com): " DOMAIN
read -p "Email para Let's Encrypt (notificaciones): " EMAIL

if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
  echo "Dominio y email son obligatorios. Abortando."
  exit 1
fi

cd "$WORKDIR"

echo "Creando .env con DOMAIN=$DOMAIN y EMAIL=$EMAIL"
cat > .env <<EOF
DOMAIN=$DOMAIN
EMAIL=$EMAIL
EOF

echo "Asegurando que Docker y docker compose plugin estén instalados..."
if ! command -v docker &> /dev/null; then
  echo "Instalando Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
  sudo usermod -aG docker $USER || true
fi

if ! docker compose version &> /dev/null; then
  echo "Instalando docker compose plugin..."
  sudo apt-get update
  sudo apt-get install -y docker-compose-plugin
fi

echo "Creando carpetas locales para certs/vhost/html..."
mkdir -p certs vhost.d html
chmod 755 certs vhost.d html

echo "Lanzando los servicios (esto descargará las imágenes desde Docker Hub)..."
docker compose -f "$COMPOSE_FILE" up -d

echo "Esperando unos segundos para que nginx-proxy y acme-companion inicien..."
sleep 6

echo "Comprobando estado de servicios:"
docker compose -f "$COMPOSE_FILE" ps

echo "Despliegue iniciado. Asegúrate de apuntar el DNS:
  - ${DOMAIN} -> IP_VPS
  - api.${DOMAIN} -> IP_VPS

Cuando los registros DNS apunten, los certificados Let's Encrypt se generarán automáticamente y el frontend quedará disponible en https://${DOMAIN} y la API en https://api.${DOMAIN}/api/health"

echo "Si necesitas detener los servicios: docker compose -f $COMPOSE_FILE down"
