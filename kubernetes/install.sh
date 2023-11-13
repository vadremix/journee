#!/bin/bash

# Navigate to the directory this script resides in
cd "$(dirname "$0")"

echo "Setting all secrets..."
./secrets/set-all-secrets.sh
echo "All secrets set."

echo "Configuring kubernetes for and installing Emissary-ingress..."
helm repo add datawire https://app.getambassador.io
helm repo update

kubectl apply -f https://app.getambassador.io/yaml/emissary/3.9.0/emissary-crds.yaml
kubectl wait --timeout=90s --for=condition=available deployment emissary-apiext -n emissary-system

helm install -n emissary --create-namespace \
   emissary-ingress datawire/emissary-ingress && \
kubectl rollout status  -n emissary deployment/emissary-ingress -w
echo "Emissary-ingress installed."

# TODO: Set up routing
# TODO: Manage docker images
# TODO: Install helm charts for each service

