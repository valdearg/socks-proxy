#!/usr/bin/env bash
set -euo pipefail

: "${SSH_HOST:?SSH_HOST is required}"
: "${SOCKS_PORT:?SOCKS_PORT is required}"

SSH_USER="${SSH_USER:-}"
SSH_KEY="${SSH_KEY:-}"
SSH_EXTRA_OPTS="${SSH_EXTRA_OPTS:-}"
BIND_ADDRESS="${BIND_ADDRESS:-0.0.0.0}"

TARGET="${SSH_HOST}"
if [[ -n "${SSH_USER}" ]]; then
  TARGET="${SSH_USER}@${SSH_HOST}"
fi

SSH_OPTS=(
  -N
  -D "${BIND_ADDRESS}:${SOCKS_PORT}"
  -o "ServerAliveInterval=30"
  -o "ServerAliveCountMax=3"
  -o "ExitOnForwardFailure=yes"
  -o "StrictHostKeyChecking=yes"
)

if [[ -n "${SSH_KEY}" ]]; then
  SSH_OPTS+=(-i "${SSH_KEY}")
fi

if [[ -n "${SSH_EXTRA_OPTS}" ]]; then
  # shellcheck disable=SC2206
  EXTRA_OPTS=( ${SSH_EXTRA_OPTS} )
  SSH_OPTS+=("${EXTRA_OPTS[@]}")
fi

echo "Starting SOCKS5 proxy on ${BIND_ADDRESS}:${SOCKS_PORT} -> ${TARGET}"

exec autossh \
  -M 0 \
  "${SSH_OPTS[@]}" \
  "${TARGET}"