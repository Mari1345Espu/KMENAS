#!/bin/bash
# Script de despliegue local ultra-rápido para K-Means
# Uso: ./deploy-local.sh

set -e

echo "🚀 Iniciando despliegue local de K-Means..."

# Verificar que Docker está instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker no está instalado."
    echo "📥 Instala Docker desde: https://docs.docker.com/get-docker/"
    exit 1
fi

# Verificar que Docker Compose está disponible
if ! docker compose version &> /dev/null; then
    echo "❌ Error: Docker Compose no está disponible."
    echo "📥 Instala Docker Compose plugin desde: https://docs.docker.com/compose/install/"
    exit 1
fi

# Detener contenedores anteriores si existen
echo "🧹 Limpiando contenedores anteriores..."
docker compose -f docker-compose.prebuilt.yml down 2>/dev/null || true
docker compose down 2>/dev/null || true

# Descargar las imágenes más recientes (pre-construidas)
echo "📦 Descargando imágenes de Docker Hub..."
docker compose -f docker-compose.prebuilt.yml pull

# Iniciar los servicios
echo "🔄 Iniciando servicios..."
docker compose -f docker-compose.prebuilt.yml up -d

# Esperar a que los servicios estén listos
echo "⏳ Esperando a que los servicios inicien..."
sleep 5

# Verificar el estado
echo ""
echo "📊 Estado de los servicios:"
docker compose -f docker-compose.prebuilt.yml ps

# Verificar que el backend responde
echo ""
echo "🔍 Verificando backend..."
if curl -s http://localhost:5000/api/health > /dev/null 2>&1; then
    echo "✅ Backend funcionando correctamente"
else
    echo "⚠️  Backend aún no responde, puede tardar unos segundos más"
fi

# Mostrar información final
echo ""
echo "================================================"
echo "✅ ¡Despliegue completado!"
echo "================================================"
echo ""
echo "🌐 Accede a la aplicación:"
echo "   Frontend: http://localhost"
echo "   Backend:  http://localhost:5000/api/health"
echo ""
echo "📝 Comandos útiles:"
echo "   Ver logs:     docker compose logs -f"
echo "   Detener:      docker compose down"
echo "   Reiniciar:    docker compose restart"
echo ""
echo "🎉 ¡Disfruta usando K-Means!"
echo ""
