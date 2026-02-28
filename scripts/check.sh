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

echo "[check] validating task status enum"
python3 - "${ROOT_DIR}/task.json" <<'PY'
import json
import sys

allowed = {"TODO", "DOING", "VERIFY", "DONE"}
path = sys.argv[1]

with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

invalid = []
for task in data.get("tasks", []):
    status = task.get("status")
    task_id = task.get("id", "<missing-id>")
    if status not in allowed:
        invalid.append((task_id, status))

if invalid:
    for task_id, status in invalid:
        print(f"[check] invalid status: {task_id} -> {status}", file=sys.stderr)
    sys.exit(1)

print("[check] task status enum OK")
PY

echo "[check] validating required task fields"
python3 - "${ROOT_DIR}/task.json" <<'PY'
import json
import sys

required = {"id", "title", "status", "acceptance"}
path = sys.argv[1]

with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

missing = []
for task in data.get("tasks", []):
    task_id = task.get("id", "<missing-id>")
    for key in required:
        if key not in task:
            missing.append((task_id, key))

if missing:
    for task_id, key in missing:
        print(f"[check] missing task field: {task_id} -> {key}", file=sys.stderr)
    sys.exit(1)

print("[check] required task fields OK")
PY

echo "[check] validating deps references"
python3 - "${ROOT_DIR}/task.json" <<'PY'
import json
import sys

path = sys.argv[1]

with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

tasks = data.get("tasks", [])
ids = {task.get("id") for task in tasks}
invalid = []

for task in tasks:
    task_id = task.get("id", "<missing-id>")
    for dep in task.get("deps", []):
        if dep not in ids:
            invalid.append((task_id, dep))

if invalid:
    for task_id, dep in invalid:
        print(f"[check] invalid dep reference: {task_id} -> {dep}", file=sys.stderr)
    sys.exit(1)

print("[check] deps references OK")
PY

echo "[check] validating deps cycle"
python3 - "${ROOT_DIR}/task.json" <<'PY'
import json
import sys

path = sys.argv[1]

with open(path, "r", encoding="utf-8") as f:
    data = json.load(f)

graph = {task.get("id"): task.get("deps", []) for task in data.get("tasks", []) if task.get("id")}
visited = set()
stack = set()

def has_cycle(node):
    if node in stack:
        return True
    if node in visited:
        return False
    visited.add(node)
    stack.add(node)
    for dep in graph.get(node, []):
        if dep in graph and has_cycle(dep):
            return True
    stack.remove(node)
    return False

for task_id in graph:
    if has_cycle(task_id):
        print(f"[check] deps cycle detected at: {task_id}", file=sys.stderr)
        sys.exit(1)

print("[check] deps cycle OK")
PY

echo "[check] all checks passed"
