# 📋 Hoja de Referencia Rápida - K-Means Deployment

## 🚀 Comandos Más Rápidos

### Despliegue Local (2 minutos)
```bash
git clone https://github.com/Mari1345Espu/KMENAS.git
cd KMENAS
./deploy-local.sh
```
**Acceder:** http://localhost

### Despliegue con Docker Compose
```bash
docker compose -f docker-compose.prebuilt.yml up -d
```

### Detener Servicios
```bash
docker compose -f docker-compose.prebuilt.yml down
```

---

## 🔍 Verificación Rápida

### Backend Health Check
```bash
curl http://localhost:5000/api/health
```
**Respuesta esperada:** `{"status":"healthy","message":"K-Means API funcionando"}`

### Ver Logs
```bash
# Todos los servicios
docker compose -f docker-compose.prebuilt.yml logs -f

# Solo backend
docker compose -f docker-compose.prebuilt.yml logs -f backend

# Solo frontend
docker compose -f docker-compose.prebuilt.yml logs -f frontend
```

### Estado de Contenedores
```bash
docker compose -f docker-compose.prebuilt.yml ps
```

---

## 📊 Endpoints de la API

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/api/health` | GET | Verificar que el backend funciona |
| `/api/generar-vecindarios` | POST | Generar puntos aleatorios |
| `/api/calcular-hospitales` | POST | Ejecutar algoritmo K-Means |
| `/api/analizar-k-optimo` | POST | Encontrar k óptimo (método del codo) |

### Ejemplo: Generar Vecindarios
```bash
curl -X POST http://localhost:5000/api/generar-vecindarios \
  -H "Content-Type: application/json" \
  -d '{"n_vecindarios": 50, "tamano_espacio": 100}'
```

### Ejemplo: Calcular Hospitales
```bash
curl -X POST http://localhost:5000/api/calcular-hospitales \
  -H "Content-Type: application/json" \
  -d '{
    "vecindarios": [[10,20], [30,40], [50,60]],
    "k": 3,
    "tamano_espacio": 100
  }'
```

---

## 🐳 Comandos Docker Útiles

### Reiniciar Servicios
```bash
docker compose -f docker-compose.prebuilt.yml restart
```

### Actualizar Imágenes
```bash
docker compose -f docker-compose.prebuilt.yml pull
docker compose -f docker-compose.prebuilt.yml up -d
```

### Limpiar Todo
```bash
docker compose -f docker-compose.prebuilt.yml down -v
docker system prune -a  # ⚠️ Limpia TODO Docker
```

### Acceder al Contenedor
```bash
# Backend
docker exec -it kmeans-backend /bin/bash

# Frontend
docker exec -it kmeans-frontend /bin/sh
```

---

## 🌐 Despliegue Render.com

### Método 1: Blueprint (Recomendado)
1. Ir a https://render.com
2. New → Blueprint
3. Conectar repo: `Mari1345Espu/KMENAS`
4. Deploy automático usando `render.yaml`

### Método 2: Manual
**Backend:**
```
Type: Web Service
Docker Image: docker.io/mafercho/kmeans-backend:latest
Port: 5000
Health Check: /api/health
```

**Frontend:**
```
Type: Web Service
Docker Image: docker.io/mafercho/kmeans-frontend:latest
Port: 80
```

---

## 🖥️ Despliegue VPS

### Script Automático
```bash
ssh usuario@tu-servidor
git clone https://github.com/Mari1345Espu/KMENAS.git
cd KMENAS/deploy
chmod +x deploy_vps.sh
./deploy_vps.sh
```

### Manual con Docker
```bash
# Descargar imágenes
docker pull mafercho/kmeans-backend:latest
docker pull mafercho/kmeans-frontend:latest

# Ejecutar
docker run -d --name backend -p 5000:5000 mafercho/kmeans-backend:latest
docker run -d --name frontend -p 80:80 mafercho/kmeans-frontend:latest
```

---

## 🔧 Solución de Problemas

### Puerto 80 ocupado
```bash
# Cambiar puerto frontend a 8080
docker run -d --name frontend -p 8080:80 mafercho/kmeans-frontend:latest
```

### Backend no responde
```bash
# Ver logs del backend
docker compose -f docker-compose.prebuilt.yml logs backend

# Reiniciar solo backend
docker compose -f docker-compose.prebuilt.yml restart backend
```

### Limpiar y reiniciar
```bash
docker compose -f docker-compose.prebuilt.yml down
docker compose -f docker-compose.prebuilt.yml up -d --force-recreate
```

### Verificar conectividad interna
```bash
docker exec -it kmeans-frontend wget -O- http://backend:5000/api/health
```

---

## 📱 URLs Importantes

### Local
- Frontend: http://localhost
- Backend: http://localhost:5000
- Health Check: http://localhost:5000/api/health

### Render (ejemplo)
- Frontend: https://kmeans-frontend-xxxx.onrender.com
- Backend: https://kmeans-backend-xxxx.onrender.com

### VPS (tu dominio)
- Frontend: https://tudominio.com
- Backend: https://api.tudominio.com

---

## 📚 Documentación Completa

- **QUICK_START.md** - Guía paso a paso completa
- **DEPLOY_OPTIONS.md** - Comparación de todos los métodos
- **DEPLOYMENT_FLOWCHART.md** - Diagramas y arquitectura
- **README.md** - Documentación técnica detallada
- **deploy/README_VPS.md** - Guía específica para VPS

---

## 🆘 Ayuda Rápida

**Error: Docker no encontrado**
```bash
# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

**Error: Permiso denegado en Docker**
```bash
sudo usermod -aG docker $USER
# Luego cerrar sesión y volver a entrar
```

**Error: Puerto ocupado**
```bash
# Ver qué está usando el puerto 80
sudo lsof -i :80

# Detener servicio (ejemplo: nginx)
sudo systemctl stop nginx
```

---

## ⏱️ Tiempos de Despliegue

| Método | Primera vez | Actualizaciones |
|--------|-------------|-----------------|
| Local | 2-3 min | 30 seg |
| Render | 5-7 min | 3-5 min |
| VPS | 15-20 min | 1-2 min |

---

## 🎯 Decisión Rápida

```
¿Solo desarrollo? → Local (2 min)
¿Demo rápida? → Render (5 min)  
¿Producción seria? → VPS (15 min)
```

---

**¡Imprime esta hoja para tenerla siempre a mano! 📄**
