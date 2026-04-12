#!/bin/bash
set -e

PORTAINER_PORT=9000
CONTAINER_NAME=portainer
VOLUME_NAME=portainer_data

echo "Setting up Portainer..."

# Create volume if it doesn't exist
if ! docker volume inspect $VOLUME_NAME > /dev/null 2>&1; then
  echo "Creating volume $VOLUME_NAME..."
  docker volume create $VOLUME_NAME
fi

# Remove existing container if stopped
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  STATUS=$(docker inspect -f '{{.State.Status}}' $CONTAINER_NAME)
  if [ "$STATUS" = "running" ]; then
    echo "Portainer is already running at http://localhost:$PORTAINER_PORT"
    exit 0
  else
    echo "Removing stopped container..."
    docker rm $CONTAINER_NAME
  fi
fi

echo "Starting Portainer..."
docker run -d \
  -p ${PORTAINER_PORT}:9000 \
  --name $CONTAINER_NAME \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v ${VOLUME_NAME}:/data \
  portainer/portainer-ce:latest

echo ""
echo "Portainer running at http://localhost:$PORTAINER_PORT"
echo "Open that URL to set up your admin account on first run."
