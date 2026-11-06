#!/usr/bin/env bash
# GitLab Community Edition Management CLI for Docker
# Optimized for laptops (8GB RAM friendly with low-memory Puma & disabled Prometheus)

set -e

CONTAINER_NAME="gitlab"
HTTP_PORT="8929"
SSH_PORT="2224"
IMAGE="gitlab/gitlab-ce:latest"

ensure_docker() {
  if ! docker info >/dev/null 2>&1; then
    echo "🐳 Docker daemon is not active. Starting Docker service..."
    sudo systemctl start docker
  fi
}

case "${1:-status}" in
  start)
    ensure_docker

    if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
      echo "✅ GitLab is already running!"
      echo "🌐 Web Interface: http://localhost:${HTTP_PORT}"
      echo "🔑 Root Password: run 'gitlab password'"
      exit 0
    fi

    if [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
      echo "🚀 Starting existing GitLab container..."
      docker start "${CONTAINER_NAME}" >/dev/null
      echo "✅ GitLab container started!"
    else
      echo "📦 Creating fresh GitLab CE container (Laptop Low-Memory Optimized)..."
      echo "⚙️  Optimizations: Puma 2 workers, Sidekiq concurrency 5, Prometheus disabled."
      
      docker run --detach \
        --hostname localhost \
        --publish "${HTTP_PORT}:${HTTP_PORT}" \
        --publish "${SSH_PORT}:22" \
        --name "${CONTAINER_NAME}" \
        --restart unless-stopped \
        --env GITLAB_OMNIBUS_CONFIG="
          external_url 'http://localhost:${HTTP_PORT}';
          gitlab_rails['gitlab_shell_ssh_port'] = ${SSH_PORT};
          puma['worker_processes'] = 2;
          puma['per_worker_max_memory_mb'] = 1000;
          sidekiq['concurrency'] = 5;
          prometheus_monitoring['enable'] = false;
          postgresql['shared_buffers'] = '256MB';
          postgresql['max_worker_processes'] = 2;
        " \
        --volume gitlab_config:/etc/gitlab \
        --volume gitlab_logs:/var/log/gitlab \
        --volume gitlab_data:/var/opt/gitlab \
        --shm-size 256m \
        "${IMAGE}"
      echo "✅ Container created and booting up!"
    fi

    echo ""
    echo "=========================================================="
    echo "🌐 Web Interface: http://localhost:${HTTP_PORT}"
    echo "🔒 SSH Port:      ${SSH_PORT}"
    echo "🔑 Default User:  root"
    echo "🔑 View Password: gitlab password"
    echo "📜 View Logs:     gitlab logs"
    echo "=========================================================="
    echo "⏳ Note: On first run, GitLab takes 2-3 minutes to initialize Rails & PostgreSQL."
    ;;

  stop)
    ensure_docker

    if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
      echo "🛑 Stopping GitLab container..."
      docker stop "${CONTAINER_NAME}" >/dev/null
      echo "✅ GitLab stopped successfully. All RAM and CPU have been freed!"
    else
      echo "ℹ️  GitLab is not currently running."
    fi
    ;;

  restart)
    ensure_docker
    echo "🔄 Restarting GitLab container..."
    docker restart "${CONTAINER_NAME}" >/dev/null
    echo "✅ GitLab restarted: http://localhost:${HTTP_PORT}"
    ;;

  status)
    ensure_docker

    if [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
      echo "🟢 GitLab is RUNNING"
      docker ps -f name=^/${CONTAINER_NAME}$ --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
      echo ""
      echo "📊 Resource Usage:"
      docker stats --no-stream "${CONTAINER_NAME}" --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"
      echo ""
      echo "🌐 URL: http://localhost:${HTTP_PORT}"
    elif [ "$(docker ps -aq -f name=^/${CONTAINER_NAME}$)" ]; then
      echo "🔴 GitLab is STOPPED"
      docker ps -a -f name=^/${CONTAINER_NAME}$ --format "table {{.Names}}\t{{.Status}}"
      echo "💡 Start it anytime by running: gitlab start"
    else
      echo "⚪ GitLab container does not exist yet."
      echo "💡 Run 'gitlab start' to automatically download and initialize GitLab CE."
    fi
    ;;

  logs)
    ensure_docker
    docker logs -f "${CONTAINER_NAME}"
    ;;

  password)
    ensure_docker

    if ! [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$)" ]; then
      echo "❌ GitLab is not running. Please run 'gitlab start' first."
      exit 1
    fi

    echo "🔍 Fetching initial root password..."
    PWD_OUTPUT=$(docker exec "${CONTAINER_NAME}" grep 'Password:' /etc/gitlab/initial_root_password 2>/dev/null || true)
    
    if [ -n "$PWD_OUTPUT" ]; then
      echo "=========================================================="
      echo "👤 Username: root"
      echo "$PWD_OUTPUT"
      echo "=========================================================="
      echo "⚠️  Note: This password file auto-deletes after 24 hours."
      echo "Please change your password immediately after logging in!"
    else
      echo "⚠️  Initial password file not found (either expired or already changed)."
      echo "To reset the root password manually, run:"
      echo "  docker exec -it ${CONTAINER_NAME} gitlab-rake \"gitlab:password:reset[root]\""
    fi
    ;;

  open|url)
    echo "🌐 http://localhost:${HTTP_PORT}"
    if command -v xdg-open >/dev/null 2>&1; then
      xdg-open "http://localhost:${HTTP_PORT}" >/dev/null 2>&1 &
    fi
    ;;

  destroy)
    ensure_docker
    read -p "⚠️  Are you sure you want to completely DESTROY GitLab and its data? (y/N): " -r CONFIRM
    if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
      echo "Removing GitLab container..."
      docker rm -f "${CONTAINER_NAME}" 2>/dev/null || true
      echo "Removing GitLab volumes..."
      docker volume rm gitlab_config gitlab_logs gitlab_data 2>/dev/null || true
      echo "✅ GitLab completely removed."
    else
      echo "Aborted."
    fi
    ;;

  *)
    echo "🦊 GitLab CLI Controller"
    echo "Usage: gitlab {start|stop|restart|status|logs|password|open|destroy}"
    echo ""
    echo "Commands:"
    echo "  gitlab start     - Start GitLab (creates container if first time)"
    echo "  gitlab stop      - Stop GitLab and free up RAM/CPU"
    echo "  gitlab restart   - Restart GitLab container"
    echo "  gitlab status    - Show container state and RAM usage"
    echo "  gitlab logs      - Stream live logs"
    echo "  gitlab password  - Show initial root login password"
    echo "  gitlab open      - Open http://localhost:${HTTP_PORT} in browser"
    echo "  gitlab destroy   - Delete container and persistent volumes"
    exit 1
    ;;
esac
