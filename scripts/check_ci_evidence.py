#!/usr/bin/env python3
import json
import re
import sys
from pathlib import Path


def fail(msg: str) -> None:
    print(f"[check] {msg}", file=sys.stderr)
    sys.exit(1)


root = Path(__file__).resolve().parents[1]
task_path = root / "task.json"
evidence_path = root / "ci-evidence.md"

try:
    data = json.loads(task_path.read_text(encoding="utf-8"))
except Exception as exc:
    fail(f"failed to parse task.json: {exc}")

t010 = next((t for t in data.get("tasks", []) if t.get("id") == "T010"), None)
if not t010:
    fail("task T010 not found")

status = t010.get("status")
if status not in {"VERIFY", "DONE"}:
    print("[check] T010 not in VERIFY/DONE, skip CI evidence check")
    sys.exit(0)

if status == "VERIFY":
    blocker = str(t010.get("blocker", "")).strip()
    if not blocker:
        fail("T010 is VERIFY but blocker is missing")

if not evidence_path.exists():
    fail("ci-evidence.md missing while T010 is VERIFY/DONE")

text = evidence_path.read_text(encoding="utf-8")
required_markers = [
    "## 2) Required Status Check 配置",
    "## 3) 失败阻断演练",
    "## 5) 证据附件",
]
for marker in required_markers:
    if marker not in text:
        fail(f"ci-evidence.md missing section: {marker}")

if status == "DONE":
    if re.search(r"待回填", text):
        fail("T010 is DONE but ci-evidence.md still contains '待回填'")

    required_checked_markers = [
        "- [x] 已启用 `Require status checks to pass before merging`",
        "- [x] 已勾选 `automation-os-check`",
        "- [x] T010 验收通过（满足“失败时阻断合并”）",
    ]
    for marker in required_checked_markers:
        if marker not in text:
            fail(f"T010 is DONE but missing checked marker: {marker}")

print("[check] CI evidence consistency OK")
