#!/usr/bin/env bash
# Background watcher: detect frozen subagents via stale heartbeat
# Launched by UserPromptSubmit, killed by Stop hook
# Args: $1 = session_id, $2 = timeout_seconds (default 300)

session_id="$1"
timeout="${2:-300}"
check_interval=30
heartbeat_file="/tmp/claude_heartbeat_${session_id}"
pidfile="/tmp/claude_watcher_${session_id}.pid"

echo $$ > "$pidfile"

while true; do
    sleep "$check_interval"

    [ -f "$heartbeat_file" ] || continue

    last_ts=$(jq -r '.ts' < "$heartbeat_file")
    last_agent=$(jq -r '.agent' < "$heartbeat_file")
    last_tool=$(jq -r '.tool' < "$heartbeat_file")
    now=$(date +%s)
    stale=$((now - last_ts))

    if [ "$stale" -gt "$timeout" ]; then
        printf '\e]777;notify;Claude Code;Agent frozen: %s idle %ds (last: %s)\a' \
            "$last_agent" "$stale" "$last_tool" > /dev/tty 2>/dev/null
        # Reset timestamp to avoid repeated notifications
        jq --arg ts "$now" '.ts = $ts' < "$heartbeat_file" > "${heartbeat_file}.tmp" \
            && mv "${heartbeat_file}.tmp" "$heartbeat_file"
    fi
done
