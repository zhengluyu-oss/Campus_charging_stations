# 流程 03：Bug 修复

**目标：** 定位根本原因，最小化修改完成修复，留下完整 Superpowers 变更记录。

**核心约束：** 必须先完成根因分析，确认问题所在后再写任何代码。

**分支原则：** 修复开始前，用户已经手动创建并切换到修复分支。AI 只在当前分支落代码，禁止自动创建新分支、切换分支或创建 git worktree；除非用户明确要求。

**OpenSpec 使用原则：** Bug 修复默认不使用 OpenSpec。根因、计划、审查、归档都落在 `superpowers/changes/`，避免第二套 `tasks.md`。

**前置：** 先阅读 [文档管理规范.md](文档管理规范.md)。

---

## 流程概览

```
① systematic-debugging  → diagnosis.md
② 当前分支检查 + 基线验证
③ writing-plans         → plan.md
④ subagent-driven-development（推荐，内含 TDD + 逐任务审查）
   或 executing-plans（备选，需批次审查）
⑤ requesting-code-review → 终审 review.md
⑥ verification-before-completion
⑦ finishing-a-development-branch
⑧ Superpowers 归档
```

---

## 步骤 1：根因分析

**调用技能：** `systematic-debugging`（AI 自动）

描述目标："对这个 Bug（描述现象与复现步骤）进行根本原因分析，不要修改代码。"

AI 强制执行四阶段分析（流程详见 [Superpowers和OpenSpec技能介绍.md](Superpowers和OpenSpec技能介绍.md) 的 `systematic-debugging`）。

**产出（根因分析主文档）：**
```
superpowers/changes/<序号>-fix-<简短描述>/diagnosis.md
```

内容：故障现象、复现步骤、根本原因、影响范围、修复方向。

确认你理解根本原因后，进入下一步。

---

## 步骤 2：确认分支并编写修复计划

### 2.1 确认当前修复分支

**调用方式：** 普通 git 状态检查

要求：

- 确认当前分支不是 `main` / `master` / 受保护发布分支。
- 记录当前分支名，后续所有改动都落在这个分支。
- 检查工作区是否存在未提交改动；如有，区分用户已有改动和本次修复范围。
- 禁止自动创建新分支、切换分支、创建 worktree 或清理 worktree。
- 运行能复现问题或覆盖相关模块的基线测试；如果基线失败，记录失败现状并询问是否继续。

### 2.2 编写修复计划

**调用技能：** `writing-plans`（AI 自动）

描述目标："基于根因分析，为这个 Bug 编写修复计划，修改范围最小化。"

**产出（执行主文档）：**
```
superpowers/changes/<序号>-fix-<简短描述>/plan.md
```

内容：逐步任务（精确文件路径、具体代码、测试命令）。要求：不混入重构，不改动无关代码。

---

## 步骤 3：执行修复

**调用技能：** `subagent-driven-development`（AI 自动）

- 读取：`superpowers/changes/<序号>-fix-<简短描述>/plan.md`
- 先写能复现 Bug 的**失败测试**（TDD 强制）
- 修改范围严格限于根因位置
- 每个任务完成后必须经过规格符合性审查和代码质量审查
- 全部任务完成后，必须有一次覆盖整个修复范围的最终审查

**备选技能：** `executing-plans`

当子代理不可用或修复任务强耦合时使用。使用该方式时，每完成一个修复批次必须调用 `requesting-code-review`，Critical / Important 问题未解决前不能进入下一批。

---

## 步骤 4：代码复审

**调用技能：** `requesting-code-review`（按门禁触发）

描述目标："修复任务已完成，确认 Bug 是否真正修复，且没有引入回归。"

复审重点：Bug 是否真正修复、是否引入新问题、修复是否符合最小化原则。

**产出：**
```
superpowers/changes/<序号>-fix-<简短描述>/review.md
```

处理反馈时使用 `receiving-code-review`：先验证建议是否成立，再逐项修复。Critical / Important 问题未解决前不能进入完成前验证。

---

## 步骤 5：完成前验证

**调用技能：** `verification-before-completion`

必须提供新鲜验证证据：

- 原 Bug 复现用例已从失败变为通过。
- 相关回归测试通过。
- 受影响模块的构建 / lint / 类型检查通过（按项目技术栈选择）。
- 如果某项验证无法执行，必须说明原因和剩余风险。

---

## 步骤 6：完成开发分支

**调用技能：** `finishing-a-development-branch`

本项目约束：

- 不创建新分支。
- 不切换到其他分支，除非用户选择合并并明确确认。
- 不清理 worktree，因为本流程默认不创建 worktree。
- 不删除当前分支，除非用户明确要求丢弃并二次确认。

---

## 步骤 7：归档

归档本次 Superpowers 修复记录：

```
superpowers/changes/<序号>-fix-<简短描述>/
```

归档目标：

```
superpowers/changes/archive/<序号>-fix-<简短描述>-YYYY-MM-DD/
```

归档对象至少包含：

- `diagnosis.md`
- `plan.md`
- `review.md`
- `fix-plan.md`（如有）

---

产出文件路径规范见 [文档管理规范.md](文档管理规范.md) 第 3.3–3.6 节。
