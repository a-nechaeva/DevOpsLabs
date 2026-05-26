#!/bin/bash
cd nginx/ssl

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout app1.local.key \
  -out app1.local.crt \
  -subj "/C=US/ST=State/L=City/O=Dev/CN=app1.local"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout app2.local.key \
  -out app2.local.crt \
  -subj "/C=US/ST=State/L=City/O=Dev/CN=app2.local"

echo "DONE"