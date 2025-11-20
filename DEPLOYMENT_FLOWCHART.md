# 🗺️ Guía Visual de Despliegue - K-Means

## Diagrama de Decisión

```
┌─────────────────────────────────────────────────┐
│     ¿Cómo quieres desplegar K-Means?           │
└────────────────┬────────────────────────────────┘
                 │
                 ▼
    ┌────────────────────────────┐
    │ ¿Necesitas acceso público? │
    └────────┬────────────┬──────┘
             │            │
         NO  │            │  SÍ
             ▼            ▼
    ┌────────────┐  ┌────────────────┐
    │ DOCKER     │  │ ¿Tienes VPS    │
    │ LOCAL      │  │ propio?        │
    │            │  └─────┬────┬─────┘
    │ 2 minutos  │        │    │
    │ ⚡ RÁPIDO  │    NO  │    │  SÍ
    └────────────┘        ▼    ▼
                   ┌──────────┐ ┌──────────┐
                   │ RENDER   │ │ VPS CON  │
                   │ .com     │ │ SCRIPT   │
                   │          │ │          │
                   │ 5 min    │ │ 15 min   │
                   │ ☁️ CLOUD │ │ 🖥️ SERVER│
                   └──────────┘ └──────────┘
```

---

## 🚀 Flujo de Despliegue Local

```
1. Instalar Docker
   └─▶ https://docs.docker.com/get-docker/

2. Clonar repositorio
   └─▶ git clone https://github.com/Mari1345Espu/KMENAS.git
   └─▶ cd KMENAS

3. Ejecutar script
   └─▶ ./deploy-local.sh
        │
        ├─▶ Descarga imágenes de Docker Hub
        ├─▶ Inicia backend (puerto 5000)
        ├─▶ Inicia frontend (puerto 80)
        └─▶ Verifica salud del sistema

4. ¡Listo! 
   └─▶ http://localhost
```

**Tiempo total: ~2 minutos**

---

## ☁️ Flujo de Despliegue en Render.com

```
1. Crear cuenta Render
   └─▶ https://render.com (gratis)

2. Conectar repositorio GitHub
   └─▶ New → Blueprint
   └─▶ Seleccionar repo: Mari1345Espu/KMENAS
   └─▶ Render detecta render.yaml automáticamente

3. Deploy automático
   └─▶ Backend desplegado en: https://kmeans-backend-*.onrender.com
   └─▶ Frontend desplegado en: https://kmeans-frontend-*.onrender.com

4. HTTPS automático ✅
   └─▶ Certificados SSL incluidos
```

**Tiempo total: ~5 minutos**

---

## 🖥️ Flujo de Despliegue en VPS

```
1. Crear VPS
   └─▶ DigitalOcean, AWS, Linode, etc.
   └─▶ Sistema: Ubuntu 20.04+ recomendado

2. Configurar dominio
   └─▶ Registro A → IP de tu VPS
   └─▶ Registro A → api.tudominio.com → IP de tu VPS

3. Conectar y ejecutar
   └─▶ ssh usuario@tu-servidor
   └─▶ git clone https://github.com/Mari1345Espu/KMENAS.git
   └─▶ cd KMENAS/deploy
   └─▶ ./deploy_vps.sh
        │
        ├─▶ Instala Docker
        ├─▶ Configura nginx-proxy
        ├─▶ Configura Let's Encrypt (HTTPS)
        └─▶ Despliega servicios

4. ¡Producción lista!
   └─▶ https://tudominio.com
   └─▶ https://api.tudominio.com
```

**Tiempo total: ~15 minutos**

---

## 📊 Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────┐
│                    USUARIO                          │
└────────────────────┬────────────────────────────────┘
                     │
                     ▼
        ┌────────────────────────┐
        │  NAVEGADOR WEB         │
        │  (Puerto 80/443)       │
        └──────────┬─────────────┘
                   │
                   ▼
        ┌────────────────────────┐
        │  FRONTEND              │
        │  (Nginx + HTML/JS/CSS) │
        │  Puerto: 80            │
        └──────────┬─────────────┘
                   │
                   │ HTTP/HTTPS
                   │ /api/*
                   ▼
        ┌────────────────────────┐
        │  BACKEND               │
        │  (Flask + Gunicorn)    │
        │  Puerto: 5000          │
        │                        │
        │  Endpoints:            │
        │  - /api/health         │
        │  - /api/generar-*      │
        │  - /api/calcular-*     │
        └────────────────────────┘
```

---

## 🔄 Proceso de Actualización

### Método Local
```bash
cd KMENAS
docker compose -f docker-compose.prebuilt.yml pull  # Descargar última versión
docker compose -f docker-compose.prebuilt.yml up -d # Reiniciar
```

### Método Render.com
```
Git Push → Render detecta cambios → Deploy automático
```

### Método VPS
```bash
cd KMENAS/deploy
docker compose -f docker-compose.proxy.yml pull
docker compose -f docker-compose.proxy.yml up -d
```

---

## 🛡️ Seguridad por Método

| Aspecto | Local | Render | VPS |
|---------|-------|--------|-----|
| HTTPS | ❌ | ✅ Automático | ✅ Let's Encrypt |
| Firewall | ⚠️ Sistema | ✅ Render | 🔧 Configurar |
| Updates | Manual | Automático | Manual |
| Backups | Manual | ✅ Automático | 🔧 Configurar |
| DDoS Protection | ❌ | ✅ | ⚠️ Opcional |

---

## 💰 Costos Estimados

```
┌──────────────┬──────────┬────────────────────────┐
│   Método     │  Costo   │  Ideal para            │
├──────────────┼──────────┼────────────────────────┤
│ Local        │ $0       │ Desarrollo, demos      │
│ Render       │ $0-$7    │ Proyectos pequeños     │
│ VPS (DO)     │ $5-10    │ Producción, control    │
│ AWS          │ $3-15    │ Escalabilidad          │
└──────────────┴──────────┴────────────────────────┘
```

---

## 📈 Escalabilidad

### Tráfico Bajo (< 1000 usuarios/día)
→ **Render Free** o **VPS básico ($5/mes)**

### Tráfico Medio (1K-10K usuarios/día)
→ **Render Starter ($7/mes)** o **VPS medio ($10-20/mes)**

### Tráfico Alto (> 10K usuarios/día)
→ **VPS potente** + **CDN** + **Load Balancer**

---

## 🎓 Recursos de Aprendizaje

- **Docker Básico**: https://docs.docker.com/get-started/
- **Docker Compose**: https://docs.docker.com/compose/
- **Nginx**: https://nginx.org/en/docs/
- **Flask Deployment**: https://flask.palletsprojects.com/en/stable/deploying/
- **Let's Encrypt**: https://letsencrypt.org/getting-started/

---

## ✅ Checklist Pre-Despliegue

### Local
- [ ] Docker instalado
- [ ] Puerto 80 disponible
- [ ] Puerto 5000 disponible

### Render
- [ ] Cuenta Render creada
- [ ] Repositorio en GitHub
- [ ] render.yaml presente

### VPS
- [ ] VPS creado y accesible
- [ ] Dominio configurado
- [ ] Puertos 80, 443 abiertos
- [ ] SSH key configurado

---

**¿Listo? Consulta [QUICK_START.md](QUICK_START.md) para comenzar! 🚀**
