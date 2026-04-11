#!/usr/bin/env bash
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id')
message=$(echo "$input" | jq -r '.message')

tmpfile="/tmp/claude_notify_${session_id}"
[ -f "$tmpfile" ] || exit 0

start_ts=$(jq -r '.ts' < "$tmpfile")
stored_cwd=$(jq -r '.cwd' < "$tmpfile")
prompt_preview=$(jq -r '.preview' < "$tmpfile")

now=$(date +%s)
elapsed=$((now - start_ts))

if [ "$elapsed" -gt 10 ]; then
    project=$(basename "$stored_cwd")
    printf '\e]777;notify;%s;%s\a' "$project" "${message} | ${prompt_preview}" > /dev/tty
fi
