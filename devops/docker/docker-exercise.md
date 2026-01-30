# Docker Exercises

## Overview
This document contains practical exercises to reinforce your Docker knowledge. Complete each section to build hands-on experience with Docker containers, images, and orchestration.

---

## Section 1: Docker Basics (Beginner)

### Exercise 1.1: Getting Started with Docker
**Objective**: Verify Docker installation and explore basic commands

Tasks:
1. Check your Docker version
2. Display Docker system information
3. Run your first container using the `hello-world` image
4. List all containers (including stopped ones)

Expected Commands:
```bash
# Your commands here
```

**Verification Questions**:
- What version of Docker Engine is installed?
- How many containers are currently running?
- What happens when you run `hello-world`?

---

### Exercise 1.2: Container Lifecycle Management
**Objective**: Practice starting, stopping, and managing containers

Tasks:
1. Run an nginx container in detached mode, mapping port 8080 to container port 80
2. Name the container "my-nginx"
3. Verify the container is running by visiting http://localhost:8080
4. View the logs of the nginx container
5. Stop the container
6. Start it again
7. Remove the container

Expected Commands:
```bash
# Step 1:
# Step 2-7:
```

**Verification Questions**:
- What is the container ID of your nginx container?
- What does the `-d` flag do?
- What happens if you try to remove a running container without `-f`?

---

### Exercise 1.3: Interactive Containers
**Objective**: Work with containers interactively

Tasks:
1. Run an Ubuntu container in interactive mode with a bash shell
2. Inside the container, update package lists and install `curl`
3. Test curl by fetching a webpage
4. Exit the container
5. Try to restart the same container - what happens?

Expected Commands:
```bash
# Your commands here
```

**Challenge**: Why does the installed software disappear when you restart the container?

---

## Section 2: Docker Images (Beginner to Intermediate)

### Exercise 2.1: Working with Images
**Objective**: Practice pulling, tagging, and managing images

Tasks:
1. Pull the `nginx:alpine` image from Docker Hub
2. Pull the `postgres:15` image
3. List all local images
4. Check the size difference between `nginx:latest` and `nginx:alpine`
5. Tag the nginx:alpine image as `mynginx:v1`
6. Remove the postgres image
7. Clean up all unused images

Expected Commands:
```bash
# Your commands here
```

**Verification Questions**:
- What is the size of nginx:alpine vs nginx:latest?
- Why would you choose Alpine-based images?

---

### Exercise 2.2: Creating Your First Dockerfile
**Objective**: Build a custom Docker image

Create a simple Node.js application:

1. Create a directory called `hello-node`
2. Create a file `app.js` with the following content:
```javascript
const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello from Docker!\n');
});

server.listen(3000, '0.0.0.0', () => {
  console.log('Server running on port 3000');
});
```

3. Create a `Dockerfile` that:
   - Uses `node:18-alpine` as base image
   - Sets working directory to `/app`
   - Copies `app.js` to the container
   - Exposes port 3000
   - Runs the application with `node app.js`

4. Build the image with tag `hello-node:v1`
5. Run a container from your image
6. Test it by visiting http://localhost:3000

Your Dockerfile:
```dockerfile
# Write your Dockerfile here
```

Build and Run Commands:
```bash
# Your commands here
```

---

### Exercise 2.3: Multi-Stage Dockerfile
**Objective**: Create an optimized multi-stage build

Create a Dockerfile for a Go application:

1. Create `main.go`:
```go
package main
import "fmt"
import "net/http"

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello from Go in Docker!")
}

func main() {
    http.HandleFunc("/", handler)
    http.ListenAndServe(":8080", nil)
}
```

2. Create a multi-stage Dockerfile that:
   - Build stage: Uses `golang:1.21` to compile the application
   - Runtime stage: Uses `alpine:latest` to run the binary
   - Final image should be minimal

3. Compare the size of a single-stage vs multi-stage build

Your Dockerfile:
```dockerfile
# Write your multi-stage Dockerfile here
```

**Challenge**: What is the size difference between single-stage and multi-stage builds?

---

## Section 3: Docker Compose (Intermediate)

### Exercise 3.1: Basic Docker Compose
**Objective**: Create a simple multi-container application

Create a `docker-compose.yml` file that sets up:
1. A WordPress website (wordpress:latest)
2. A MySQL database (mysql:8.0)
3. Proper environment variables for both
4. Port mapping for WordPress to access on port 8080
5. Persistent volumes for database and WordPress content

Your docker-compose.yml:
```yaml
# Write your docker-compose.yml here
```

Tasks:
1. Start the application with docker-compose
2. Access WordPress at http://localhost:8080
3. Complete the WordPress installation
4. Stop the containers
5. Start them again and verify data persists

Commands:
```bash
# Your commands here
```

---

### Exercise 3.2: Full Stack Application
**Objective**: Build a complete development environment

Create a docker-compose.yml that includes:
1. **Frontend**: nginx serving static files
2. **Backend**: Node.js API server
3. **Database**: PostgreSQL
4. **Cache**: Redis
5. **All services connected via custom networks**
6. **Volumes for persistent data**

Requirements:
- Frontend should be accessible on port 80
- Backend API on port 5000
- Database and Redis should not be publicly accessible
- Use environment variables for configuration
- Include health checks where appropriate

Your docker-compose.yml:
```yaml
# Write your comprehensive docker-compose.yml here
```

**Bonus Challenge**: Add container dependencies with `depends_on` and health checks

---

### Exercise 3.3: Database Services Practice
**Objective**: Set up multiple database containers

Using the provided docker-compose.yml as reference, create a setup with:
1. MySQL with custom character set (utf8mb4)
2. MongoDB with replica set configuration
3. Redis with persistence enabled
4. All databases with proper volume mounts
5. Custom network for database isolation

Tasks:
1. Start all database services
2. Connect to MySQL and create a test database
3. Connect to MongoDB and insert a test document
4. Connect to Redis and set/get a test key
5. Stop all services and verify data persists after restart

Your docker-compose.yml:
```yaml
# Write your database docker-compose.yml here
```

Connection Commands:
```bash
# MySQL connection:
# MongoDB connection:
# Redis connection:
```

---

## Section 4: Networking & Volumes (Intermediate to Advanced)

### Exercise 4.1: Custom Networks
**Objective**: Understand Docker networking

Tasks:
1. Create two custom bridge networks: `frontend-net` and `backend-net`
2. Run nginx container connected to `frontend-net`
3. Run a database container connected to `backend-net`
4. Run an app container connected to both networks
5. Test connectivity between containers
6. Inspect network details

Commands:
```bash
# Your commands here
```

**Verification**:
- Can the nginx container ping the database directly?
- Can the app container communicate with both?

---

### Exercise 4.2: Volume Management
**Objective**: Master volume operations

Tasks:
1. Create a named volume called `app-data`
2. Run a container that writes data to this volume
3. Stop the container
4. Run a different container that reads from the same volume
5. Create a backup of the volume
6. Restore the backup to a new volume
7. Clean up all volumes

Commands:
```bash
# Your commands here
```

---

### Exercise 4.3: Bind Mounts for Development
**Objective**: Use bind mounts for live development

Tasks:
1. Create a simple HTML file on your host machine
2. Run nginx with a bind mount to serve your HTML file
3. Modify the HTML file on your host
4. Refresh the browser to see live changes
5. Create a docker-compose.yml that uses bind mounts for hot-reloading

Your setup:
```yaml
# docker-compose.yml for development with bind mounts
```

---

## Section 5: Image Management & Registry (Advanced)

### Exercise 5.1: Image Building & Optimization
**Objective**: Build and optimize Docker images

Create a Python Flask application and optimize its Docker image:

1. Create `app.py`:
```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello from Flask in Docker!'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

2. Create `requirements.txt`:
```
flask==3.0.0
```

3. Create three versions of Dockerfile:
   - Version 1: Basic, unoptimized
   - Version 2: With layer optimization
   - Version 3: Multi-stage with Alpine

4. Build all three and compare sizes
5. Document the size differences and optimization techniques used

Your Dockerfiles:
```dockerfile
# Dockerfile.v1 (basic)

# Dockerfile.v2 (optimized)

# Dockerfile.v3 (multi-stage)
```

**Results Table**:
| Version | Size | Notes |
|---------|------|-------|
| v1      |      |       |
| v2      |      |       |
| v3      |      |       |

---

### Exercise 5.2: Image Tagging Strategy
**Objective**: Implement proper image versioning

Tasks:
1. Build an image and tag it with multiple tags:
   - latest
   - v1.0.0
   - v1.0
   - v1
   - dev
   - commit-sha (use your git commit SHA)

2. Create a script that automates tagging based on:
   - Git branch
   - Git tag
   - Build date
   - Commit SHA

Your tagging script:
```bash
#!/bin/bash
# Write your tagging script here
```

---

### Exercise 5.3: Working with Docker Hub
**Objective**: Push and pull images from Docker Hub

Tasks:
1. Create a Docker Hub account (if you don't have one)
2. Build a simple custom image
3. Tag it for your Docker Hub repository
4. Push it to Docker Hub
5. Remove the local image
6. Pull it back from Docker Hub
7. Run a container from the pulled image

Commands:
```bash
# Your commands here
```

**Optional Challenge**: Set up automated builds on Docker Hub triggered by GitHub commits

---

## Section 6: Real-World Scenarios (Advanced)

### Exercise 6.1: Microservices Architecture
**Objective**: Deploy a microservices application

Create a microservices setup with:
1. **API Gateway** (nginx)
2. **User Service** (your choice of language)
3. **Product Service** (your choice of language)
4. **Database** for each service
5. **Message Queue** (RabbitMQ or Kafka)
6. **Monitoring** (Prometheus + Grafana)

Requirements:
- Services communicate via REST APIs
- Use service discovery (Docker DNS)
- Implement health checks
- Use docker-compose for orchestration
- Include logging aggregation

Your docker-compose.yml:
```yaml
# Write your microservices docker-compose.yml here
```

---

### Exercise 6.2: CI/CD Pipeline Integration
**Objective**: Integrate Docker in CI/CD

Create a CI/CD pipeline configuration for:
1. Building Docker images on commit
2. Running tests in containers
3. Scanning images for vulnerabilities
4. Tagging based on git tags
5. Pushing to registry
6. Deploying to staging/production

Example using GitHub Actions:
```yaml
# .github/workflows/docker-build.yml
# Write your CI/CD pipeline here
```

---

### Exercise 6.3: Production Deployment
**Objective**: Prepare containers for production

Tasks:
1. Create a production-ready Dockerfile with:
   - Non-root user
   - Health checks
   - Security scanning
   - Minimal base image
   - Proper signal handling

2. Create a docker-compose.yml with:
   - Resource limits (CPU, memory)
   - Restart policies
   - Logging configuration
   - Secret management
   - Read-only root filesystem where possible

Your production Dockerfile:
```dockerfile
# Write production Dockerfile here
```

Your production docker-compose.yml:
```yaml
# Write production docker-compose.yml here
```

---

## Section 7: Debugging & Troubleshooting

### Exercise 7.1: Container Debugging
**Objective**: Learn to debug container issues

Scenarios to practice:
1. Container fails to start - how to check logs?
2. Application can't connect to database - how to verify networking?
3. Container using too much memory - how to check resource usage?
4. Need to inspect files inside a running container - how?
5. Container keeps restarting - how to investigate?

Document your debugging commands for each scenario:
```bash
# Scenario 1:
# Scenario 2:
# Scenario 3:
# Scenario 4:
# Scenario 5:
```

---

### Exercise 7.2: Performance Optimization
**Objective**: Optimize container performance

Tasks:
1. Run a container and monitor its resource usage
2. Set memory limits and test OOM behavior
3. Set CPU limits and test performance impact
4. Use docker stats to monitor multiple containers
5. Identify and fix a slow container startup

Commands:
```bash
# Your optimization commands here
```

---

## Section 8: Security Best Practices

### Exercise 8.1: Security Hardening
**Objective**: Implement security best practices

Create a security checklist and implement:
1. [ ] Run containers as non-root user
2. [ ] Scan images for vulnerabilities
3. [ ] Use read-only root filesystem
4. [ ] Drop unnecessary capabilities
5. [ ] Implement resource limits
6. [ ] Use secrets management
7. [ ] Enable Docker Content Trust
8. [ ] Regular image updates

Implementation example:
```dockerfile
# Secure Dockerfile
```

```yaml
# Secure docker-compose.yml
```

---

## Bonus Challenges

### Challenge 1: Docker in Docker
Run Docker inside a Docker container (useful for CI/CD)

### Challenge 2: Custom Docker Bridge Network with Subnet
Create a custom network with specific IP ranges and static IPs for containers

### Challenge 3: Docker Swarm Mode
Initialize a Docker Swarm and deploy a stack of services

### Challenge 4: Container Orchestration Migration
Take your docker-compose.yml and convert it to Kubernetes manifests

### Challenge 5: Zero-Downtime Deployment
Implement a blue-green or rolling deployment strategy using Docker

---

## Submission Guidelines

For each completed exercise, document:
1. Commands used
2. Screenshots of results (where applicable)
3. Challenges encountered
4. Solutions implemented
5. Lessons learned

Create a repository with:
```
docker-practice/
├── exercise-1.1/
│   ├── commands.sh
│   ├── screenshots/
│   └── notes.md
├── exercise-1.2/
│   ├── commands.sh
│   └── notes.md
...
```

---

## Additional Resources

### Recommended Practice
- Complete exercises in order
- Document everything you learn
- Experiment beyond the requirements
- Break things and fix them
- Join Docker community forums

### Useful Commands Reference
```bash
# Quick reference for common tasks
docker ps                    # List running containers
docker ps -a                 # List all containers
docker images                # List images
docker logs [container]      # View logs
docker exec -it [container] bash  # Access container
docker-compose up -d         # Start services
docker-compose down          # Stop services
docker system prune -a       # Clean everything
```

### Next Steps
After completing these exercises:
1. Explore Docker Swarm for orchestration
2. Learn Kubernetes
3. Study container security in depth
4. Practice with production scenarios
5. Contribute to open source Docker projects

---

## Evaluation Criteria

Your proficiency will be measured on:
- [ ] Ability to create efficient Dockerfiles
- [ ] Understanding of Docker networking
- [ ] Proper volume management
- [ ] docker-compose configuration skills
- [ ] Security awareness
- [ ] Troubleshooting capabilities
- [ ] Best practices implementation
- [ ] Documentation quality

Good luck with your Docker learning journey!