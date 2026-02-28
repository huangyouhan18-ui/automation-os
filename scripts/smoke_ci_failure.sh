#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

cp -R "${ROOT_DIR}" "${TMP_DIR}/automation-os"

python3 - "${TMP_DIR}/automation-os/task.json" <<'PY'
import json
import sys

path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

for task in data.get("tasks", []):
    if task.get("id") == "T001":
        task["status"] = "BROKEN_STATUS"
        break

with open(path, "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
    f.write("\n")
PY

set +e
(
  cd "${TMP_DIR}/automation-os"
  bash scripts/check.sh >/tmp/automation-os-smoke.log 2>&1
)
rc=$?
set -e

if [[ ${rc} -eq 0 ]]; then
  echo "[smoke] expected failure but check.sh passed" >&2
  echo "[smoke] log:" >&2
  cat /tmp/automation-os-smoke.log >&2
  exit 1
fi

echo "[smoke] PASS: check.sh failed as expected (rc=${rc})"
grep -E "invalid status|all checks passed" /tmp/automation-os-smoke.log || true
