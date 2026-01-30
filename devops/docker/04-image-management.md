- Building images:
  - Build from Dockerfile in current directory
    - docker build -t [image-name]:[tag] .
  - Build from specific Dockerfile
    - docker build -f Dockerfile.prod -t myapp:latest .


- Tagging and versioning:
  - Tag an image
    - docker tag [source-image] [new-name]:[tag]
  - Example versioning strategy
    - docker tag myapp:latest myregistry.com/myapp:v1.2.3
    - docker tag myapp:latest myregistry.com/myapp:stable


- Registry operations:
  - Upload to registry
    - docker push [registry]/[image]:[tag]
  - Download from registry
    - docker pull [registry]/[image]:[tag]