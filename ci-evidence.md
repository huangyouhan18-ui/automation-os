# T010 验收证据记录（进行中）

> 基于 `ci-evidence-template.md` 的本轮回填。当前先沉淀“本地可验证证据”，远端分支保护证据待仓库管理员回填。

## 1) 仓库与分支范围
- 仓库：`automation-os`（本地工作区）
- 受保护分支（例如 `main`）：待回填
- 配置人：待回填
- 配置时间（CST）：待回填

## 2) Required Status Check 配置
请在 GitHub `Settings -> Branches -> Branch protection rules` 中确认：
- [ ] 已启用 `Require status checks to pass before merging`
- [ ] 已勾选 `automation-os-check`
- [ ] （可选）已启用 `Require branches to be up to date before merging`

## 3) 失败阻断演练
- 演练分支：待回填
- 演练方式（例如故意改坏 `task.json`）：待回填
- 预期结果：`automation-os-check` 失败，PR 合并按钮被阻断
- 实际结果：待回填

## 4) 本地已验证证据（本轮新增）
- CI 工作流文件存在：`.github/workflows/ci-check.yml`
- 工作流触发条件包含：`push`、`pull_request`
- 工作流执行命令：`bash scripts/check.sh | tee ci-check.log`
- 工作流日志留存：`actions/upload-artifact@v4` 上传 `automation-os-check-log`

## 5) 证据附件
- Branch protection 配置截图路径/链接：待回填
- Actions 失败日志截图路径/链接：待回填
- PR 页面阻断截图路径/链接：待回填

## 6) 结论
- [ ] T010 验收通过（满足“失败时阻断合并”）
- 当前状态：`VERIFY`
- 备注：本地侧 CI 接入与日志追溯能力已具备；等待远端 required status check 启用与失败演练证据后再关闭 T010。
