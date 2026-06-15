# 项目审计标准流程（Superpowers版）

版本：v3.0

前置条件：

已完成项目知识库 `.superpowers/project/`。

确保项目根目录下已创建以下 skill：

```text
.claude/skills/
├── brainstorm/SKILL.md
├── write-plan/SKILL.md
└── review/SKILL.md
```

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

# 第一阶段：审计策略

执行：

```text
/brainstorm 审计策略

目标：

对整个项目制定审计策略。

要求：

不要修改代码。

输出：

1. 审计范围与优先级
2. 风险分类（Critical / High / Medium / Low）
3. 审计维度：
   - 代码质量（架构、可维护性、代码规范）
   - 安全（认证、授权、权限、输入校验、敏感数据）
   - 性能（SQL、缓存、并发、内存）
   - 风险（依赖、技术债、供应链）
4. 审计路线图

按照项目特点确定重点审计方向。
```

---

# 第二阶段：代码质量审计

执行：

```text
/review 代码质量审计

目标：

审计代码质量与架构设计。

不要修改代码。

检查：

1. 分层设计与模块边界
2. 循环依赖与服务耦合
3. 重复代码与超长函数
4. 命名规范与注释质量
5. 代码复杂度
6. 测试覆盖率
7. 架构一致性与扩展能力

输出：

每个问题标注风险等级：

Critical / High / Medium / Low
```

生成：

```text
.superpowers/audit/code-quality-audit.md
```

---

# 第三阶段：安全审计

执行：

```text
/review 安全审计

目标：

审计安全漏洞与权限体系。

不要修改代码。

检查：

身份与访问控制：
1. 登录流程与Token验证
2. Session管理与会话安全
3. RBAC / ABAC 权限模型
4. 接口权限、数据权限、菜单权限
5. 权限绕过与越权风险

输入输出安全：
1. 所有用户输入的校验
2. 输出编码防注入
3. SQL Injection / XSS / CSRF
4. Path Traversal / File Upload
5. XXE / SSRF

运行时安全：
1. RCE / Privilege Escalation
2. Authentication / Authorization Bypass
3. 密钥管理与加密实现

数据保护：
1. Hardcoded Secret
2. Sensitive Data Exposure
3. 日志安全（不记录敏感数据）

输出：

漏洞名称、风险等级、影响范围、触发路径、修复建议。
```

生成：

```text
.superpowers/audit/security-audit.md
```

---

# 第四阶段：性能审计

执行：

```text
/review 性能审计

目标：

审计性能瓶颈与资源使用。

不要修改代码。

检查：

1. SQL性能与索引设计
2. N+1查询与深分页
3. 缓存策略与Redis使用
4. 并发处理与异步任务
5. 内存占用与大对象创建
6. 网络请求与文件处理
7. MQ使用与消息积压
8. CPU热点与阻塞操作

输出：

每个问题标注：

影响范围、触发条件、优化建议、优先级。
```

生成：

```text
.superpowers/audit/performance-audit.md
```

---

# 第五阶段：风险审计

执行：

```text
/review 风险审计

目标：

审计依赖风险与技术债。

不要修改代码。

检查：

依赖风险：
1. 第三方库版本与维护状态
2. 高危依赖与安全漏洞
3. 许可证风险与供应链风险
4. 过期依赖与未维护依赖

技术债：
1. 技术债来源与积累原因
2. 风险等级与业务影响
3. 修复成本与优先级排序
4. 治理建议

输出：

每个风险标注：

来源、等级、影响、成本、优先级。
```

生成：

```text
.superpowers/audit/risk-audit.md
```

---

# 第六阶段：生成综合审计报告

执行：

```text
/write-plan 审计报告

汇总全部审计结果。

生成最终审计报告。

包含：

1. 项目风险概览
2. 代码质量风险
3. 安全风险
4. 性能风险
5. 依赖与技术债风险

按照 P0 / P1 / P2 / P3 进行排序。

给出治理路线图：

* P0：立即修复
* P1：优先修复
* P2：计划修复
* P3：记录即可
```

生成：

```text
.superpowers/audit/audit-report.md
```

---

# 完整流程图

```text
/brainstorm 审计策略            → 审计范围与路线图

/review 代码质量审计            → code-quality-audit.md
/review 安全审计                → security-audit.md
/review 性能审计                → performance-audit.md
/review 风险审计                → risk-audit.md

/write-plan 审计报告            → audit-report.md
```

总计：6 次命令调用。

---

# 完成标准

必须产出：

```text
.superpowers/audit/
├── code-quality-audit.md   # 代码质量审计（架构+可维护性）
├── security-audit.md       # 安全审计（安全+权限）
├── performance-audit.md    # 性能审计
├── risk-audit.md           # 风险审计（依赖+技术债）
└── audit-report.md         # 综合审计报告
```

全部完成后，禁止直接修改代码。

下一阶段进入：

```text
.superpowers/plans/
```

制定修复路线图和重构计划。

---

# 风险等级定义

## Critical

立即修复。可能导致：

* 数据泄露
* 权限绕过
* 远程执行
* 系统瘫痪

## High

优先修复。可能导致：

* 严重性能问题
* 核心业务风险
* 数据一致性问题

## Medium

计划修复。可能导致：

* 维护成本增加
* 扩展困难

## Low

记录即可。不影响当前运行。

---

# 快速参考

| 阶段 | 命令 | 产出物 | 说明 |
|------|------|--------|------|
| 审计策略 | `/brainstorm 审计策略` | - | 确定范围和重点 |
| 代码质量 | `/review 代码质量审计` | code-quality-audit.md | 架构+可维护性 |
| 安全 | `/review 安全审计` | security-audit.md | 安全+权限 |
| 性能 | `/review 性能审计` | performance-audit.md | SQL+缓存+并发 |
| 风险 | `/review 风险审计` | risk-audit.md | 依赖+技术债 |
| 综合报告 | `/write-plan 审计报告` | audit-report.md | 汇总+路线图 |

总命令数：6 次
