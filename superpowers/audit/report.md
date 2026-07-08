# 综合审计报告

## 审计概况

| 项目 | 内容 |
|------|------|
| **项目名称** | 校园充电桩管理系统 Campus Charging Stations |
| **审计时间** | 2026-07-08 |
| **审计范围** | 完整项目：后端（144 Java 文件）+ 前端（26 Vue/TS 文件）+ 数据库 + 配置 + 构建 |
| **审计方法** | 人工代码审查 + 架构分析 + 配置审计 |
| **总体评分** | **3.0 / 5.0**（中等偏上） |

---

## P0 — 立即修复（安全漏洞、数据泄露、系统崩溃）

### P0.1 充电计时使用 Thread.sleep() 非持久化机制

**类型**: 业务中断 / 数据泄露
**文件**: `user/.../ChargingAsyncService.java`
**严重度**: Critical

**问题**: `@Async` + `Thread.sleep()` 模拟充电计时。应用重启后所有计时丢失，充电桩状态**永远无法释放**。多实例部署时计时只运行在单节点。

**影响**: 充电桩状态永久卡死 → 无法使用 → 用户流失 + 订单收入损失

**修复**: 使用 Redis 延时队列 / 定时任务扫描超时订单 / 消息队列

**估时**: 8h

---

### P0.2 充电桩状态值不统一

**类型**: 业务逻辑错误
**文件**: `ChargingStationsMapper.xml` + `schema.sql`
**严重度**: Critical

**问题**: 数据库使用 `available/occupied/maintenance`（语义化字符串），但 XML Mapper 中写死 `status = 1`/`0`（数字）。两者完全不匹配，导致状态检查和更新逻辑混乱。

**影响**: 充电桩状态校验失效 → 可能并发占用 → 竞态条件

**修复**: 统一状态值为语义化字符串，清除脏数据

**估时**: 3h

---

### P0.3 Token 存储在 localStorage 存在 XSS 窃取风险

**类型**: 安全漏洞
**文件**: `admin-frontend/src/stores/admin.ts` + `request.ts`
**严重度**: Critical

**问题**: 前端 Token 通过 `pinia-plugin-persistedstate` 持久化到 `localStorage`，XSS 攻击可直接窃取。Token 有效期长达 10 小时（36000000ms）。

**影响**: 管理后台 Token 泄露 → 攻击者完全接管后台

**修复**: 使用 httpOnly Cookie + Refresh Token / 缩短 Token 有效期 / 使用 sessionStorage

**估时**: 4h

---

## P1 — 优先修复（严重性能瓶颈、核心业务风险）

### P1.1 缺少基于角色的访问控制（RBAC）

**类型**: 授权缺失
**文件**: `router/index.ts` + `LoginInterceptor.java`
**严重度**: High

**问题**: 路由守卫仅检查 Token 存在性，任何已认证用户可访问所有管理功能。后端拦截器也未校验权限。

**影响**: 低权限管理员越权操作

**修复**: 前端路由 `meta.roles` + 后端拦截器角色校验

**估时**: 8h

### P1.2 数据库缺少关键索引

**类型**: 性能瓶颈
**文件**: `schema.sql`、各 Mapper XML
**严重度**: High

**问题**: `orders.payment_status`、`orders.created_time`、`reservations.status`、`payments.payments_status`、`charging_stations.location` 等高频查询字段缺少索引。

**影响**: 数据量增长后全表扫描，查询延迟从毫秒级退化到秒级

**修复**: 添加 5 个关键索引

**估时**: 1h

### P1.3 自定义 Token Header 非标准

**类型**: 安全配置
**文件**: `request.ts` 第 57 行
**严重度**: High

**问题**: 使用自定义 Header `token` 而非标准 `Authorization: Bearer`。

**影响**: 与标准安全中间件/API 网关不兼容

**修复**: 改为标准 Header

**估时**: 0.5h

### P1.4 dev.yml 弱密码

**类型**: 安全配置
**文件**: `application-dev.yml`
**严重度**: High

**问题**: 开发环境数据库密码（123456）、Redis 密码（123456）、JWT 密钥均为弱配置。

**影响**: 开发环境横向渗透风险

**修复**: 加强密码或完全通过环境变量注入

**估时**: 0.5h

### P1.5 缺少 MyBatis-Plus 分页拦截器

**类型**: 功能异常
**文件**: 两个模块均未配置 `MybatisPlusInterceptor`
**严重度**: High

**问题**: 多 Service 使用 `new Page<>()` + `Mapper.selectPage()`，但未注册 `PaginationInnerInterceptor`。

**影响**: 分页查询可能返回全量数据

**修复**: 注册分页拦截器

**估时**: 0.5h

---

## P2 — 计划修复（代码质量、技术债）

### P2.1 CSS 和辅助函数大量重复

**类型**: 代码质量
**文件**: 7 个视图文件
**严重度**: Medium

**问题**: `glass-card`、`dark-table`、`particleStyle`、`formatTime`、`statusType` 等在 5-7 个文件中重复定义。

**影响**: 维护成本高，样式修改需改 7 个文件

**修复**: 提取公共样式文件 + 工具函数

**估时**: 3h

### P2.2 前端过度使用 `any` 类型

**类型**: 类型安全
**文件**: 所有视图的 `try/catch` 块
**严重度**: Medium

**问题**: 所有 API 调用使用 `const res: any = await request.post(...)` 跳过了类型检查。

**影响**: 运行时错误无法在编译时捕获

**修复**: 为每个 API 端点定义具体的响应类型

**估时**: 4h

### P2.3 ChargingStationController 与 ChargingPileController 重复

**类型**: 架构问题
**严重度**: Medium

**问题**: 两个 Controller 操作同一张表，提供几乎完全相同的 CRUD 接口。

**修复**: 合并为一个 Controller

**估时**: 2h

### P2.4 废弃前端组件（4 个）

**类型**: 代码清理
**文件**: `AdminHeader.vue`、`AdminSidebar.vue`、`AdminLayout.vue`、`HandParticleCanvas.vue`
**严重度**: Medium

**问题**: 4 个组件定义但未被任何文件使用。

**修复**: 删除或重构 App.vue 使用它们

**估时**: 1h

### P2.5 rolldown-vite 实验性构建工具

**类型**: 技术债
**文件**: 两个前端的 `package.json`
**严重度**: Medium

**问题**: 使用 `rolldown-vite`（实验性）替代官方 Vite。

**修复**: 回退到官方 Vite

**估时**: 1h

### P2.6 NewsManagement.vue 未完成

**类型**: 功能缺失
**严重度**: Medium

**问题**: 只有骨架视图，无数据获取和业务逻辑。

**修复**: 补全功能

**估时**: 3h

### P2.7 单元测试严重不足

**类型**: 测试覆盖
**严重度**: Medium

**问题**: 仅 2 个测试文件，覆盖 < 2%。

**修复**: 为核心模块编写测试

**估时**: 16h

### P2.8 Swagger 生产环境未关闭

**类型**: 配置风险
**文件**: `application.yml`
**严重度**: Medium

**问题**: `springdoc.api-docs.enabled: true` 允许生产环境访问 API 文档。

**修复**: 使用 profile 控制

**估时**: 0.5h

### P2.9 User 端 NewsController 无认证

**类型**: 认证缺失
**文件**: 两个模块的 `NewsController.java`
**严重度**: Medium

**问题**: Admin 和 User 模块的新闻接口功能重叠，存在认证缺失风险。

**修复**: 统一新闻接口管理

**估时**: 2h

---

## P3 — 记录观察（轻微规范问题）

| 编号 | 问题 | 文件 | 估时 |
|------|------|------|:----:|
| P3.1 | 密码前端明文传输 | `AdminLogin.vue` | 1h |
| P3.2 | 登录无速率限制 | `LoginController` | 2h |
| P3.3 | @mediapipe/hands 已归档待评估 | `package.json` | 1h |
| P3.4 | particleStyle 使用 Math.random() 重渲染 | 6 个视图 | 1h |
| P3.5 | Orders Entity 时间字段类型不一致（String vs LocalDateTime） | `Orders.java` | 1h |
| P3.6 | NewsManagement.vue 无数据逻辑 | `NewsManagement.vue` | — |

---

## 修复路线图

### 第一阶段 — 立即修复（1-2 天）

```
优先级: P0
目标:  堵住安全漏洞 + 修复关键业务逻辑
任务:
□ P0.1 充电桩状态值统一修复                     (3h)
□ P0.2 @Async Thread.sleep → 定时任务兜底      (8h)
□ P0.3 Token 存储方案升级（最低: sessionStorage + 缩短 TTL）(4h)
合计: ~15h (2 个工作日)
```

### 第二阶段 — 优先修复（3-5 天）

```
优先级: P1
目标:  解决性能瓶颈 + 完整权限控制
任务:
□ P1.1 RBAC 权限控制（前端路由 + 后端校验）     (8h)
□ P1.2 添加 5 个数据库缺失索引                  (1h)
□ P1.3 Token Header 标准化                     (0.5h)
□ P1.4 dev.yml 密码加固                        (0.5h)
□ P1.5 注册 MyBatis-Plus 分页拦截器             (0.5h)
合计: ~10.5h (1.5 个工作日)
```

### 第三阶段 — 计划修复（5-10 天）

```
优先级: P2
目标:  代码重构 + 测试覆盖 + 技术债清理
任务:
□ P2.1 CSS/函数提取到公共文件                   (3h)
□ P2.2 前端类型安全修复（any → 具体类型）       (4h)
□ P2.3 重复 Controller 合并                     (2h)
□ P2.4 废弃组件清理                             (1h)
□ P2.5 rolldown-vite → 官方 Vite               (1h)
□ P2.6 NewsManagement 补全                      (3h)
□ P2.7 核心模块单元测试                         (16h)
□ P2.8 Swagger 生产环境关闭                     (0.5h)
□ P2.9 新闻接口统一管理                         (2h)
合计: ~32.5h (4-5 个工作日)
```

### 第四阶段 — 持续改进

```
优先级: P3
目标:  代码美化 + 性能微优化
任务:
□ P3.1-P3.6 酌情安排
合计: ~6h (随时插空完成)
```

---

## 项目健康度评估

```
┌─────────────────────────────────────────────┐
│             项目健康度仪表盘                   │
├─────────────────────────────────────────────┤
│                                              │
│  架构设计    ████████░░░░  4.0/5.0  ★★★★☆  │
│  安全性      ██████░░░░░░  3.0/5.0  ★★★☆☆  │
│  性能        ██████░░░░░░  3.0/5.0  ★★★☆☆  │
│  代码质量    ██████░░░░░░  3.0/5.0  ★★★☆☆  │
│  测试覆盖    ██░░░░░░░░░░  1.0/5.0  ★★☆☆☆  │
│  技术债      ██████░░░░░░  2.8/5.0  ★★★☆☆  │
│                                              │
│  综合得分    ██████░░░░░░  3.0/5.0           │
│                                              │
└─────────────────────────────────────────────┘
```

## 关键结论

1. **安全基础尚可**：BCrypt 密码、JWT 校验、参数化 SQL、文件上传防护到位
2. **最大风险**：`@Async Thread.sleep` 充电计时（P0）和充电桩状态值不一致（P0）
3. **最紧迫改进**：Token 安全存储 + RBAC 权限控制
4. **最大质量债务**：CSS/函数大量重复 + 测试覆盖几乎为零
5. **建议优先解决 P0 问题**（约 2 天），再进入 P1 和 P2

**完成全部修复预计总工时：~60 小时（约 8-10 个工作日）**
