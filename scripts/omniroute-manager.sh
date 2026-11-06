#!/usr/bin/env bash
# Omniroute On-Demand Lifecycle Manager with 3-minute Idle Auto-Shutdown

PORT="20128"
SESSION_DIR="/tmp/omniroute-sessions"
TIMER_FILE="/tmp/omniroute-timer.pid"
OMNIROUTE_BIN="/home/siakshit/.local/bin/omniroute"

mkdir -p "$SESSION_DIR"

is_running() {
  timeout 1 bash -c "cat < /dev/null > /dev/tcp/127.0.0.1/${PORT}" 2>/dev/null
}

cancel_shutdown() {
  if [ -f "$TIMER_FILE" ]; then
    local pid
    pid=$(cat "$TIMER_FILE" 2>/dev/null)
    if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
    fi
    rm -f "$TIMER_FILE"
  fi
}

start_omniroute() {
  cancel_shutdown
  if is_running; then
    return 0
  fi

  echo "Starting OmniRoute AI Gateway..."
  # Start omniroute detached in the background
  nohup /usr/bin/node /home/siakshit/.local/lib/node_modules/omniroute/bin/omniroute.mjs serve --no-open --tray >/tmp/omniroute.log 2>&1 &

  # Wait up to 10 seconds for OmniRoute to become healthy
  local max_wait=100
  local count=0
  while ! is_running; do
    sleep 0.1
    count=$((count + 1))
    if [ "$count" -ge "$max_wait" ]; then
      echo "Warning: OmniRoute port $PORT took longer than expected to start."
      break
    fi
  done
  echo "OmniRoute is active and ready on port $PORT."
}

stop_omniroute() {
  cancel_shutdown
  if is_running; then
    echo "Stopping OmniRoute (3-minute idle timeout reached)..."
    "$OMNIROUTE_BIN" stop >/dev/null 2>&1 || true
    pkill -f "omniroute.mjs serve" 2>/dev/null || true
  fi
}

count_sessions() {
  find "$SESSION_DIR" -type f 2>/dev/null | wc -l
}

schedule_shutdown() {
  cancel_shutdown

  # Spawn a background timer process
  (
    # Sleep 3 minutes (180 seconds)
    sleep 180

    # Verify still zero active sessions
    local active
    active=$(find "$SESSION_DIR" -type f 2>/dev/null | wc -l)
    if [ "$active" -eq 0 ]; then
      if is_running; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] No active Claude sessions for 3 minutes. Shutting down OmniRoute." >> /tmp/omniroute-manager.log
        "$OMNIROUTE_BIN" stop >/dev/null 2>&1 || true
        pkill -f "omniroute.mjs serve" 2>/dev/null || true
      fi
    fi
    rm -f "$TIMER_FILE"
  ) >/dev/null 2>&1 &

  echo $! > "$TIMER_FILE"
}

case "$1" in
  ensure-started)
    start_omniroute
    ;;

  stop)
    stop_omniroute
    ;;

  register-session)
    local_session="$2"
    cancel_shutdown
    touch "$SESSION_DIR/$local_session"
    ;;

  unregister-session)
    local_session="$2"
    rm -f "$SESSION_DIR/$local_session"
    remaining=$(count_sessions)
    if [ "$remaining" -eq 0 ]; then
      schedule_shutdown
    fi
    ;;

  status)
    if is_running; then
      echo "OmniRoute: RUNNING on port $PORT"
    else
      echo "OmniRoute: STOPPED"
    fi
    echo "Active Claude Sessions: $(count_sessions)"
    if [ -f "$TIMER_FILE" ]; then
      echo "Pending Shutdown: YES (countdown in progress)"
    else
      echo "Pending Shutdown: NO"
    fi
    ;;

  *)
    echo "Usage: $0 {ensure-started|stop|register-session <id>|unregister-session <id>|status}"
    exit 1
    ;;
esac
