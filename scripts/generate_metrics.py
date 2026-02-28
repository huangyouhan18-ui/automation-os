#!/usr/bin/env python3
import json
import re
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TASK_PATH = ROOT / "task.json"
PROGRESS_PATH = ROOT / "progress.txt"
METRICS_PATH = ROOT / "metrics.json"


def parse_round_status_transitions(progress_text: str):
    round_re = re.compile(r"^\[Round\s+(\d+)\]", re.MULTILINE)
    status_re = re.compile(r"将\s*(T\d+)\s*(?:状态)?\s*从\s*`?(TODO|DOING|VERIFY|DONE)`?\s*调整为\s*`?(TODO|DOING|VERIFY|DONE)`?")

    sections = []
    matches = list(round_re.finditer(progress_text))
    for i, m in enumerate(matches):
        start = m.start()
        end = matches[i + 1].start() if i + 1 < len(matches) else len(progress_text)
        sections.append((int(m.group(1)), progress_text[start:end]))

    first_doing_round = {}
    done_round = {}

    for round_no, section in sections:
        for task_id, _old, new in status_re.findall(section):
            if new == "DOING" and task_id not in first_doing_round:
                first_doing_round[task_id] = round_no
            if new == "DONE":
                done_round[task_id] = round_no

    return first_doing_round, done_round


def main():
    tasks_data = json.loads(TASK_PATH.read_text(encoding="utf-8"))
    progress_text = PROGRESS_PATH.read_text(encoding="utf-8")

    tasks = tasks_data.get("tasks", [])
    total_tasks = len(tasks)
    done_tasks = sum(1 for t in tasks if t.get("status") == "DONE")
    completion_rate = round(done_tasks / total_tasks, 4) if total_tasks else 0.0

    first_doing_round, done_round = parse_round_status_transitions(progress_text)
    cycle_samples = []
    for task_id, start_round in first_doing_round.items():
        if task_id in done_round and done_round[task_id] >= start_round:
            cycle_samples.append(done_round[task_id] - start_round + 1)

    avg_cycle = round(sum(cycle_samples) / len(cycle_samples), 4) if cycle_samples else None
    blocked_count = progress_text.count("阻塞")

    metrics = {
        "generated_at": datetime.now(timezone.utc).astimezone().replace(microsecond=0).isoformat(),
        "source": "task.json + progress.txt",
        "summary": {
            "total_tasks": total_tasks,
            "done_tasks": done_tasks,
            "completion_rate": completion_rate,
        },
        "cycle_time": {
            "avg_task_cycle": avg_cycle,
            "unit": "round",
            "method": "mean(done_round - start_round + 1) from progress.txt explicit status transitions",
            "sample_size": len(cycle_samples),
            "note": "当前样本来自 progress 中记录显式状态流转且已 DONE 的任务",
        },
        "blockers": {
            "blocked_count": blocked_count,
            "method": "count(keyword=阻塞) from progress.txt",
            "note": "当前按关键字粗略统计，后续可升级为结构化阻塞事件计数",
        },
    }

    METRICS_PATH.write_text(json.dumps(metrics, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"metrics generated: {METRICS_PATH}")


if __name__ == "__main__":
    main()
