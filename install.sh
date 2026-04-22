#!/usr/bin/env bash
set -euo pipefail

# Dotfile bootstrap: Atlassian CLI (Jira), Jira auth, git email
#
# Required environment variables (export before running, or use a wrapper):
#   JIRA_API_TOKEN     — from https://id.atlassian.com/manage-profile/security/api-tokens
#
# Optional:
#   JIRA_EMAIL         — Atlassian account email (defaults to GIT_EMAIL)
#   ACLI_INSTALL_DIR   — directory for the binary (default: ~/.local/bin)
#
# Example:
#   export JIRA_API_TOKEN='your-token'
#   ./install.sh

GIT_EMAIL="conner.smith@vanta.com"
JIRA_SITE="vanta.atlassian.net"
# JIRA_API_TOKEN is set as an env var in Ona

: "${GIT_EMAIL:?Set GIT_EMAIL (your git commit email)}"
: "${JIRA_SITE:?Set JIRA_SITE (e.g. yourcompany.atlassian.net)}"
: "${JIRA_API_TOKEN:?Set JIRA_API_TOKEN (Atlassian API token)}"

JIRA_EMAIL="${JIRA_EMAIL:-$GIT_EMAIL}"
ACLI_INSTALL_DIR="${ACLI_INSTALL_DIR:-$HOME/.local/bin}"
ACLI_BIN="${ACLI_INSTALL_DIR}/acli"

os="$(uname -s | tr '[:upper:]' '[:lower:]')"
arch="$(uname -m)"
case "$arch" in
x86_64 | amd64) arch_dl="amd64" ;;
arm64 | aarch64) arch_dl="arm64" ;;
*)
  echo "Unsupported CPU architecture: $arch" >&2
  exit 1
  ;;
esac

case "$os" in
darwin) platform="darwin" ;;
linux) platform="linux" ;;
*)
  echo "Unsupported OS: $os" >&2
  exit 1
  ;;
esac

download_url="https://acli.atlassian.com/${platform}/latest/acli_${platform}_${arch_dl}/acli"
tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

echo "Downloading ACLI from ${download_url}"
curl -fsSL -o "${tmpdir}/acli" "$download_url"
chmod +x "${tmpdir}/acli"

mkdir -p "$ACLI_INSTALL_DIR"
mv "${tmpdir}/acli" "$ACLI_BIN"
echo "Installed acli to $ACLI_BIN"

if [[ ":${PATH:-}:" != *":${ACLI_INSTALL_DIR}:"* ]]; then
  echo "Note: add ${ACLI_INSTALL_DIR} to your PATH if it is not already there." >&2
fi

echo "Configuring git user.email"
git config --global user.email "$GIT_EMAIL"

echo "Authenticating Jira CLI (acli) with API token"
# Token is read from stdin; do not pass on the command line.
printf '%s\n' "$JIRA_API_TOKEN" | "$ACLI_BIN" jira auth login \
  --site "$JIRA_SITE" \
  --email "$JIRA_EMAIL" \
  --token


AGENTS_OVERRIDE_FILE="/workspaces/obsidian/AGENTS.override.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_AGENTS_OVERRIDE="${SCRIPT_DIR}/AGENTS.override.md"

echo "Creating AGENTS.override.md file"
if [[ ! -f "$SOURCE_AGENTS_OVERRIDE" ]]; then
  echo "Missing ${SOURCE_AGENTS_OVERRIDE}; cannot install AGENTS override." >&2
  exit 1
fi
mkdir -p "$(dirname "$AGENTS_OVERRIDE_FILE")"
cp "$SOURCE_AGENTS_OVERRIDE" "$AGENTS_OVERRIDE_FILE"
echo "Installed AGENTS override to ${AGENTS_OVERRIDE_FILE}"

echo "Done running dotfiles installation script."
