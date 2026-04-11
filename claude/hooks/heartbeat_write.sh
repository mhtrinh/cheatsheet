#!/usr/bin/env bash
# PostToolUse hook: write heartbeat timestamp after every tool call
input=$(cat)
session_id=$(echo "$input" | jq -r '.session_id')
tool_name=$(echo "$input" | jq -r '.tool_name')
agent_id=$(echo "$input" | jq -r '.agent_id // empty')

heartbeat_file="/tmp/claude_heartbeat_${session_id}"

jq -n \
  --arg ts "$(date +%s)" \
  --arg tool "$tool_name" \
  --arg agent "${agent_id:-main}" \
  '{"ts": $ts, "tool": $tool, "agent": $agent}' \
  > "$heartbeat_file"
