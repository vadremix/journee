#!/bin/bash

# Navigate to the directory this script resides in
cd "$(dirname "$0")"

PGADMIN4_PASSWORD=$(openssl rand -base64 12)

# use getopts to parge a -p flag for the password
while getopts ":p:" opt; do
  case $opt in
    p)
      PGADMIN4_PASSWORD="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

helm repo add runix https://helm.runix.net
helm install pgadmin4 runix/pgadmin4 \
    --set ingress.enabled=true \
    --set ingress.ingressClassName=ambassador \
    --set ingress.hosts[0].host=pgadmin.local \
    --set ingress.hosts[0].paths[0].path=/ \
    --set ingress.hosts[0].paths[0].pathType=Prefix \
    --set persistence.enabled=false \
    --set env.email="pgadmin@local.dev" \
    --set env.password="$PGADMIN4_PASSWORD" \
    --set serverDefinitions.enabled=true \
    --set serverDefinitions.servers.1.Name="user-management-service-db" \
    --set serverDefinitions.servers.1.Group="Servers" \
    --set serverDefinitions.servers.1.Port=5432 \
    --set serverDefinitions.servers.1.Username="postgres" \
    --set serverDefinitions.servers.1.Host="user-management-service-db" \
    --set serverDefinitions.servers.1.SSLMode="prefer" \
    --set serverDefinitions.servers.1.MaintenanceDB="postgres"

echo "pgAdmin4 installed with username \"pgadmin@local.dev\" and password \"$PGADMIN4_PASSWORD\"."
echo "To retrieve the admin password for user-management-service-db, run:"
echo "kubectl get secret user-management-service-db -o jsonpath=\"{.data.postgres-password}\" | base64 --decode"