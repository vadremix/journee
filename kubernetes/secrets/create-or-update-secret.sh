#!/bin/bash

# Default values
NAMESPACE="default"
SECRET_NAME=""
SECRET_KEY=""
FORCE_UPDATE=false

# Parse options
while getopts ":n:s:k:f" opt; do
  case $opt in
    n)
      NAMESPACE="$OPTARG"
      ;;
    s)
      SECRET_NAME="$OPTARG"
      ;;
    k)
      SECRET_KEY="$OPTARG"
      ;;
    f)
      FORCE_UPDATE=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

# Validate required arguments
if [ -z "$SECRET_NAME" ] || [ -z "$SECRET_KEY" ]; then
    echo "Both SECRET_NAME (-s) and SECRET_KEY (-k) arguments are required."
    exit 1
fi

# Generate a new password
PASSWORD=$(openssl rand -base64 12)

# Function to check if the secret already exists
secret_exists() {
    kubectl get secret "$SECRET_NAME" --namespace "$NAMESPACE" &> /dev/null
    return $?
}

# Function to create the secret
create_secret() {
    echo "Creating new secret $SECRET_NAME in namespace $NAMESPACE"
    kubectl create secret generic "$SECRET_NAME" \
      --from-literal="$SECRET_KEY=$PASSWORD" \
      --namespace "$NAMESPACE" \
      --save-config
}

# Function to update the secret
update_secret() {
    echo "Updating existing secret $SECRET_NAME in namespace $NAMESPACE"
    kubectl create secret generic "$SECRET_NAME" \
      --from-literal="$SECRET_KEY=$PASSWORD" \
      --namespace "$NAMESPACE" \
      --dry-run=client -o yaml | kubectl apply -f -
}

# Main logic
if secret_exists; then
    if [ "$FORCE_UPDATE" = true ]; then
        # If force flag is set, update the secret
        update_secret
    else
        # If force flag is not set, do not update
        echo -e "\033[1;33mNotice: \033[0;0mSecret $SECRET_NAME already exists. Use -f to force update."
    fi
else
    # If secret does not exist, create it
    create_secret
fi

echo "Secret setup complete."