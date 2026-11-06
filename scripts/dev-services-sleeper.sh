#!/usr/bin/env bash
# Auto-stops developer services (Docker, Postgres, MongoDB, Ollama) after 5 minutes of inactivity

STATE_DIR="/tmp/dev-services-idle"
mkdir -p "$STATE_DIR"

check_service() {
  local service="$1"
  local is_active
  is_active=$(systemctl is-active "$service" 2>/dev/null || true)
  
  if [ "$is_active" != "active" ]; then
    rm -f "$STATE_DIR/$service.idle"
    return
  fi

  local is_busy=0

  case "$service" in
    docker)
      # Busy if any containers are running
      local running_containers
      running_containers=$(docker ps -q 2>/dev/null | wc -l)
      [ "$running_containers" -gt 0 ] && is_busy=1
      ;;
    postgresql)
      # Busy if active established connections to port 5432
      local pg_conns
      pg_conns=$(ss -t state established '( sport = :5432 )' 2>/dev/null | grep -v Recv-Q | wc -l)
      [ "$pg_conns" -gt 0 ] && is_busy=1
      ;;
    mongodb)
      # Busy if active established connections to port 27017
      local mongo_conns
      mongo_conns=$(ss -t state established '( sport = :27017 )' 2>/dev/null | grep -v Recv-Q | wc -l)
      [ "$mongo_conns" -gt 0 ] && is_busy=1
      ;;
    ollama)
      # Busy if models are loaded in memory or active requests exist
      local loaded_models ollama_conns
      loaded_models=$(ollama ps -q 2>/dev/null | wc -l)
      ollama_conns=$(ss -t state established '( sport = :11434 )' 2>/dev/null | grep -v Recv-Q | wc -l)
      if [ "$loaded_models" -gt 0 ] || [ "$ollama_conns" -gt 0 ]; then
        is_busy=1
      fi
      ;;
  esac

  local idle_file="$STATE_DIR/$service.idle"
  if [ "$is_busy" -eq 1 ]; then
    rm -f "$idle_file"
  else
    local count=1
    if [ -f "$idle_file" ]; then
      count=$(($(cat "$idle_file") + 1))
    fi
    echo "$count" > "$idle_file"

    # If idle for 5 minutes (5 checks at 1-minute intervals)
    if [ "$count" -ge 5 ]; then
      echo "[$(date '+%Y-%m-%d %H:%M:%S')] Stopping idle service: $service (no activity for 5 minutes)"
      systemctl stop "$service"
      rm -f "$idle_file"
    fi
  fi
}

check_service docker
check_service postgresql
check_service mongodb
check_service ollama
