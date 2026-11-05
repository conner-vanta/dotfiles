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

# Load Ona-managed environment variables and secrets.
if [ -r /etc/profile.d/ona-secrets.sh ]; then
  # shellcheck source=/dev/null
  source /etc/profile.d/ona-secrets.sh
fi


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

# Buildkite auth
bk configure --org VantaInc --token "$BUILDKITE_API_TOKEN" --force

# --- Install proj-snowplow-knowledge-base (Project Snowplow KB + snowplow-* skills) ---
# Per the KB's README: clone into $HOME/shared (shared EFS on Ona, so every instance sees
# it), then run its setup.sh, which pulls when on clean main and links the
# snowplow-* skills into ~/.claude/skills and ~/.agents/skills.
SNOW_KB="$HOME/shared/proj-snowplow-knowledge-base"
[ -d "$SNOW_KB/.git" ] \
  || git clone --quiet https://github.com/VantaInc/proj-snowplow-knowledge-base.git "$SNOW_KB"
SNOWPLOW_KB_DIR="$SNOW_KB" bash "$SNOW_KB/scripts/setup.sh" \
  || echo "snowplow KB: setup.sh failed"

AGENTS_OVERRIDE_FILE="/workspaces/obsidian/AGENTS.override.md"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_AGENTS_OVERRIDE="${SCRIPT_DIR}/AGENTS.override.md"

SOURCE_SKILLS="${SCRIPT_DIR}/.agents/skills"
TARGET_SKILLS="/workspaces/obsidian/.agents/skills"

# Keep personal skills out of Obsidian commits without changing its shared ignore file.
# Resolve the Git path so this also works when .git is a worktree pointer file.
OBSIDIAN_EXCLUDE="$(git -C /workspaces/obsidian rev-parse --path-format=absolute --git-path info/exclude)"
PERSONAL_SKILLS_PATTERN='/.agents/skills/conner-*/'
mkdir -p "$(dirname "$OBSIDIAN_EXCLUDE")"
if [[ ! -f "$OBSIDIAN_EXCLUDE" ]] || ! grep -Fxq "$PERSONAL_SKILLS_PATTERN" "$OBSIDIAN_EXCLUDE"; then
  printf '\n%s\n' "$PERSONAL_SKILLS_PATTERN" >> "$OBSIDIAN_EXCLUDE"
fi

echo "Installing agent configuration"
if [[ ! -f "$SOURCE_AGENTS_OVERRIDE" ]]; then
  echo "Missing ${SOURCE_AGENTS_OVERRIDE}; cannot install AGENTS override." >&2
  exit 1
fi
if [[ ! -d "$SOURCE_SKILLS" ]]; then
  echo "Missing ${SOURCE_SKILLS}; cannot install agent skills." >&2
  exit 1
fi
mkdir -p "$(dirname "$AGENTS_OVERRIDE_FILE")" "$TARGET_SKILLS"
cp "$SOURCE_AGENTS_OVERRIDE" "$AGENTS_OVERRIDE_FILE"
echo "Installed AGENTS override to ${AGENTS_OVERRIDE_FILE}"

# Personal skills use conner-* names to coexist with Obsidian's shared skills.
cp -R "$SOURCE_SKILLS/." "$TARGET_SKILLS/"
echo "Installed agent skills to ${TARGET_SKILLS}"

echo "Done running dotfiles installation script."
