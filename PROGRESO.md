# Por dónde voy (actualizado 2026-11-27)

Trabajo en curso; cuando esté terminado pasa al README.

## 1. HAProxy con un Apache y un Nginx — EN CURSO

Antes el segundo backend era un segundo VirtualHost del mismo Apache. Ahora:
Apache en `127.0.0.1:8081` y **Nginx** en `127.0.0.1:8082` (mismo docroot
`/var/www/servidor2`, SSI con `ssi on` + `set $SERVIDOR`).

Hecho en el servidor:

- [x] Paso 1: estado inicial (captura `antes_puertos`).
- [x] Paso 2: Apache sin el 8082 (`haproxy/ports.conf`, `haproxy/servidores.conf`).
      Copias previas en `/root/ports.conf.antes-nginx` y `/root/servidores.conf.antes-nginx`.
- [x] Paso 3: Nginx instalado sin arrancar (`/usr/sbin/policy-rc.d` con
      `exit 101`, instalar, borrarlo) y `sites-enabled/default` quitado.
- [x] Paso 4: sitio `nginx/servidor2` activado; `nginx -t` OK; `ss` muestra
      haproxy 80/443, apache2 8081, nginx 8082; `curl` al 8082 da
      `Nginx (puerto 8082)`. Nginx no enseña versión (`server_tokens off` de Debian).
- [ ] **Paso 5 (siguiente):** renombrar en `/etc/haproxy/haproxy.cfg` los
      servidores a `apache` y `nginx` y el backend `apaches` → `web`:

```bash
sudo cp /etc/haproxy/haproxy.cfg /root/haproxy.cfg.antes-nginx
sudo sed -i \
  -e 's/server servidor1 127.0.0.1:8081/server apache 127.0.0.1:8081/' \
  -e 's/server servidor2 127.0.0.1:8082/server nginx  127.0.0.1:8082/' \
  -e 's/\bapaches\b/web/g' \
  -e 's/dos Apache/un Apache y un Nginx/g' \
  /etc/haproxy/haproxy.cfg
sudo haproxy -c -f /etc/haproxy/haproxy.cfg && sudo systemctl reload haproxy
for i in 1 2 3 4 5 6; do curl -sI https://donis-asir.ddns.net/ | grep -i x-servidor; done
```

  Capturas: `haproxy_apache_nginx`, `estadisticas_apache_nginx`, (opcional) `web_nginx`.
  Después: copiar el `haproxy.cfg` nuevo al repo (con `CAMBIAR_CONTRASENA`) y
  documentarlo en el README.

Capturas pedidas hasta ahora (en el PC, aún no en `capturas/`): `antes_puertos`, `apache_sin_8082`,
`nginx_instalado`, `nginx_8082`.

## 2. Bloqueo por países — PENDIENTE

Como el post del profesor: `ipset` (`blocked_countries`, listas de
ipdeny.com: CN, RU, KP, IR, SY, VN, KZ, AF, TR) + regla `iptables` DROP en
INPUT. Hacerlo en su versión más sencilla, a mano. Probar con check-host.net
y con los contadores de `iptables -L INPUT -v -n`.

## 3. Después

Balancear HAProxy entre mi instancia y la de un compañero (cada uno reparte
entre los dos).
