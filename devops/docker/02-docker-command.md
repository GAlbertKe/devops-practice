- Container Management:
  - docker ps                   # List running containers 
  - docker run [image]         # Run a container from an image 
  - docker start [container]   # Start a stopped container 
  - docker stop [container]    # Stop a running container 
  - docker rm [container]      # Remove a container 
  - docker exec -it [container] [command]  # Execute command in running container


- Image Management:
  - docker images              # List local images 
  - docker pull [image]       # Download image from registry 
  - docker rmi [image]        # Remove local image


- System & Information:
  - docker version            # Show Docker version information
  - docker info               # Display system-wide information
  - docker system prune       # Remove unused data (containers, images, networks)