#!/bin/sh
# /etc/letsencrypt/renewal-hooks/deploy/haproxy.sh
# Certbot lo ejecuta tras cada renovación: junta certificado y clave y recarga HAProxy
set -e
DOM=donis-asir.ddns.net
cat /etc/letsencrypt/live/$DOM/fullchain.pem /etc/letsencrypt/live/$DOM/privkey.pem > /etc/haproxy/certs/$DOM.pem
chmod 600 /etc/haproxy/certs/$DOM.pem
systemctl reload haproxy
