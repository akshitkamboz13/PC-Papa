#!/usr/bin/env bash
# Claude GUI wrapper (Standalone Web App via Brave) with OmniRoute on-demand lifecycle

SESSION_ID="gui_$$"

# Ensure OmniRoute is awake and ready
/home/siakshit/.local/bin/omniroute-manager ensure-started

# Register active session
/home/siakshit/.local/bin/omniroute-manager register-session "$SESSION_ID"

cleanup() {
  /home/siakshit/.local/bin/omniroute-manager unregister-session "$SESSION_ID"
}

trap cleanup EXIT INT TERM

# Launch Claude Web in Standalone App window
brave --app=https://claude.ai "$@"
EXIT_CODE=$?

exit $EXIT_CODE
