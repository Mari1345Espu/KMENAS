# 🚀 DESPLIEGUE RÁPIDO - KMEANS

Este documento te muestra la **forma más rápida** de desplegar la aplicación K-Means.

## 📋 ¿Qué es esta aplicación?

Una aplicación web para clustering K-Means con:
- **Backend**: API REST en Flask/Python
- **Frontend**: Interfaz web estática
- **Docker**: Imágenes pre-construidas y listas para usar

---

## ⚡ OPCIÓN 1: Despliegue Local (2 minutos)

### Prerequisito
- Tener Docker instalado ([Instalar Docker](https://docs.docker.com/get-docker/))

### Pasos

1️⃣ **Clonar el repositorio (o descargar el docker-compose.yml)**
```bash
git clone https://github.com/Mari1345Espu/KMENAS.git
cd KMENAS
```

2️⃣ **Ejecutar un solo comando**
```bash
# Opción A: Usar script automático (recomendado)
./deploy-local.sh

# Opción B: Comando directo con imágenes pre-construidas
docker compose -f docker-compose.prebuilt.yml up -d

# Opción C: Construir localmente (más lento)
docker compose up -d
```

3️⃣ **¡Listo! Abrir en el navegador**
- Frontend: http://localhost
- Backend API: http://localhost:5000/api/health

### Comandos útiles
```bash
# Ver logs
docker compose -f docker-compose.prebuilt.yml logs -f

# Detener la aplicación
docker compose -f docker-compose.prebuilt.yml down

# Reiniciar
docker compose -f docker-compose.prebuilt.yml restart

# O simplemente si usaste docker-compose.yml
docker compose logs -f
docker compose down
docker compose restart
```

---

## ☁️ OPCIÓN 2: Despliegue en la Nube con Render.com (5 minutos)

**Render.com** ofrece HTTPS automático y es GRATIS para proyectos pequeños.

### Pasos

1️⃣ **Crear cuenta en Render**
- Ir a https://render.com y crear una cuenta gratuita

2️⃣ **Desplegar el Backend**
- Click en `New +` → `Web Service`
- Seleccionar `Deploy an existing image from a registry`
- Image URL: `docker.io/mafercho/kmeans-backend:latest`
- Name: `kmeans-backend` (o el nombre que prefieras)
- Region: Selecciona la más cercana
- Instance Type: `Free`
- Hacer click en `Advanced`:
  - Port: `5000`
  - Health Check Path: `/api/health`
- Click en `Deploy Web Service`

3️⃣ **Desplegar el Frontend**
- Click en `New +` → `Web Service`
- Seleccionar `Deploy an existing image from a registry`
- Image URL: `docker.io/mafercho/kmeans-frontend:latest`
- Name: `kmeans-frontend`
- Region: La misma que el backend
- Instance Type: `Free`
- Hacer click en `Advanced`:
  - Port: `80`
- Click en `Deploy Web Service`

4️⃣ **Obtener las URLs**
Render te dará URLs públicas con HTTPS automático:
- Frontend: `https://kmeans-frontend-xxxx.onrender.com`
- Backend: `https://kmeans-backend-xxxx.onrender.com`

⚠️ **NOTA IMPORTANTE**: El frontend usa `/api` como ruta del backend. Para que funcione correctamente en Render con servicios separados, necesitas:
- Opción A: Usar ambos servicios bajo el mismo dominio con un proxy
- Opción B: Modificar `app.js` para apuntar a la URL completa del backend

---

## 🔧 OPCIÓN 3: Despliegue en VPS con HTTPS (15 minutos)

Para un servidor propio (DigitalOcean, AWS, etc.)

### Prerequisitos
- Un VPS con Ubuntu
- Un dominio apuntando a tu VPS

### Script Automático

1️⃣ **Conectar a tu VPS**
```bash
ssh usuario@tu-servidor.com
```

2️⃣ **Clonar el repositorio**
```bash
git clone https://github.com/Mari1345Espu/KMENAS.git
cd KMENAS/deploy
```

3️⃣ **Ejecutar el script de despliegue**
```bash
chmod +x deploy_vps.sh
./deploy_vps.sh
```

El script te preguntará:
- Tu dominio (ej: `miapp.com`)
- Tu email para Let's Encrypt

4️⃣ **¡Listo!**
- Frontend: `https://tu-dominio.com`
- Backend: `https://api.tu-dominio.com/api/health`

El script configura automáticamente:
- ✅ Docker y Docker Compose
- ✅ Nginx como reverse proxy
- ✅ Certificados SSL con Let's Encrypt
- ✅ Renovación automática de certificados

---

## 📊 Verificar que funciona

### Probar el Backend
```bash
curl http://localhost:5000/api/health
# Respuesta: {"status":"healthy","message":"K-Means API funcionando"}
```

### Probar el Frontend
Abre http://localhost en tu navegador y deberías ver:
- Un formulario para generar vecindarios
- Controles para ejecutar K-Means
- Gráficos de visualización

---

## 🆘 Solución de Problemas

### El frontend no se conecta al backend
- **Local**: Verifica que ambos contenedores estén corriendo: `docker compose ps`
- **Render**: Actualiza `API_URL` en `app.js` con la URL completa de tu backend

### Los contenedores no inician
```bash
# Ver los logs
docker compose logs

# Reiniciar
docker compose restart
```

### Puerto ocupado
Si el puerto 80 está ocupado:
```bash
# Editar docker-compose.yml y cambiar:
ports:
  - "8080:80"  # Ahora usar http://localhost:8080
```

---

## 📚 Documentación Adicional

- **README.md**: Documentación completa del proyecto
- **deploy/README_VPS.md**: Guía detallada para VPS
- **Dockerfiles**: En `Kmeans-backend/` y `Kmeans-frontend/`

---

## 🎯 Resumen de Tiempos

| Método | Tiempo | Dificultad | HTTPS | Costo |
|--------|--------|------------|-------|-------|
| Docker Local | 2 min | ⭐ Fácil | ❌ | Gratis |
| Render.com | 5 min | ⭐⭐ Fácil | ✅ | Gratis |
| VPS con Script | 15 min | ⭐⭐⭐ Medio | ✅ | $5-10/mes |

---

## 🤝 Soporte

¿Problemas? Abre un issue en GitHub o contacta al equipo.

**¡Feliz despliegue! 🎉**
