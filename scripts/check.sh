#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

required_files=(
  "README.md"
  "architecture.md"
  "WORKFLOW.md"
  "task.json"
  "progress.txt"
)

echo "[check] validating required files"
for file in "${required_files[@]}"; do
  if [[ ! -f "${ROOT_DIR}/${file}" ]]; then
    echo "[check] missing file: ${file}" >&2
    exit 1
  fi
  echo "[check] found: ${file}"
done

echo "[check] validating task.json syntax"
python3 -m json.tool "${ROOT_DIR}/task.json" >/dev/null

echo "[check] all checks passed"
