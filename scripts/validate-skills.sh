#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."
shopt -s nullglob
skills=(.agents/skills/*/)
if [[ ${#skills[@]} -eq 0 ]]; then
  echo "No skill directories found in .agents/skills" >&2
  exit 1
fi

# Validate directories, not just SKILL.md matches, so a missing entrypoint fails.
failed=0
for skill in "${skills[@]}"; do
  uv run --locked skills-ref validate "$skill" || failed=1
done
exit "$failed"
