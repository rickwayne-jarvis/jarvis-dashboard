#!/bin/bash
# Double-click to launch JARVIS in Chrome.
cd "$(dirname "$0")"

PORT=8765
URL="http://localhost:$PORT/"

# Kill anything already on this port (previous run)
lsof -ti tcp:$PORT | xargs kill -9 2>/dev/null

# Start a tiny static server in the background
python3 -m http.server $PORT --bind 127.0.0.1 >/tmp/jarvis-server.log 2>&1 &
SERVER_PID=$!

# Give it a moment to bind, then launch Chrome
sleep 0.5
open -a "Google Chrome" "$URL" 2>/dev/null || open "$URL"

echo ""
echo "  JARVIS // running at $URL"
echo "  PID: $SERVER_PID   |   log: /tmp/jarvis-server.log"
echo "  Close this window or hit Ctrl+C to shut down."
echo ""

# Wait so closing the Terminal window also kills the server
trap "kill $SERVER_PID 2>/dev/null; exit" INT TERM
wait $SERVER_PID
