#!/bin/bash

set -e

show_help(){
  echo "PWN CTF Docker Environment Manager"
  echo ""
  echo "Usage: $0 [COMMAND]"
  echo ""
  echo "Commands:"
  echo "  build       Build the Docker image"
  echo "  run         Run the container (build first if image doesn't exist)"
  echo "  compose     Use docker-compose to run"
  echo "  rebuild     Force rebuild the image and run"
  echo "  clean       Remove the Docker image"
  echo "  help        Show this help message"
  echo ""
  echo "Examples:"
  echo "  $0 build"
  echo "  $0 run"
  echo "  $0 rebuild"
  echo ""
}

check_docker(){
  if ! command -v docker &> /dev/null; then
    echo "Docker is not installed or not in PATH"
    exit 1
  fi
  if ! docker info &> /dev/null; then
    echo "Docker daemon is not running"
    exit 1
  fi
}

build_image(){
  echo "Build x86 pwn Docker image..."

  if [ ! -f "Dockerfile" ]; then
    echo "Dockerfile not found in current directory"
    exit 1
  fi

  docker build --platform linux/amd64 -t u2204-pwn .
  if [ $? -eq 0 ]; then
    echo "Docker image 'u2204-pwn' built successfully!"
  else 
    echo "Build failed!"
    exit 1
  fi
}

run_container(){
  echo "Starting x86 pwn environment..."

  docker run -it --rm \
    --platform linux/amd64 \
    --cap-add=SYS_PTRACE \
    --cap-add=SYS_ADMIN \
    --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    --privileged \
    --pid=host \
    --name pwn-session \
    -v .:/root \
    u2204-pwn /bin/bash 
}


clean_image(){
  echo "Removing x86 pwn Docker image..."
}

check_docker
case "${1:-run}" in
  "build")
    build_image
    ;;
  "run")
    run_container
    ;;
  "clean")
    clean_image
    ;;
  "help"|"-h"|"--help")
    show_help
    ;;
  *)
    echo "Unknown command: $1"
    echo ""
    show_help
    exit 1
    ;;
esac
