# Release Checklist (MVP)

## Release Meta
- Version: `v0.1.0` (update before each release)
- Release date: `YYYY-MM-DD`
- Owner: `solo-founder`

## 1) 功能验证（Function Validation）
- [ ] 核心流程可按 `WORKFLOW.md` 执行一轮（TODO -> DOING -> VERIFY -> DONE）
- [ ] `task.json` 可正常解析（JSON 语法正确）
- [ ] 新增/变更文件与本次任务目标一致（无无关改动）

## 2) 回归验证（Regression Validation）
- [ ] 运行 `bash scripts/check.sh` 通过
- [ ] 必需文件完整（README/architecture/WORKFLOW/task.json/progress）
- [ ] 任务字段与状态枚举校验通过
- [ ] deps 引用合法性校验通过

## 3) 变更说明（Change Notes）
- [ ] 在 `progress.txt` 追加本轮记录（目标/动作/结果/风险/下一步）
- [ ] 记录本次 release 的变更摘要（新增、修改、修复）
- [ ] 标注潜在风险与影响范围

## 4) 回滚准备（Rollback）
- [ ] 记录上一稳定版本号（例如：`v0.0.x`）
- [ ] 保留可回滚 commit id
- [ ] 出现问题时可执行：`git checkout <last-stable-commit>` 或 `git revert <release-commit>`

## 5) 发布完成确认
- [ ] 已创建发布 commit，并附带清晰 message
- [ ] 发布后执行一次 `bash scripts/check.sh` 结果为 0
- [ ] 在 `progress.txt` 标记发布完成与版本号
