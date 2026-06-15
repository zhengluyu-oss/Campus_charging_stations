# 新功能开发标准流程（Superpowers版）

版本：v3.0

目标：

将一个模糊需求转换为：

* 技术方案
* 数据结构
* 开发计划
* 实施任务

最终进入开发阶段。

禁止：

* 未分析直接写代码
* 未设计直接开发
* 未拆分任务直接执行

---

# 前置条件

确保项目根目录下已创建以下 skill：

```text
.claude/skills/
├── brainstorm/SKILL.md
├── write-plan/SKILL.md
├── execute-plan/SKILL.md
└── review/SKILL.md
```

产出物统一存放在：

```text
.superpowers/plans/<功能名>/
```

---

# 第一阶段：需求分析与影响分析

执行：

```text
/brainstorm <功能名>

目标：

分析新功能需求及其对现有系统的影响。

要求：

不要写代码。

输出：

1. 业务目标与用户价值
2. 使用场景与功能边界
3. 非功能需求
4. 涉及模块、接口、数据库、缓存、权限
5. 风险点
6. 验收标准

同时分析：

当前项目已有模块是否能够复用。
列出所有需要修改的位置。
```

生成：

```text
.superpowers/plans/<功能名>/requirements.md
```

---

# 第二阶段：技术方案设计

执行：

```text
/brainstorm <功能名>

目标：

设计完整的技术实现方案。

不要写代码。

输出：

1. 架构方案与模块设计
2. 数据库设计（新增表、修改表、索引、迁移方案）
3. 接口设计（接口列表、请求参数、响应结构、错误码）
4. 缓存设计
5. 权限设计
6. 异常处理与扩展性设计

给出推荐方案。
```

生成：

```text
.superpowers/plans/<功能名>/technical-design.md
```

---

# 第三阶段：任务拆分与开发方案

执行：

```text
/write-plan <功能名>

根据技术方案。

拆分开发任务并生成最终开发方案。

要求：

每个任务：

1. 独立完成
2. 独立测试
3. 独立提交

输出：

1. 任务编号与描述
2. 涉及文件
3. 依赖关系
4. 验收标准
5. 预计工作量
6. 风险评估（架构、安全、性能、数据、运维）
```

生成：

```text
.superpowers/plans/<功能名>/development-plan.md
```

---

# 第四阶段：执行开发

执行：

```text
/execute-plan <功能名>

一次调用，自动执行开发方案中的所有任务。

执行方式：

按任务顺序逐个执行，每个任务完成后自动进入下一个。

每个任务内部流程：

1. 完成编码
2. 运行测试
3. 自检代码质量
4. 标记任务完成
5. 输出变更说明
6. 自动进入下一个任务

暂停条件（仅在以下情况暂停）：

1. 任务描述不清，无法继续
2. 发现设计缺陷，需要调整方案
3. 测试失败且无法自行修复
4. 遇到阻塞性依赖

无问题则一口气执行全部任务。
```

生成：

```text
.superpowers/plans/<功能名>/execution-log.md
```

---

# 第五阶段：最终审查

执行：

```text
/review <功能名>

审查整个功能的实现。

检查：

1. 所有任务是否完成
2. 整体架构是否合理
3. 是否有遗漏的边界情况
4. 测试覆盖是否充分
5. 文档是否需要更新
```

生成：

```text
.superpowers/plans/<功能名>/review.md
```

---

# 完整流程图

```text
需求输入
    ↓
/brainstorm <功能名>          → requirements.md
    ↓
/brainstorm <功能名>          → technical-design.md
    ↓
/write-plan <功能名>          → development-plan.md
    ↓
/execute-plan <功能名>        → 任务1 → 任务2 → ... → 任务N（自动连续执行）
    ↓
/review <功能名>              → review.md
```

总计：5 次命令调用，完成整个功能开发。

---

# 完成标准

必须产出：

```text
.superpowers/plans/<功能名>/
├── requirements.md       # 需求分析
├── technical-design.md   # 技术方案
├── development-plan.md   # 开发方案
├── execution-log.md      # 执行日志
└── review.md             # 审查报告
```

全部完成后才允许合并到主分支。

---

# 快速参考

| 阶段 | 命令 | 产出物 | 说明 |
|------|------|--------|------|
| 需求分析 | `/brainstorm <功能名>` | requirements.md | 一次性完成需求+影响分析 |
| 技术设计 | `/brainstorm <功能名>` | technical-design.md | 一次性完成方案+数据库+接口 |
| 任务拆分 | `/write-plan <功能名>` | development-plan.md | 拆分任务+风险评估 |
| 执行开发 | `/execute-plan <功能名>` | execution-log.md | 一次调用，自动跑完全部任务 |
| 最终审查 | `/review <功能名>` | review.md | 整体代码审查 |

总命令数：5 次（与任务数量无关）
