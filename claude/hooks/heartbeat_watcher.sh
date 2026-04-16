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

bash "$(dirname "$0")/kill_orphan_watchers.sh" "$session_id"

notified_ts=0

while true; do
    sleep "$check_interval"

    [ -f "$heartbeat_file" ] || continue

    last_ts=$(jq -r '.ts' < "$heartbeat_file")
    last_agent=$(jq -r '.agent' < "$heartbeat_file")
    last_tool=$(jq -r '.tool' < "$heartbeat_file")
    now=$(date +%s)
    stale=$((now - last_ts))

    if [ "$stale" -gt "$timeout" ] && [ "$last_ts" != "$notified_ts" ]; then
        if [ -n "$CLAUDE_NTFY_TOPIC" ]; then
            tmpfile="/tmp/claude_notify_${session_id}"
            project=""
            [ -f "$tmpfile" ] && project="$(basename "$(jq -r '.cwd' < "$tmpfile")"): "
            curl -s -o /dev/null \
                -H "Title: Claude agent frozen (${stale}s idle)" \
                -d "${project}${last_agent} stuck on ${last_tool}" \
                "https://ntfy.sh/${CLAUDE_NTFY_TOPIC}"
        fi
        notified_ts=$last_ts
    fi
done
