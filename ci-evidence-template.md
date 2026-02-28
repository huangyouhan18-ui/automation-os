# T010 验收证据模板（Branch Protection）

> 目的：为“失败时阻断合并”提供可审计证据，补齐本地无法直接验证的远端配置项。

## 1) 仓库与分支范围
- 仓库：
- 受保护分支（例如 `main`）：
- 配置人：
- 配置时间（CST）：

## 2) Required Status Check 配置
请在 GitHub `Settings -> Branches -> Branch protection rules` 中确认：
- [ ] 已启用 `Require status checks to pass before merging`
- [ ] 已勾选 `automation-os-check`
- [ ] （可选）已启用 `Require branches to be up to date before merging`

## 3) 失败阻断演练
- 演练分支：
- 演练方式（例如故意改坏 `task.json`）:
- 预期结果：`automation-os-check` 失败，PR 合并按钮被阻断
- 实际结果：

## 4) 证据附件
- Branch protection 配置截图路径/链接：
- Actions 失败日志截图路径/链接：
- PR 页面阻断截图路径/链接：

## 5) 结论
- [ ] T010 验收通过（满足“失败时阻断合并”）
- 备注：
