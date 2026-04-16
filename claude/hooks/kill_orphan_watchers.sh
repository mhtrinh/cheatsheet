#!/usr/bin/env bash
# Kill orphaned heartbeat_watcher processes.
# Called at watcher startup so each new session cleans up dead predecessors.
#
# Orphan conditions:
#   1. No heartbeat file and watcher has been running > timeout seconds
#   2. Heartbeat file exists but ts is stale > 2x timeout seconds
#
# Args: $1 = current session_id to skip (self-protection)

my_session="${1:-}"
default_timeout=300
stale_threshold=$((default_timeout * 2))

for pidfile in /tmp/claude_watcher_*.pid; do
    [ -f "$pidfile" ] || continue

    filename=$(basename "$pidfile")
    session_id="${filename#claude_watcher_}"
    session_id="${session_id%.pid}"

    [ "$session_id" = "$my_session" ] && continue

    watcher_pid=$(cat "$pidfile")
    [ -z "$watcher_pid" ] && continue

    if ! kill -0 "$watcher_pid" 2>/dev/null; then
        rm -f "$pidfile"
        continue
    fi

    heartbeat_file="/tmp/claude_heartbeat_${session_id}"

    if [ ! -f "$heartbeat_file" ]; then
        elapsed=$(ps -o etimes= -p "$watcher_pid" 2>/dev/null | tr -d ' ')
        if [ -n "$elapsed" ] && [ "$elapsed" -gt "$default_timeout" ]; then
            kill "$watcher_pid" 2>/dev/null
            rm -f "$pidfile"
        fi
    else
        last_ts=$(jq -r '.ts' < "$heartbeat_file" 2>/dev/null)
        [ -z "$last_ts" ] || [ "$last_ts" = "null" ] && continue
        now=$(date +%s)
        stale=$((now - last_ts))
        if [ "$stale" -gt "$stale_threshold" ]; then
            kill "$watcher_pid" 2>/dev/null
            rm -f "$pidfile"
        fi
    fi
done
