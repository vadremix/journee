# Journee

A travel journal platform built with a microservice architecture using Kubernetes.

## Pre-requisites
- docker
- helm
- kubectl
- bash
- minikube*

**any Kubernetes cluster can technically work, however these instructions are written for minikube*

**Important**:
- The installation script is written in Bash and might not work on Windows. It has been tested on a distro based on Ubuntu 22.04.  It will likely work in other Linux distros, but may or may not work on macOS.
- No Docker image registry is currently configured at this time. Images need to be built and used locally. For development, this is being achieved by using a minikube Kubernetes cluster and building images with the minikube Docker daemon. This will be addressed in the future. See: https://minikube.sigs.k8s.io/docs/commands/docker-env/
- Please report any issues encountered with the installation instructions.

## Installation
At this stage, installation is only partially automated.  The following steps are required:
1. Clone the repository
2. CD to the repository root and execute `./kubernetes/install.sh`
3. CD into each service's directory and build the Docker image
   1. Run `eval $(minikube docker-env)` before building the first image
   2. Run `docker buildx build . -t journee/<servcie name>:latest`. Replace <service name> with the name of the service, e.g. user-management-service
4. Manually navigate to each service's Helm chart directory (within `./kubernetes/charts`) and execute `helm install <service name> .`

The Kubernetes cluster needs to have ingress support. When using minikube, ingress can be enabled with `minikube addons enable ingress`.

With minikube, running `minikube dashboard` is a convenient way to view the cluster and services.

## Running tests
There is no unified way of running tests at this time. Each service has its own test suite and instructions for running them are or will be in the service's README.md file.

## Dev utilities
### pgadmin4
There is a script that can be used to set up pgadmin4:  
`./kubernetes/dev-utilities/pgadmin4/install.sh -p <password>`  

The `-p` flag is optional. If not provided, a random password will be generated.

When the install script finishes, it will print out:
- username: pgadmin@local.dev
- password: <password>

These credentials are for pgadmin4 itself. Connection information for each service's database should be set up, but you 
need to retrieve the password for each. For example:  
`kubectl get secret user-management-service-db -o jsonpath=\"{.data.postgres-password}\" | base64 --decode`

There is no persistence for pgadmin4. If the password is lost, run `helm uninstall pgadmin4` and then run the installation script again. This will create a new instance of pgadmin4 with a new password.

It is also necessary to add `pgadmin.local` to the local `hosts` file. With minikube and Linux, this can be done with `echo "$(minikube ip) pgadmin.local" | sudo tee -a /etc/hosts`.

## What's currently working
- user-management-service is built with a multi-stage Dockerfile
- user-management-service and its database are deployed with Helm
- user-management-service connects to its database

Near term goals:
- user-management-service has a basic authentication system
- user-management-service is accessible through the API gateway

## API Gateway
The API gateway being used is Emissary-ingress. Routing is not currently set up.

## Services
The following services are currently being developed:
- user-management-service
- journal-entry-service
- media-content-service

A UI will be implemented when a reasonable amount of functionality is in place.