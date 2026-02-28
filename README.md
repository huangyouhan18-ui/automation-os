# 自动化编程一人公司最小可用骨架

## 这是什么
这是一个面向“单人自动化编程运营”的最小可用文档骨架，帮助你把工作流程结构化：
需求拆解、执行、验收、记录、迭代。

## 目录
- `architecture.md`：总体架构与原则
- `task.json`：任务池（含验收标准）
- `WORKFLOW.md`：单任务闭环规则
- `progress.txt`：执行轮次记录
- `daily-template.md`：每日“计划-执行-复盘”模板（T007）

## 如何运行（当前版本）
当前版本是 **文档驱动 MVP**，无业务代码构建流程。
你可以按以下步骤使用：

1. 查看任务池
   - 打开 `task.json`
   - 选择一个 `status=TODO` 且依赖已满足的任务

2. 按闭环规则执行
   - 阅读 `WORKFLOW.md`
   - 将任务推进：`TODO -> DOING -> VERIFY -> DONE`

3. 写入执行记录
   - 在 `progress.txt` 追加新轮次记录
   - 每日按 `daily-template.md` 落一次“计划-执行-复盘”

4. 提交版本
   - 完成后做一次 git commit，确保可追踪

## 自检
建议每轮至少执行：

```bash
python3 -m json.tool automation-os/task.json >/dev/null && echo "task.json OK"
ls -1 automation-os
```

说明：
- 当前项目为流程骨架，无代码构建目标，因此 `lint/build` 暂无可执行对象。
- 后续可在 T006 引入脚本化检查与 lint 规则。

## CI 合并门禁（T010）
已接入 GitHub Actions 工作流：`.github/workflows/ci-check.yml`（job 名：`automation-os-check`）。

为满足“失败时阻断合并”，请在仓库设置中开启：
- `Settings -> Branches -> Branch protection rules`
- 将状态检查 `automation-os-check` 设为 **required status check**

这样当 `bash scripts/check.sh` 失败时，PR 将无法合并，且可在 Actions 日志中定位具体失败项。

## 推荐下一步
1. 将 `automation-os-check` 配置为 required status check，完成 T010 验收收口
2. 开始 `T011`：建立架构自进化日志与回写机制
