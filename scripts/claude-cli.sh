#!/usr/bin/env bash
# Claude Code CLI wrapper with OmniRoute on-demand lifecycle

SESSION_ID="cli_$$"

# Ensure OmniRoute is awake and ready
/home/siakshit/.local/bin/omniroute-manager ensure-started

# Register active session
/home/siakshit/.local/bin/omniroute-manager register-session "$SESSION_ID"

cleanup() {
  /home/siakshit/.local/bin/omniroute-manager unregister-session "$SESSION_ID"
}

trap cleanup EXIT INT TERM

# Run Claude Code CLI
/usr/bin/claude "$@"
EXIT_CODE=$?

exit $EXIT_CODE
