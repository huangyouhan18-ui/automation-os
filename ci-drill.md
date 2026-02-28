# CI 失败阻断演练 Runbook（T010）

> 目标：产出可审计证据，证明 `automation-os-check` 失败时 PR 会被阻断合并。

## 前置条件
- 已在目标仓库开启分支保护规则。
- 已勾选 required status check：`automation-os-check`。
- 有权限创建分支与发起 PR。
- 本地可执行一次失败冒烟：`bash scripts/smoke_ci_failure.sh`（确认失败检测链路有效）。

## 演练步骤（最小闭环）
1. 新建演练分支（示例）
   - `ci-drill/fail-check-<date>`
2. 制造一个可控失败（推荐改坏 `task.json`）
   - 将某个任务 `status` 临时改为非法值（如 `INVALID`）
3. 提交并推送分支，创建 PR 指向受保护分支。
4. 等待 GitHub Actions 执行 `automation-os-check`。
5. 在 PR 页面确认：
   - 状态检查失败
   - 合并按钮被阻断（无法 merge）
6. 收集证据并回填 `ci-evidence.md`：
   - Branch protection 设置截图
   - Actions 失败日志截图（含失败项）
   - PR 阻断截图
7. 清理演练改动（修复 `task.json` 非法值）并关闭/更新 PR。

## 回填清单（与 ci-evidence.md 对齐）
- 第 2 节：勾选 required status checks 开启与 job 勾选
- 第 3 节：补全演练分支、演练方式、实际结果
- 第 5 节：补齐三类截图/链接
- 第 6 节：确认后勾选 `T010 验收通过`

## 风险控制
- 仅在演练分支制造失败，不要污染主分支。
- 演练结束立即回滚故障改动，避免后续误用。
- 若仓库策略或权限不清晰，先暂停并由管理员确认后再继续。
