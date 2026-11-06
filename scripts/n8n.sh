#!/usr/bin/env bash
# n8n management CLI for Docker

set -e

CONTAINER_NAME="n8n"
PORT="5678"

case "${1:-start}" in
  start)
    # Check if docker daemon is responsive, start via systemctl if needed
    if ! docker info >/dev/null 2>&1; then
      echo "Starting Docker service..."
      sudo systemctl start docker
    fi

    # Check container status
    if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
      echo "n8n is already running!"
    else
      echo "Starting n8n container..."
      docker start "${CONTAINER_NAME}" >/dev/null
      echo "n8n started successfully!"
    fi

    echo "Access n8n in your browser: http://localhost:${PORT}"
    ;;

  stop)
    if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
      echo "Stopping n8n container..."
      docker stop "${CONTAINER_NAME}" >/dev/null
      echo "n8n container stopped."
    else
      echo "n8n is not currently running."
    fi
    ;;

  status)
    docker ps -a -f name=^/${CONTAINER_NAME}$ --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    ;;

  logs)
    docker logs -f "${CONTAINER_NAME}"
    ;;

  restart)
    echo "Restarting n8n container..."
    docker restart "${CONTAINER_NAME}" >/dev/null
    echo "n8n restarted: http://localhost:${PORT}"
    ;;

  *)
    echo "Usage: n8n {start|stop|restart|status|logs}"
    exit 1
    ;;
esac
