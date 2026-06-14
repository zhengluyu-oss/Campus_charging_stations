# 项目审计标准流程（Superpowers版）

版本：v1.0

前置条件：

```text
.superpowers/project/project-understanding.md
```

已经完成。

禁止：

* 直接修复漏洞
* 直接修改代码
* 直接重构

允许：

* 分析
* 审计
* 归档
* 风险评估

最终产出：

```text
.superpowers/audit/
```

---

# 第一阶段：建立审计计划

执行：

```text
/superpowers:brainstorm

目标：

对整个项目进行全面审计。

要求：

不要修改代码。

输出：

1. 审计范围
2. 风险分类
3. 审计优先级
4. 审计路线图

按照以下维度：

- 架构
- 安全
- 性能
- 可维护性
- 依赖风险
- 技术债

制定审计策略。
```

---

# 第二阶段：生成审计任务

执行：

```text
/superpowers:write-plan

根据审计策略。

生成完整审计计划。

拆分：

1. 架构审计
2. 安全审计
3. 性能审计
4. 可维护性审计
5. 依赖审计
6. 技术债审计

每个阶段独立执行。
```

---

# 第三阶段：架构审计

执行：

```text
/superpowers:review

执行架构审计。

不要修改代码。

检查：

1. 分层设计
2. 模块边界
3. 循环依赖
4. 服务耦合
5. 单一职责
6. 扩展能力
7. 插件机制
8. 领域划分
9. 架构一致性
10. 技术选型合理性

输出：

Critical
High
Medium
Low

风险等级。
```

生成：

```text
.superpowers/audit/architecture-audit.md
```

---

# 第四阶段：安全审计

执行：

```text
/superpowers:review

执行安全审计。

不要修改代码。

检查：

认证体系
授权体系
权限体系
输入校验
输出编码
日志安全
配置安全
文件处理
网络请求
第三方服务
敏感数据处理
加密实现
密钥管理
会话管理
访问控制
```

重点识别：

```text
SQL Injection
XSS
CSRF
SSRF
RCE
XXE
Path Traversal
File Upload
Privilege Escalation
Authentication Bypass
Authorization Bypass
Hardcoded Secret
Sensitive Data Exposure
```

输出：

漏洞名称
风险等级
影响范围
触发路径
修复建议

````

生成：

```text
.superpowers/audit/security-audit.md
````

---

# 第五阶段：权限审计

执行：

```text
/superpowers:review

执行权限审计。

不要修改代码。

检查：

1. 登录流程
2. Token验证
3. Session管理
4. RBAC
5. ABAC
6. 接口权限
7. 菜单权限
8. 数据权限
9. 超级管理员权限
10. 权限绕过风险
```

生成：

```text
.superpowers/audit/permission-audit.md
```

---

# 第六阶段：性能审计

执行：

```text
/superpowers:review

执行性能审计。

不要修改代码。

检查：

1. SQL性能
2. 索引设计
3. 缓存策略
4. Redis使用
5. MQ使用
6. 网络请求
7. 内存占用
8. CPU热点
9. 大对象创建
10. 并发处理
11. 异步任务
12. 文件处理
13. 深分页
14. N+1查询
```

生成：

```text
.superpowers/audit/performance-audit.md
```

---

# 第七阶段：可维护性审计

执行：

```text
/superpowers:review

执行可维护性审计。

不要修改代码。

检查：

1. 重复代码
2. 超长函数
3. 超长类
4. 命名规范
5. 目录结构
6. 代码复杂度
7. 模块边界
8. 注释质量
9. 测试覆盖率
10. 技术债
```

生成：

```text
.superpowers/audit/maintainability-audit.md
```

---

# 第八阶段：依赖风险审计

执行：

```text
/superpowers:review

执行依赖审计。

不要修改代码。

检查：

1. 第三方库
2. 过期依赖
3. 未维护依赖
4. 高危依赖
5. 许可证风险
6. 供应链风险
```

生成：

```text
.superpowers/audit/dependency-audit.md
```

---

# 第九阶段：技术债审计

执行：

```text
/superpowers:brainstorm

分析技术债。

输出：

1. 技术债来源
2. 风险等级
3. 修复成本
4. 业务影响
5. 优先级排序
```

生成：

```text
.superpowers/audit/tech-debt-audit.md
```

---

# 第十阶段：生成综合审计报告

执行：

```text
/superpowers:write-plan

汇总全部审计结果。

生成最终审计报告。

包含：

1. 项目风险概览
2. 架构风险
3. 安全风险
4. 权限风险
5. 性能风险
6. 可维护性风险
7. 依赖风险
8. 技术债分析

按照：

P0
P1
P2
P3

进行排序。

给出治理路线图。
```

生成：

```text
.superpowers/audit/audit-report.md
```

---

# 风险等级定义

## Critical

立即修复。

可能导致：

* 数据泄露
* 权限绕过
* 远程执行
* 系统瘫痪

---

## High

优先修复。

可能导致：

* 严重性能问题
* 核心业务风险
* 数据一致性问题

---

## Medium

计划修复。

可能导致：

* 维护成本增加
* 扩展困难

---

## Low

记录即可。

不影响当前运行。

---

# 审计完成标准

必须产出：

```text
.superpowers/audit

architecture-audit.md
security-audit.md
permission-audit.md
performance-audit.md
maintainability-audit.md
dependency-audit.md
tech-debt-audit.md
audit-report.md
```

全部完成后：

禁止直接修改代码。

下一阶段进入：

```text
.superpowers/plans/
```

制定修复路线图和重构计划。
