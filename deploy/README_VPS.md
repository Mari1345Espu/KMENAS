# Despliegue en VPS (Ubuntu) - KMEANS

Este archivo contiene pasos rápidos para desplegar la aplicación en un VPS (ej. DigitalOcean, AWS EC2, Linode) usando Docker + nginx + Certbot para HTTPS.

Resumen
- Usaremos `docker compose` para ejecutar backend y frontend (ambos ya están en Docker Hub: `mafercho/*`).
- nginx en el host hará reverse-proxy y obtendrá certificados Let’s Encrypt.

Pasos (ejecuta en la VPS como usuario con sudo)

1) Actualizar el sistema

```bash
sudo apt update && sudo apt upgrade -y
```

2) Instalar Docker y Docker Compose plugin

```bash
# Docker
curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Docker Compose plugin (si no viene instalado)
sudo apt install -y docker-compose-plugin
```

3) Crear carpeta de despliegue y copiar los ficheros del repo (o clonar tu repo)

```bash
mkdir -p ~/kmeans-deploy && cd ~/kmeans-deploy
# Copia aquí deploy/docker-compose.vps.yml y deploy/nginx_kmeans.conf desde tu máquina local
# ejemplo con scp (desde tu máquina local):
# scp -r ./deploy user@your-vps:/home/user/kmeans-deploy
```

4) Levantar los contenedores

```bash
# Desde ~/kmeans-deploy
docker compose -f docker-compose.vps.yml up -d

# Verifica que los contenedores estén corriendo
docker compose -f docker-compose.vps.yml ps
```

5) Instalar nginx en el host y configurar el proxy

```bash
sudo apt install -y nginx

# Copia el archivo de ejemplo a sites-available (reemplaza example.com por tu dominio)
sudo cp nginx_kmeans.conf /etc/nginx/sites-available/kmeans
sudo ln -s /etc/nginx/sites-available/kmeans /etc/nginx/sites-enabled/kmeans

# Test y reload
sudo nginx -t && sudo systemctl reload nginx
```

6) Abrir firewall (ufw) si está activo

```bash
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
sudo ufw enable
```

7) Obtener un certificado HTTPS con Certbot

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d example.com -d www.example.com

# Configurar renovación automática (ya lo añade certbot), pero puedes probar:
sudo certbot renew --dry-run
```

8) Verificar la app

- Frontend: https://example.com
- Backend health: https://example.com/api/health

Notas y recomendaciones
- Reemplaza `example.com` por tu dominio real antes de ejecutar los pasos de nginx/certbot.
- El `docker-compose.vps.yml` expone los servicios solo en `127.0.0.1` para que nginx sea el único punto público. 
- Como el frontend usa rutas relativas (`/api`), no necesitas cambiar nada en la app después de este proxy.
- Si usas un proveedor de DNS, añade un registro A para `example.com` apuntando a la IP de la VPS.

Soporte adicional
- Si quieres, puedo generar un script completo `deploy_vps.sh` para automatizar los pasos anteriores (te pedirá confirmar el dominio). ¿Lo deseas?
