#!/bin/bash

# Default values
NAMESPACE="default"
SECRET_NAME=""
SECRET_KEY=""
SECRET_VALUE=""
FORCE_UPDATE=false

# Parse options
while getopts ":n:s:k:v:f" opt; do
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
    v)
      SECRET_VALUE="$OPTARG"
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
if [ -z "$SECRET_NAME" ] || [ -z "$SECRET_KEY" ] || [ -z "$SECRET_VALUE" ]; then
    echo "Both SECRET_NAME (-s), SECRET_KEY (-k), and SECRET_VALUE (-v) arguments are required."
    exit 1
fi

secret_exists() {
    kubectl get secret "$SECRET_NAME" --namespace "$NAMESPACE" &> /dev/null
    return $?
}

key_exists() {
    local key_value
    key_value=$(kubectl get secret "$SECRET_NAME" --namespace="$NAMESPACE" -o jsonpath="{.data.${SECRET_KEY}}" 2>/dev/null)
    [[ -n "$key_value" ]]
}

create_secret() {
    echo "Creating new secret $SECRET_NAME in namespace $NAMESPACE"
    kubectl create secret generic "$SECRET_NAME" \
      --from-literal="$SECRET_KEY=$SECRET_VALUE" \
      --namespace "$NAMESPACE" \
      --save-config
}

update_secret() {
    if key_exists && [ "$FORCE_UPDATE" = false ]; then
        echo -e "\033[1;33mNotice: \033[0;0mKey $SECRET_KEY already exists in secret $SECRET_NAME. Use -f to force update."
        return
    fi

    echo "Updating existing secret $SECRET_NAME in namespace $NAMESPACE"
    kubectl patch secret "$SECRET_NAME" \
      --namespace="$NAMESPACE" \
      --type='json' \
      -p="[{\"op\": \"add\", \"path\": \"/data/$SECRET_KEY\", \"value\": \"$(echo -n "$SECRET_VALUE" | base64)\"}]"
}

# Main logic
if secret_exists; then
    update_secret
else
    create_secret
fi

echo "Secret setup finished."