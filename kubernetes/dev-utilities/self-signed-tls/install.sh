#!/bin/bash

# Navigate to the directory this script resides in
cd "$(dirname "$0")"

openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -subj '/CN=journee-dev' -nodes
kubectl create secret tls dev-tls-cert --cert=cert.pem --key=key.pem
kubectl apply -f dev-tls-host.yaml

rm key.pem cert.pem

echo "TLS certificate installed."