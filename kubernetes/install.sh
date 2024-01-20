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

kubectl apply -f ./services/api-gateway/emissary-ingress-listener-http.yaml
kubectl apply -f ./services/api-gateway/emissary-ingress-listener-https.yaml
echo "Emissary-ingress installed."

echo -e "\033[1;33m[Prompt] \033[0;0mWould you like to install a self-signed TLS certificate? (y/n)"
read -r REPLY
if [ "$REPLY" == "y" ]; then
    echo "Installing self-signed TLS certificate..."
    ./dev-utilities/self-signed-tls/install.sh
    echo "Self-signed TLS certificate installed."
fi

echo -e "\033[1;33m[Prompt] \033[0;0mWould you like to install pgAdmin4? (y/n)"
read -r REPLY
if [ "$REPLY" == "y" ]; then
    echo "Installing pgAdmin4..."
    ./dev-utilities/pgadmin4/install.sh
    echo "pgAdmin4 installed."
fi

# TODO: Set up routing
# TODO: Manage docker images
# TODO: Install helm charts for each service

echo "Setup finished."
echo "Run 'kubectl get service -n emissary' to see the ingress IP address."
echo "If EXTERNAL-IP is pending, an external load balancer is needed."
echo "For minikube, see https://minikube.sigs.k8s.io/docs/handbook/accessing/#using-minikube-tunnel"