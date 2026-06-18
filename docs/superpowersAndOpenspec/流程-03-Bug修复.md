# 流程 03：Bug 修复

**目标：** 定位根本原因，最小化修改完成修复，留下完整变更记录。

**核心约束：** 必须先完成根因分析，确认问题所在后再写任何代码。

**前置：** 先阅读 [文档管理规范.md](文档管理规范.md)。

---

## 流程概览

```
① systematic-debugging  → diagnosis.md
② writing-plans         → plan.md（并同步 tasks.md）
③ /opsx:propose         → 变更账本
④ subagent-driven-development（读 plan.md，打钩 tasks.md）
⑤ requesting-code-review → review.md
⑥ /opsx:archive
```

---

## 步骤 1：根因分析

**调用技能：** `systematic-debugging`（AI 自动）

描述目标："对这个 Bug（描述现象与复现步骤）进行根本原因分析，不要修改代码。"

AI 强制执行四阶段分析（流程详见 [Superpowers和OpenSpec技能介绍.md](Superpowers和OpenSpec技能介绍.md) 的 `systematic-debugging`）。

**产出（设计主文档）：**
```
superpowers/changes/<序号>-fix-<简短描述>/diagnosis.md
```

内容：故障现象、复现步骤、根本原因、影响范围、修复方向。

确认你理解根本原因后，进入下一步。

---

## 步骤 2：编写修复计划

**调用技能：** `writing-plans`（AI 自动）

描述目标："基于根因分析，为这个 Bug 编写修复计划，修改范围最小化。"

**产出（执行主文档）：**
```
superpowers/changes/<序号>-fix-<简短描述>/plan.md
```

内容：逐步任务（精确文件路径、具体代码、测试命令）。要求：不混入重构，不改动无关代码。

---

## 步骤 3：建立变更账本

**调用技能：** `openspec-propose`

```
/opsx:propose <序号>-fix-<简短描述>
```

从 `diagnosis.md` 派生，不重复写完整根因分析：

```
openspec/changes/<序号>-fix-<简短描述>/
├─ proposal.md    ← 故障摘要、影响范围、修复方案概述
└─ tasks.md       ← 与 plan.md 对齐的勾选清单
```

---

## 步骤 4：执行修复

**调用技能：** `subagent-driven-development`（AI 自动）

- 读取：`superpowers/changes/<序号>-fix-<简短描述>/plan.md`
- 先写能复现 Bug 的**失败测试**（TDD 强制）
- 修改范围严格限于根因位置
- 每完成一项：在 `openspec/changes/<序号>-fix-<简短描述>/tasks.md` 打钩

---

## 步骤 5：代码复审

**调用技能：** `requesting-code-review`（AI 自动）

描述目标："修复任务已完成，进行代码复审。"

复审重点：Bug 是否真正修复、是否引入新问题、修复是否符合最小化原则。

**产出：**
```
openspec/changes/<序号>-fix-<简短描述>/review.md
```

按 Critical → Important → Minor 处理反馈（`receiving-code-review`）。

---

## 步骤 6：归档

```
/opsx:archive <序号>-fix-<简短描述>
```

归档至 `openspec/changes/archive/YYYY-MM-DD-<序号>-fix-<简短描述>/`。

---

产出文件路径规范见 [文档管理规范.md](文档管理规范.md) 第 3.3、3.4 节。
