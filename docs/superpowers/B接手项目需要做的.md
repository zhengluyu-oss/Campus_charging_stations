# 接手项目标准流程（Superpowers版）

版本：v1.0

目标：

在不修改任何代码的前提下，利用 Superpowers 建立完整项目认知。

最终产出：

```text
.superpowers/project/
```

下的全部项目知识库文件。

---

# 第一阶段：初始化

执行：

```text
/superpowers:brainstorm

目标：

接手当前项目并建立完整认知。

要求：

1. 不允许修改任何代码
2. 不允许生成重构方案
3. 不允许修复问题
4. 不允许开发功能

仅允许：

分析
理解
归档

最终目标：

生成完整项目知识库。
```

---

# 第二阶段：项目全局扫描

执行：

```text
/superpowers:brainstorm

分析整个项目。

输出：

1. 技术栈
2. 项目规模
3. 目录结构
4. 核心模块
5. 主要依赖
6. 启动方式
7. 风险区域

生成：

.superpowers/project/overview.md
```

---

# 第三阶段：生成理解计划

执行：

```text
/superpowers:write-plan

根据项目扫描结果。

制定项目理解计划。

拆分以下阶段：

1. 启动流程分析
2. 架构分析
3. 模块分析
4. 业务流程分析
5. 接口体系分析
6. 数据库分析
7. 缓存分析
8. 基础设施分析
9. 部署架构分析

输出执行顺序。
```

---

# 第四阶段：分析启动流程

执行：

```text
/superpowers:execute-plan

执行：

启动流程分析

要求：

输出：

1. 项目入口
2. 配置加载流程
3. 初始化流程
4. 中间件流程
5. 路由注册流程
6. 生命周期

生成：

.superpowers/project/startup-flow.md
```

---

# 第五阶段：分析系统架构

执行：

```text
/superpowers:execute-plan

执行：

系统架构分析

输出：

1. 分层结构
2. 模块结构
3. 依赖结构
4. 调用结构
5. 扩展结构
6. 解耦结构

生成：

.superpowers/project/architecture.md
```

---

# 第六阶段：分析业务模块

执行：

```text
/superpowers:execute-plan

执行：

业务模块分析

输出：

1. 模块名称
2. 模块职责
3. 核心文件
4. 模块依赖
5. 数据来源
6. 数据去向

生成：

.superpowers/project/modules.md
```

---

# 第七阶段：分析业务流程

执行：

```text
/superpowers:execute-plan

执行：

业务流程分析

输出：

1. 用户流程
2. 请求流程
3. 数据流程
4. 状态流转
5. 异常流程

生成：

.superpowers/project/business-flow.md
```

---

# 第八阶段：分析接口体系

执行：

```text
/superpowers:execute-plan

执行：

接口体系分析

输出：

1. 接口分类
2. 权限体系
3. 请求结构
4. 响应结构
5. 错误处理机制

生成：

.superpowers/project/api-system.md
```

---

# 第九阶段：分析数据库

执行：

```text
/superpowers:execute-plan

执行：

数据库分析

输出：

1. 核心表
2. 表关系
3. 索引设计
4. 数据流向
5. 事务设计

生成：

.superpowers/project/database.md
```

---

# 第十阶段：分析缓存体系

执行：

```text
/superpowers:execute-plan

执行：

缓存体系分析

输出：

1. 缓存类型
2. 缓存结构
3. 缓存策略
4. 更新机制

生成：

.superpowers/project/cache.md
```

---

# 第十一阶段：分析基础设施

执行：

```text
/superpowers:execute-plan

执行：

基础设施分析

输出：

1. 数据库
2. Redis
3. MQ
4. 搜索引擎
5. 对象存储
6. 第三方服务

生成：

.superpowers/project/infrastructure.md
```

---

# 第十二阶段：分析部署架构

执行：

```text
/superpowers:execute-plan

执行：

部署架构分析

输出：

1. 环境划分
2. CI/CD流程
3. 部署方式
4. 服务拓扑
5. 网络结构

生成：

.superpowers/project/deployment.md
```

---

# 第十三阶段：生成项目知识库

执行：

```text
/superpowers:write-plan

整理全部分析结果。

生成最终项目知识库。

包含：

1. 项目概览
2. 技术栈
3. 架构设计
4. 模块设计
5. 业务流程
6. 数据体系
7. 基础设施
8. 部署体系
9. 风险区域
10. 学习路线

生成：

.superpowers/project/project-understanding.md
```

---

# 项目理解完成标准

必须能够回答：

1. 项目解决什么问题
2. 项目核心业务是什么
3. 请求如何流转
4. 数据如何流转
5. 模块如何协作
6. 数据库如何设计
7. 缓存如何工作
8. 项目如何部署
9. 项目如何扩展
10. 项目风险在哪里

达到以上标准后：

项目理解阶段结束。

允许进入：

```text
.superpowers/audit/
```

代码审计阶段。
