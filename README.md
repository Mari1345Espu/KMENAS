# Despliegue rápido - KMEANS

Este repositorio contiene una pequeña aplicación K-Means con dos servicios:

- `Kmeans-backend`: API en Flask (ahora ejecutándose con `gunicorn` en producción).
- `Kmeans-frontend`: UI estática servida por `nginx`.

Ya construimos y subimos las imágenes a Docker Hub bajo el usuario `mafercho`:

- `mafercho/kmeans-backend:latest`
- `mafercho/kmeans-frontend:latest`

Opciones de despliegue recomendadas
----------------------------------

Opción A — Render (rápido, HTTPS automático) — Recomendado para entrega

1. Entra a https://dashboard.render.com y crea una cuenta (si no tienes).
2. Crear el servicio del **backend**:
   - New → Web Service
   - Environment: Docker
   - Docker Image: `docker.io/mafercho/kmeans-backend:latest`
   - Port: `5000`
   - Health Check Path: `/api/health`
   - Start Command: deja vacío (la imagen ya usa `gunicorn`).
3. Crear el servicio del **frontend**:
   - New → Web Service (o Static Site si prefieres)
   - Docker Image: `docker.io/mafercho/kmeans-frontend:latest`
   - Port: `80` (para Web Service) — si eliges Static Site, Render servirá automáticamente.
4. Esperar a que Render haga deploy; obtendrás URLs públicas con HTTPS.

Verificación (local o en Render):

```powershell
# Backend
curl https://<BACKEND_RENDER_URL>/api/health

# Frontend
curl https://<FRONTEND_RENDER_URL>/        # debe devolver el HTML
```

Notas importantes
- Si usas servicios separados, la UI hace peticiones al backend en `http://localhost:5000` por defecto.
  En Render la URL será distinta; edita `Kmeans-frontend/app.js` o configura la URL en tiempo de ejecución.
- Para producción real es mejor usar variables de entorno para la URL del API. En Render: Settings → Environment → Add Environment Variable.

Ejemplo de `render.yaml` (opcional, para deploy vía Git + Render):

```yaml
services:
  - type: web
    name: kmeans-backend
    env: docker
    dockerImage: docker.io/mafercho/kmeans-backend:latest
    plan: starter
    port: 5000
    healthCheckPath: /api/health

  - type: web
    name: kmeans-frontend
    env: docker
    dockerImage: docker.io/mafercho/kmeans-frontend:latest
    plan: starter
    port: 80
```

Opción B — VPS / Droplet (DigitalOcean)

1. Crear un servidor Linux con Docker instalado.
2. En el servidor ejecutar:

```bash
docker pull mafercho/kmeans-backend:latest
docker pull mafercho/kmeans-frontend:latest

docker run -d --name kmeans-backend -p 5000:5000 mafercho/kmeans-backend:latest
docker run -d --name kmeans-frontend -p 80:80 mafercho/kmeans-frontend:latest
```

3. Configurar firewall (ufw) y, si quieres dominio con HTTPS, colocar Nginx como proxy inverso y usar Certbot.

Opción C — Demo rápida (ngrok)

Si necesitas una URL pública temporal para la entrega, usa `ngrok`:

```powershell
# frontend público (URL HTTPS)
ngrok http 80

# backend público (URL HTTPS)
ngrok http 5000
```

Problemas comunes y soluciones
- Si el frontend pide el backend en `http://localhost:5000`, actualiza `app.js` para usar la URL pública del backend (o añade una variable de entorno en Render y modifica `index.html`/`app.js` para leerla).
- Para logs: en Render usa el dashboard → logs; en VPS: `docker logs -f <container>`.

Entrega rápida
- Abre las URLs que Render te proporcione y muestra la UI.
- Muestra que el endpoint de salud responde: `curl https://<BACKEND_URL>/api/health`.

Si quieres, puedo:
- Generar un `render.yaml` adaptado con nombres y variables (ya incluí un ejemplo sencillo). 
- Preparar un pequeño `README-deploy.md` con screenshots/links para tu presentación.

---
`README.md` generado automáticamente por el asistente para ayudarte a desplegar rápidamente.
