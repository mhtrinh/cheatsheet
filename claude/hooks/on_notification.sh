#!/usr/bin/env bash
input=$(cat)
notification_type=$(echo "$input" | jq -r '.notification_type')

[ "$notification_type" = "permission_prompt" ] || exit 0
[ -n "$CLAUDE_NTFY_TOPIC" ] || exit 0

session_id=$(echo "$input" | jq -r '.session_id')
tmpfile="/tmp/claude_notify_${session_id}"
[ -f "$tmpfile" ] || exit 0

start_ts=$(jq -r '.ts' < "$tmpfile")
now=$(date +%s)
elapsed=$((now - start_ts))

[ "$elapsed" -gt 30 ] || exit 0

message=$(echo "$input" | jq -r '.message')
curl -s -o /dev/null \
    -H "Title: Claude needs permission (${elapsed}s)" \
    -d "$message" \
    "https://ntfy.sh/${CLAUDE_NTFY_TOPIC}"
