#!/usr/bin/env bash
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id')
cwd=$(echo "$input" | jq -r '.cwd')
prompt=$(echo "$input" | jq -r '.prompt')

timestamp=$(date +%s)
prompt_preview=$(echo "$prompt" | tr '\n' ' ' | cut -c1-60)

jq -n \
  --arg ts "$timestamp" \
  --arg cwd "$cwd" \
  --arg preview "$prompt_preview" \
  '{"ts": $ts, "cwd": $cwd, "preview": $preview}' \
  > "/tmp/claude_notify_${session_id}"

# Start heartbeat watcher if not already running
pidfile="/tmp/claude_watcher_${session_id}.pid"
if [ ! -f "$pidfile" ] || ! kill -0 "$(cat "$pidfile")" 2>/dev/null; then
    bash /home/mhtrinh/.claude/hooks/heartbeat_watcher.sh "$session_id" 300 &
fi
