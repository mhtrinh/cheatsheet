#!/usr/bin/env bash
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id')

# Kill heartbeat watcher
pidfile="/tmp/claude_watcher_${session_id}.pid"
if [ -f "$pidfile" ]; then
    kill "$(cat "$pidfile")" 2>/dev/null
    rm -f "$pidfile"
fi
rm -f "/tmp/claude_heartbeat_${session_id}"

tmpfile="/tmp/claude_notify_${session_id}"
[ -f "$tmpfile" ] || exit 0

start_ts=$(jq -r '.ts' < "$tmpfile")
stored_cwd=$(jq -r '.cwd' < "$tmpfile")
prompt_preview=$(jq -r '.preview' < "$tmpfile")

rm -f "$tmpfile"

now=$(date +%s)
elapsed=$((now - start_ts))

if [ "$elapsed" -gt 300 ] && [ -n "$CLAUDE_NTFY_TOPIC" ]; then
    project=$(basename "$stored_cwd")
    curl -s -o /dev/null \
        -H "Title: Claude finished (${elapsed}s)" \
        -d "${project}: ${prompt_preview}" \
        "https://ntfy.sh/${CLAUDE_NTFY_TOPIC}"
fi
