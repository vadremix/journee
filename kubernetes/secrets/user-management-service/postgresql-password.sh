#!/bin/bash

SECRET_NAME="user-management-service-db"
SECRET_KEY="password"

./create-or-update-secret.sh -s $SECRET_NAME -k $SECRET_KEY
