# 接手项目标准流程（Superpowers版）

版本：v3.0

目标：

在不修改任何代码的前提下，利用 Superpowers 建立完整项目认知。

最终产出：

```text
.superpowers/project/
```

下的全部项目知识库文件。

禁止：

* 修改任何代码
* 生成重构方案
* 修复问题
* 开发功能

仅允许：

分析、理解、归档。

---

# 前置条件

确保项目根目录下已创建以下 skill：

```text
.claude/skills/
├── brainstorm/SKILL.md
└── review/SKILL.md
```

检查是否已有项目知识库 `.superpowers/project/`，如果已有部分文件，后续阶段应在此基础上补充，而非从零开始。

---

# 第一阶段：全局扫描与架构分析

执行：

```text
/brainstorm 项目全局扫描

目标：

建立项目整体认知。

要求：

1. 不允许修改任何代码
2. 仅进行分析和归档

输出：

1. 技术栈与项目规模
2. 目录结构与核心模块
3. 主要依赖与启动方式
4. 分层架构与模块依赖关系
5. 调用链路与解耦方式
6. 风险区域

生成：

.superpowers/project/overview.md
.superpowers/project/architecture.md
```

---

# 第二阶段：模块与业务分析

执行：

```text
/brainstorm 模块与业务分析

目标：

深入理解业务模块和核心流程。

要求：

基于第一阶段结果继续分析。

输出：

1. 每个模块的职责、核心文件、依赖关系
2. 核心业务流程（用户流程、请求流程、数据流程）
3. 状态流转与异常处理
4. 接口分类与权限体系
5. 请求/响应结构与错误处理机制

生成：

.superpowers/project/modules.md
.superpowers/project/business-flow.md
.superpowers/project/api-system.md
```

---

# 第三阶段：数据与基础设施分析

执行：

```text
/brainstorm 数据与基础设施分析

目标：

理解数据层和基础设施。

要求：

基于前两阶段结果继续分析。

输出：

1. 核心表结构与表关系
2. 索引设计与数据流向
3. 缓存类型、策略与更新机制
4. 数据库、Redis、MQ 等基础设施
5. 第三方服务依赖
6. 部署架构（环境划分、CI/CD、服务拓扑）

生成：

.superpowers/project/database.md
.superpowers/project/infrastructure.md
```

---

# 第四阶段：知识库验证

执行：

```text
/review 项目知识库验证

目标：

验证项目知识库的完整性和准确性。

检查：

文件完整性：
1. 所有必要文件是否已生成
2. 文件内容是否覆盖项目核心要素
3. 是否存在遗漏的关键模块或流程
4. 技术栈、架构、接口描述是否与实际代码一致
5. 风险区域是否已完整识别

理解深度（知识库必须能够回答）：
6. 项目解决什么问题
7. 项目核心业务是什么
8. 请求如何流转
9. 数据如何流转
10. 模块如何协作
11. 数据库如何设计
12. 缓存如何工作
13. 项目如何部署
14. 项目如何扩展
15. 项目风险在哪里

输出：

验证结果与补充建议。
```

---

# 完整流程图

```text
/brainstorm 项目全局扫描
    ↓
overview.md + architecture.md

/brainstorm 模块与业务分析
    ↓
modules.md + business-flow.md + api-system.md

/brainstorm 数据与基础设施分析
    ↓
database.md + infrastructure.md

/review 项目知识库验证
    ↓
验证通过 → 进入代码审计阶段
```

---

# 完成标准

必须产出：

```text
.superpowers/project/
├── overview.md            # 项目概览（技术栈、规模、目录、依赖、启动方式）
├── architecture.md        # 系统架构（分层、模块依赖、调用链路）
├── modules.md             # 模块详解（职责、核心文件、数据流向）
├── business-flow.md       # 业务流程（用户流程、状态流转、异常处理）
├── api-system.md          # 接口体系（分类、权限、请求响应、错误处理）
└── infrastructure.md      # 数据与基础设施（数据库、缓存、部署）
```

验证通过后，允许进入：

```text
.superpowers/audit/
```

代码审计阶段。

---

# 快速参考

| 阶段 | 命令 | 产出物 |
|------|------|--------|
| 全局扫描 | `/brainstorm 项目全局扫描` | overview.md, architecture.md |
| 模块业务 | `/brainstorm 模块与业务分析` | modules.md, business-flow.md, api-system.md |
| 数据设施 | `/brainstorm 数据与基础设施分析` | database.md, infrastructure.md |
| 验证 | `/review 项目知识库验证` | 验证结果 |
