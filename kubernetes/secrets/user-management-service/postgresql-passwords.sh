#!/bin/bash

SECRET_NAME="user-management-service-db"

SECRET_USER_KEY="user-password"
SECRET_USER_VALUE=$(openssl rand -base64 12)

SECRET_ADMIN_KEY="postgres-password"
SECRET_ADMIN_VALUE=$(openssl rand -base64 12)

./create-or-update-secret.sh -s $SECRET_NAME -k $SECRET_USER_KEY -v "$SECRET_USER_VALUE"
./create-or-update-secret.sh -s $SECRET_NAME -k $SECRET_ADMIN_KEY -v "$SECRET_ADMIN_VALUE"
