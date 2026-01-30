# Docker Comprehensive Training Guide

## Table of Contents
1. [Introduction to Docker](#introduction-to-docker)
2. [Docker Architecture](#docker-architecture)
3. [Docker Desktop](#docker-desktop)
4. [Docker Commands](#docker-commands)
5. [Dockerfile Syntax](#dockerfile-syntax)
6. [Docker Image Management](#docker-image-management)
7. [Docker Compose](#docker-compose)
8. [Docker Networking](#docker-networking)
9. [Docker Volumes](#docker-volumes)
10. [Container Registry](#container-registry)
11. [Best Practices](#best-practices)

---

## 1. Introduction to Docker

### What is Docker?
Docker is a platform for developing, shipping, and running applications in containers. Containers are lightweight, standalone, executable packages that include everything needed to run an application: code, runtime, system tools, libraries, and settings.

### Key Benefits
- **Consistency**: Same environment across development, testing, and production
- **Isolation**: Applications run in isolated environments
- **Portability**: Containers can run anywhere Docker is supported
- **Efficiency**: Lightweight compared to virtual machines
- **Scalability**: Easy to scale applications horizontally
- **Version Control**: Image versioning and rollback capabilities

### Docker vs Virtual Machines
| Feature | Docker Containers | Virtual Machines |
|---------|------------------|------------------|
| OS | Share host OS kernel | Each VM has its own OS |
| Size | Megabytes | Gigabytes |
| Startup Time | Seconds | Minutes |
| Performance | Near-native | Overhead from virtualization |
| Isolation | Process-level | Complete isolation |

---

## 2. Docker Architecture

### Core Components

#### Docker Engine
The runtime that builds and runs containers, consisting of:
- **Docker Daemon**: Background service managing Docker objects
- **REST API**: Interface for communicating with the daemon
- **Docker CLI**: Command-line interface

#### Docker Objects
- **Images**: Read-only templates for creating containers
- **Containers**: Runnable instances of images
- **Networks**: Communication channels between containers
- **Volumes**: Persistent data storage
- **Registries**: Storage for Docker images (e.g., Docker Hub, Azure Container Registry)

---

## 3. Docker Desktop

### Installation
Docker Desktop provides an easy-to-install application for Mac, Windows, and Linux that includes:
- Docker Engine
- Docker CLI
- Docker Compose
- Kubernetes
- GUI for managing containers and images

### Key Features
- Resource management (CPU, memory allocation)
- Kubernetes integration
- Volume management
- Network configuration
- Extension marketplace

---

## 4. Docker Commands

### Container Management

#### Listing Containers
```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# List containers with specific format
docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}"
```

#### Running Containers
```bash
# Run a container from an image
docker run [image]

# Run with options
docker run -d -p 8080:80 --name myapp nginx

# Run interactively
docker run -it ubuntu /bin/bash

# Run with environment variables
docker run -e "ENV_VAR=value" myapp

# Run with volume mount
docker run -v /host/path:/container/path myapp
```

Common options:
- `-d`: Detached mode (run in background)
- `-p`: Port mapping (host:container)
- `--name`: Assign a name to the container
- `-e`: Set environment variables
- `-v`: Mount volumes
- `--rm`: Automatically remove container when it stops
- `-it`: Interactive terminal

#### Managing Container Lifecycle
```bash
# Start a stopped container
docker start [container]

# Stop a running container
docker stop [container]

# Restart a container
docker restart [container]

# Pause a container
docker pause [container]

# Unpause a container
docker unpause [container]

# Remove a container
docker rm [container]

# Force remove a running container
docker rm -f [container]

# Remove all stopped containers
docker container prune
```

#### Executing Commands in Containers
```bash
# Execute command in running container
docker exec -it [container] [command]

# Examples
docker exec -it myapp /bin/bash
docker exec myapp ls /app
docker exec -it mysql mysql -u root -p
```

#### Inspecting Containers
```bash
# View container logs
docker logs [container]

# Follow logs in real-time
docker logs -f [container]

# View container details
docker inspect [container]

# View container stats
docker stats [container]

# View container processes
docker top [container]
```

### Image Management

#### Listing and Pulling Images
```bash
# List local images
docker images

# List images with digests
docker images --digests

# Pull image from registry
docker pull [image]

# Pull specific version
docker pull ubuntu:20.04
```

#### Building Images
```bash
# Build from Dockerfile in current directory
docker build -t [image-name]:[tag] .

# Build from specific Dockerfile
docker build -f Dockerfile.prod -t myapp:latest .

# Build with build arguments
docker build --build-arg VERSION=1.0 -t myapp .

# Build without cache
docker build --no-cache -t myapp .
```

#### Removing Images
```bash
# Remove an image
docker rmi [image]

# Force remove
docker rmi -f [image]

# Remove all unused images
docker image prune

# Remove all images
docker rmi $(docker images -q)
```

### System & Information

```bash
# Show Docker version
docker version

# Display system-wide information
docker info

# Show disk usage
docker system df

# Remove unused data (containers, images, networks)
docker system prune

# Remove everything including volumes
docker system prune -a --volumes
```

---

## 5. Dockerfile Syntax

A Dockerfile is a text file containing instructions to build a Docker image.

### Basic Structure
```dockerfile
FROM ubuntu:20.04
WORKDIR /app
COPY . .
RUN apt-get update && apt-get install -y python3
CMD ["python3", "app.py"]
```

### Dockerfile Instructions

#### FROM - Base Image
```dockerfile
# Use official image
FROM ubuntu:20.04

# Use specific version
FROM node:18-alpine

# Multi-stage build
FROM node:18 AS build
FROM nginx:alpine AS production
```

#### LABEL - Metadata
```dockerfile
LABEL maintainer="developer@example.com"
LABEL version="1.0"
LABEL description="My application"
```

#### WORKDIR - Working Directory
```dockerfile
# Sets working directory for subsequent instructions
WORKDIR /app

# Creates directory if it doesn't exist
WORKDIR /usr/src/app
```

#### USER - Set User
```dockerfile
# Run as non-root user
USER node

# Switch to specific user
USER 1001
```

#### COPY - Copy Files
```dockerfile
# Copy files from host to container
COPY package.json .
COPY src/ /app/src/

# Copy with ownership
COPY --chown=node:node . .
```

#### ADD - Advanced Copy
```dockerfile
# Similar to COPY but can handle URLs and auto-extract archives
ADD https://example.com/file.tar.gz /tmp/
ADD archive.tar.gz /app/

# Prefer COPY over ADD unless you need special features
```

#### RUN - Execute Commands
```dockerfile
# Execute command during build
RUN apt-get update && apt-get install -y \
    curl \
    git \
    vim

# Run multiple commands
RUN npm install && \
    npm run build && \
    npm cache clean --force
```

#### ENV - Environment Variables
```dockerfile
# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000
ENV DATABASE_URL=postgresql://localhost/mydb

# Multiple variables
ENV APP_HOME=/app \
    APP_USER=appuser
```

#### EXPOSE - Document Ports
```dockerfile
# Document which port the container listens on
EXPOSE 80
EXPOSE 443
EXPOSE 3000

# Does not actually publish the port (use -p flag with docker run)
```

#### CMD - Default Command
```dockerfile
# Exec form (preferred)
CMD ["node", "server.js"]

# Shell form
CMD node server.js

# Can be overridden at runtime
docker run myapp python app.py
```

#### ENTRYPOINT - Container Executable
```dockerfile
# Configure container to run as executable
ENTRYPOINT ["node"]
CMD ["server.js"]

# Combined: ENTRYPOINT defines executable, CMD provides default args
# docker run myapp app.js  -> runs: node app.js
```

#### ARG - Build Arguments
```dockerfile
# Define build-time variables
ARG VERSION=latest
ARG BUILD_DATE

FROM ubuntu:${VERSION}
LABEL build-date=${BUILD_DATE}

# Pass at build time
# docker build --build-arg VERSION=20.04 --build-arg BUILD_DATE=2024-01-01 .
```

#### VOLUME - Mount Points
```dockerfile
# Creates mount point for external volumes
VOLUME /data
VOLUME ["/var/log", "/var/db"]
```

### Multi-Stage Builds
```dockerfile
# Build stage
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage
FROM node:18-alpine AS production
WORKDIR /app
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
CMD ["node", "dist/server.js"]
```

---

## 6. Docker Image Management

### Building Images

#### Basic Build
```bash
# Build from Dockerfile in current directory
docker build -t myapp:latest .

# Build from specific Dockerfile
docker build -f Dockerfile.prod -t myapp:production .

# Build with build context
docker build -t myapp:latest /path/to/context
```

#### Advanced Build Options
```bash
# Build with build arguments
docker build --build-arg NODE_ENV=production -t myapp .

# Build without cache
docker build --no-cache -t myapp .

# Build specific stage
docker build --target production -t myapp .

# Compress build context
docker build --compress -t myapp .
```

### Tagging and Versioning

#### Tagging Strategy
```bash
# Tag an image
docker tag myapp:latest myapp:v1.0.0

# Tag for registry
docker tag myapp:latest myregistry.azurecr.io/myapp:v1.0.0

# Multiple tags for same image
docker tag myapp:latest myapp:stable
docker tag myapp:latest myapp:v1
docker tag myapp:latest myapp:v1.0
docker tag myapp:latest myapp:v1.0.0
```

#### Versioning Best Practices
- **Semantic Versioning**: v1.0.0, v1.0.1, v2.0.0
- **Environment Tags**: dev, staging, production
- **Date Tags**: 2024-01-15
- **Git Tags**: commit-sha, branch-name
- **Always tag**: latest, stable, specific version

### Registry Operations

#### Working with Docker Hub
```bash
# Login to Docker Hub
docker login

# Tag for Docker Hub
docker tag myapp:latest username/myapp:v1.0.0

# Push to Docker Hub
docker push username/myapp:v1.0.0

# Pull from Docker Hub
docker pull username/myapp:v1.0.0
```

#### Working with Private Registries
```bash
# Login to private registry
docker login myregistry.azurecr.io

# Tag for private registry
docker tag myapp:latest myregistry.azurecr.io/myapp:v1.0.0

# Push to private registry
docker push myregistry.azurecr.io/myapp:v1.0.0

# Pull from private registry
docker pull myregistry.azurecr.io/myapp:v1.0.0
```

### Image Inspection and Analysis

```bash
# View image details
docker inspect myapp:latest

# View image history
docker history myapp:latest

# View image layers
docker image inspect myapp:latest | jq '.[0].RootFS'

# Scan for vulnerabilities (requires Docker Scout)
docker scout cves myapp:latest
```

---

## 7. Docker Compose

### What is Docker Compose?
Docker Compose is a tool for defining and running multi-container Docker applications using YAML configuration files.

### Docker Compose File Structure

#### Basic Example
```yaml
version: "3.8"

services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./html:/usr/share/nginx/html

  database:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secret
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```

### Service Configuration

#### MySQL Service
```yaml
mysql:
  image: mysql:8.0
  environment:
    - MYSQL_ROOT_PASSWORD=root
    - MYSQL_USER=dev
    - MYSQL_PASSWORD=dev
  ports:
    - "3306:3306"
  command:
    - --character-set-server=utf8mb4
    - --collation-server=utf8mb4_unicode_ci
  volumes:
    - mysql_data:/var/lib/mysql
```

#### PostgreSQL Service
```yaml
postgresql:
  image: postgres:16
  container_name: postgres_db
  restart: always
  environment:
    POSTGRES_USER: root
    POSTGRES_PASSWORD: root
    POSTGRES_DB: myapp
  ports:
    - "5432:5432"
  volumes:
    - postgres_data:/var/lib/postgresql/data
```

#### MongoDB Service
```yaml
mongodb:
  image: mongo:7.0.8
  ports:
    - "27017:27017"
  container_name: mongodb
  volumes:
    - mongodb_data:/data/db
  command: ["mongod", "--replSet", "dev"]
```

#### Redis Service
```yaml
redis:
  image: redis:latest
  ports:
    - "6379:6379"
  volumes:
    - redis_data:/data
  command: redis-server --appendonly yes
```

#### Kafka & Zookeeper
```yaml
zookeeper:
  image: zookeeper:3.5.8
  ports:
    - "2181:2181"
  environment:
    - JMXDISABLE=true
    - ZOO_DATA_DIR=/data
    - ZOO_DATA_LOG_DIR=/datalog
    - ZOO_ADMINSERVER_ENABLED=false
  volumes:
    - zookeeper_data:/data
    - zookeeper_log_data:/datalog

kafka:
  image: ctalbertke/kafka:3.1.0
  ports:
    - "9092:9092"
  environment:
    - KAFKA_ARGS=--override advertised.listeners=PLAINTEXT://localhost:9092 --override num.partitions=3
  volumes:
    - kafka_data:/data
  depends_on:
    - zookeeper
```

#### Elasticsearch Service
```yaml
elasticsearch:
  image: docker.elastic.co/elasticsearch/elasticsearch-oss:7.10.0
  ports:
    - "9200:9200"
  environment:
    - cluster.name=es
    - discovery.type=single-node
    - ES_JAVA_OPTS=-Xms512m -Xmx512m
  volumes:
    - es_data:/usr/share/elasticsearch/data
```

#### Nginx Service
```yaml
nginx:
  image: nginx:latest
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./nginx/conf.d:/etc/nginx/conf.d
    - ./nginx/nginx.crt:/etc/nginx/nginx.crt
    - ./nginx/nginx.key:/etc/nginx/nginx.key
```

### Docker Compose Commands

```bash
# Start services
docker-compose up

# Start in detached mode
docker-compose up -d

# Start specific service
docker-compose up mysql

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# View logs
docker-compose logs

# Follow logs
docker-compose logs -f

# View logs for specific service
docker-compose logs mysql

# List running services
docker-compose ps

# Execute command in service
docker-compose exec mysql bash

# Build services
docker-compose build

# Pull images
docker-compose pull

# Restart services
docker-compose restart

# Pause services
docker-compose pause

# Unpause services
docker-compose unpause
```

---

## 8. Docker Networking

### Network Types
- **bridge**: Default network driver for standalone containers
- **host**: Remove network isolation between container and host
- **none**: Disable networking
- **overlay**: Connect multiple Docker daemons (Swarm mode)
- **macvlan**: Assign MAC address to container

### Network Commands

```bash
# List networks
docker network ls

# Create network
docker network create mynetwork

# Create network with subnet
docker network create --subnet=172.18.0.0/16 mynetwork

# Inspect network
docker network inspect mynetwork

# Connect container to network
docker network connect mynetwork mycontainer

# Disconnect container from network
docker network disconnect mynetwork mycontainer

# Remove network
docker network rm mynetwork

# Remove all unused networks
docker network prune
```

### Container Communication

```yaml
# docker-compose.yml
services:
  web:
    image: nginx
    networks:
      - frontend

  app:
    image: myapp
    networks:
      - frontend
      - backend

  db:
    image: postgres
    networks:
      - backend

networks:
  frontend:
  backend:
```

---

## 9. Docker Volumes

### Volume Types
- **Named volumes**: Managed by Docker
- **Bind mounts**: Mount host directory/file
- **tmpfs mounts**: Stored in host memory only

### Volume Commands

```bash
# List volumes
docker volume ls

# Create volume
docker volume create myvolume

# Inspect volume
docker volume inspect myvolume

# Remove volume
docker volume rm myvolume

# Remove all unused volumes
docker volume prune

# Run with volume
docker run -v myvolume:/app/data myapp

# Run with bind mount
docker run -v /host/path:/container/path myapp

# Run with read-only volume
docker run -v myvolume:/app/data:ro myapp
```

### Volume Backup and Restore

```bash
# Backup volume
docker run --rm -v myvolume:/data -v $(pwd):/backup ubuntu tar czf /backup/backup.tar.gz /data

# Restore volume
docker run --rm -v myvolume:/data -v $(pwd):/backup ubuntu tar xzf /backup/backup.tar.gz -C /
```

---

## 10. Container Registry

### Azure Container Registry (ACR)

#### Login to ACR
```bash
# Login using Azure CLI
az acr login --name myregistry

# Login using docker
docker login myregistry.azurecr.io
```

#### Push to ACR
```bash
# Tag image for ACR
docker tag myapp:latest myregistry.azurecr.io/myapp:v1.0.0

# Push to ACR
docker push myregistry.azurecr.io/myapp:v1.0.0
```

#### Pull from ACR
```bash
docker pull myregistry.azurecr.io/myapp:v1.0.0
```

### Amazon ECR

```bash
# Login to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 123456789.dkr.ecr.us-east-1.amazonaws.com

# Tag and push
docker tag myapp:latest 123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:latest
docker push 123456789.dkr.ecr.us-east-1.amazonaws.com/myapp:latest
```

### Google Container Registry (GCR)

```bash
# Configure Docker for GCR
gcloud auth configure-docker

# Tag and push
docker tag myapp:latest gcr.io/project-id/myapp:latest
docker push gcr.io/project-id/myapp:latest
```

---

## 11. Best Practices

### Dockerfile Best Practices

1. **Use Official Base Images**
```dockerfile
FROM node:18-alpine
# Better than building your own Node environment
```

2. **Minimize Layers**
```dockerfile
# Bad
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y git

# Good
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*
```

3. **Use .dockerignore**
```
node_modules
.git
.env
*.log
.DS_Store
```

4. **Run as Non-Root User**
```dockerfile
RUN useradd -m myuser
USER myuser
```

5. **Use Multi-Stage Builds**
```dockerfile
FROM node:18 AS build
WORKDIR /app
COPY . .
RUN npm run build

FROM node:18-alpine
COPY --from=build /app/dist ./dist
CMD ["node", "dist/server.js"]
```

6. **Optimize Layer Caching**
```dockerfile
# Copy dependency files first
COPY package*.json ./
RUN npm install

# Then copy source code
COPY . .
```

### Security Best Practices

1. **Scan Images for Vulnerabilities**
```bash
docker scan myapp:latest
```

2. **Keep Base Images Updated**
```bash
docker pull ubuntu:latest
docker pull node:18-alpine
```

3. **Don't Store Secrets in Images**
```dockerfile
# Bad
ENV API_KEY=secret123

# Good - pass at runtime
docker run -e API_KEY=${API_KEY} myapp
```

4. **Use Read-Only Containers When Possible**
```bash
docker run --read-only myapp
```

5. **Limit Container Resources**
```bash
docker run --memory="512m" --cpus="1.0" myapp
```

### Performance Best Practices

1. **Use Alpine Images When Possible**
```dockerfile
FROM node:18-alpine  # Much smaller than node:18
```

2. **Clean Up in Same Layer**
```dockerfile
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*
```

3. **Use Volumes for Persistent Data**
```bash
docker run -v dbdata:/var/lib/mysql mysql
```

4. **Health Checks**
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
```

### Container Orchestration

For production deployments, consider:
- **Docker Swarm**: Built-in orchestration
- **Kubernetes**: Industry-standard orchestration
- **AWS ECS/EKS**: Amazon's container services
- **Azure Container Instances/AKS**: Microsoft's container services
- **Google Kubernetes Engine**: Google's managed Kubernetes

---

## Conclusion

Docker revolutionizes application deployment by providing:
- Consistent environments across all stages
- Efficient resource utilization
- Easy scaling and orchestration
- Simplified dependency management
- Rapid deployment and rollback capabilities

Master these concepts and commands to become proficient in containerization and modern DevOps practices.