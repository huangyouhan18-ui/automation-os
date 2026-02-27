# 自动化编程一人公司最小可用骨架（MVP）架构

## 1. 目标
用最小成本把“需求 -> 实现 -> 测试 -> 发布 -> 复盘”做成可重复闭环，
在单人条件下尽量做到：
- 任务可拆分
- 过程可追踪
- 结果可验收
- 问题可复盘

## 2. 核心原则
1. **单任务闭环**：一次只推进一个任务到“可验收完成”。
2. **文档先行**：任何实现都应有输入、输出、验收标准。
3. **自动化优先**：重复动作尽量脚本化。
4. **可回滚**：每次变更对应清晰 commit。
5. **小步快跑**：避免大爆炸式重构。

## 3. 组件分层

### A. 任务层（Task Layer）
- `task.json`：任务池与验收标准（source of truth）
- 字段：`id/title/owner/status/deps/input/output/acceptance`

### B. 执行层（Execution Layer）
- `WORKFLOW.md`：单任务执行规则与状态流转
- 本地脚本（后续可加）：`scripts/run-task.sh`, `scripts/check-task.sh`

### C. 记录层（Record Layer）
- `progress.txt`：按轮次记录执行日志、阻塞、决策
- Git commit：每个任务至少一条可追踪提交

### D. 入口层（Operator Layer）
- `README.md`：如何启动、如何推进下一任务

## 4. 生命周期（最小状态机）
`TODO -> DOING -> VERIFY -> DONE`

- TODO：待做、信息齐备
- DOING：开发/编辑中
- VERIFY：自检与验收中
- DONE：验收通过并记录结果

## 5. 角色映射（单人多角色）
- PM：明确任务和验收标准
- Dev：实现变更
- QA：执行验证清单
- Reviewer：做最终质量门禁（可由同一人切换视角）

## 6. 最小自动化建议
1. JSON 结构校验（防任务池损坏）
2. Markdown 文档存在性检查
3. 任务状态合法性检查
4. 变更前后 git diff 摘要输出

## 7. 后续扩展方向
- 增加 `metrics.json`：交付周期、返工率、缺陷率
- 接入 CI（本地或云端）自动跑验收脚本
- 为任务生成模板化分支名与提交信息
