# Superpowers 工作区规范

版本：v1.0

---

# 目标

本规范用于统一管理 Superpowers 在项目中的所有分析结果、审计报告、重构计划、知识沉淀和架构决策。

原则：

1. AI生成内容统一管理
2. 项目知识长期沉淀
3. 避免重复分析
4. 降低上下文损耗
5. 提高Claude协作效率

---

# 工作区结构

```text
project-root
│
├─ .superpowers
│
│  ├─ project
│  ├─ audit
│  ├─ plans
│  ├─ decisions
│  ├─ prompts
│  └─ reports
│
└─ src
```

---

# project目录

项目理解知识库。

存放：

```text
.superpowers/project
```

内容：

```text
overview.md
architecture.md
modules.md
startup-flow.md
business-flow.md
api-system.md
database.md
cache.md
infrastructure.md
deployment.md
```

用途：

建立项目认知。

目标：

让任何开发者在最短时间内理解项目。

---

# audit目录

代码审计目录。

存放：

```text
.superpowers/audit
```

内容：

```text
architecture-audit.md
security-audit.md
performance-audit.md
maintainability-audit.md
dependency-audit.md
audit-report.md
```

用途：

记录所有审计结果。

目标：

发现风险和技术债。

---

# plans目录

计划目录。

存放：

```text
.superpowers/plans
```

内容：

```text
refactor-roadmap.md
tech-debt.md
migration-plan.md
feature-roadmap.md
optimization-plan.md
```

用途：

记录未来改造计划。

目标：

指导后续开发。

---

# decisions目录

架构决策记录。

存放：

```text
.superpowers/decisions
```

内容：

```text
ADR-001.md
ADR-002.md
ADR-003.md
...
```

ADR：

Architecture Decision Record

记录：

* 为什么这样设计
* 为什么放弃某方案
* 为什么重构

目标：

防止团队遗忘历史决策。

---

# prompts目录

提示词库。

存放：

```text
.superpowers/prompts
```

内容：

```text
understand-project.md
architecture-review.md
security-review.md
performance-review.md
code-review.md
refactor-review.md
```

用途：

统一团队分析标准。

---

# reports目录

阶段性报告。

存放：

```text
.superpowers/reports
```

内容：

```text
weekly-report.md
monthly-report.md
quarterly-report.md
release-report.md
```

用途：

记录阶段成果。

---

# Skill说明

---

## Brainstorm

用途：

分析问题。

目标：

理解需求。

禁止：

直接写代码。

适用于：

```text
理解项目
需求分析
架构分析
技术选型
方案设计
```

标准流程：

```text
brainstorm
↓
形成结论
↓
进入计划阶段
```

---

## Write Plan

用途：

制定计划。

目标：

拆解任务。

禁止：

直接修改代码。

适用于：

```text
项目审计
重构计划
开发计划
迁移计划
技术债治理
```

标准流程：

```text
分析结果
↓
write-plan
↓
生成路线图
```

---

## Execute Plan

用途：

执行计划。

目标：

完成具体任务。

要求：

每次仅执行一个阶段。

禁止：

一次执行全部任务。

标准流程：

```text
阶段1
提交

阶段2
提交

阶段3
提交
```

---

## Review

用途：

质量检查。

目标：

发现问题。

适用于：

```text
架构审查
代码审查
安全审查
性能审查
重构审查
```

输出：

```text
Critical
High
Medium
Low
```

风险等级。

---

# 推荐工作流

---

## 接手项目

```text
Brainstorm
↓
Write Plan
↓
Execute Plan
↓
生成 project 目录
```

---

## 审计项目

```text
Review
↓
Write Plan
↓
生成 audit 目录
```

---

## 重构项目

```text
Review
↓
Write Plan
↓
Execute Plan
↓
生成 plans 目录
```

---

## 开发需求

```text
Brainstorm
↓
Write Plan
↓
Execute Plan
↓
Review
```

---

# 强制规则

禁止：

```text
直接写代码
直接重构
直接修Bug
```

必须：

```text
Brainstorm
↓
Write Plan
↓
Execute Plan
↓
Review
```

所有分析结果必须沉淀到：

```text
.superpowers/
```

任何新的分析、审计、重构和决策都必须形成文档。

禁止只存在于聊天记录中。

知识必须沉淀。

```
```
