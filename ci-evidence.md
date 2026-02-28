# T010 验收证据记录（已完成）

> 基于 `ci-evidence-template.md` 的回填。已补齐远端分支保护与失败阻断证据。

## 1) 仓库与分支范围
- 仓库：`https://github.com/huangyouhan18-ui/automation-os`
- 受保护分支：`main`
- 配置人：`huangyouhan18-ui`（由 agent 执行配置）
- 配置时间（CST）：2026-02-28 13:34

## 2) Required Status Check 配置
GitHub `Settings -> Branches -> Branch protection rules` 已确认：
- [x] 已启用 `Require status checks to pass before merging`
- [x] 已勾选 `automation-os-check`
- [x] 已勾选 required check：`check`（workflow: `automation-os-check`）
- [x] 已启用 `Require branches to be up to date before merging`（strict=true）

## 3) 失败阻断演练
- 演练分支：`ci-failure-drill`
- 演练方式：故意破坏 `task.json`（追加非法文本）触发 CI 失败
- 预期结果：`automation-os-check` 失败，PR 合并被阻断
- 实际结果：满足预期（PR `mergeStateStatus=BLOCKED`，status check `check=FAILURE`）
- 演练 PR：`https://github.com/huangyouhan18-ui/automation-os/pull/1`

## 4) 本地已验证证据（本轮新增）
- CI 工作流文件存在：`.github/workflows/ci-check.yml`
- 工作流触发条件包含：`push`、`pull_request`
- 工作流执行命令：`bash scripts/check.sh | tee ci-check.log`
- 工作流日志留存：`actions/upload-artifact@v4` 上传 `automation-os-check-log`

## 5) 证据附件
- Branch protection（API 回执）：已在配置步骤返回 required status checks=check
- Actions 失败日志链接：
  - https://github.com/huangyouhan18-ui/automation-os/actions/runs/22514391741/job/65229619306
  - https://github.com/huangyouhan18-ui/automation-os/actions/runs/22514392266/job/65229620693
- PR 阻断页面：
  - https://github.com/huangyouhan18-ui/automation-os/pull/1

## 6) 结论
- [x] T010 验收通过（满足“失败时阻断合并”）
- 当前状态：`DONE`
- 备注：本地与远端证据链均已补齐（push 触发、失败阻断、日志可追踪）。

## 7) 管理员最小回填清单（一次性）
1. 在受保护分支启用：`Require status checks to pass before merging`
2. 勾选 required check：`automation-os-check`
3. 创建演练分支并制造一次可控失败（参考 `ci-drill.md`）
4. 创建 PR，确认 `automation-os-check` 失败且 Merge 被阻断
5. 已完成证据回填；第 2 节与第 6 节均已勾选为 `[x]`
