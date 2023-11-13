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

If you're using minikube, you can run `minikube dashboard` as a convenient way to view the cluster and services.

## Running tests
There is no unified way of running tests at this time. Each service has its own test suite and instructions for running them are or will be in the service's README.md file.

## What's currently working
Not much:
- user-management-service is built with a multi-stage Dockerfile
- user-management-service runs in a pod and responds to internal http requests

## API Gateway
The API gateway being used is Emissary-ingress. Routing is not currently set up.

## Services
The following services are currently being developed:
- user-management-service
- journal-entry-service
- media-content-service

A UI will be implemented when a reasonable amount of functionality is in place.