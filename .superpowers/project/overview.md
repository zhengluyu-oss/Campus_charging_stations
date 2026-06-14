# 校园充电桩管理系统 - 项目概览

版本：v1.0  
生成日期：2026-06-14  
状态：已完成

---

# 1. 项目简介

**项目名称**：校园充电桩管理系统（Campus Charging Stations）

**项目目标**：为校园用户提供便捷的充电桩查询、预约、充电及支付一体化服务。

**核心价值**：
- 用户端：充电桩查找、预约、充电、支付、个人中心
- 管理端：充电站管理、订单管理、用户管理、数据统计
- 鸿蒙端：移动端充电服务（开发中）

---

# 2. 技术栈

## 2.1 后端技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Spring Boot | 3.5.9 | 核心框架 |
| MyBatis-Plus | 3.5.15 | ORM 框架 |
| MySQL | 8.0 | 关系型数据库 |
| JDK | 17 | Java 运行环境 |
| JWT (jjwt) | 0.12.5 | 身份认证 |
| PageHelper | 2.1.1 | 分页插件 |
| Spring Data Redis | 3.5.9 | 缓存支持 |
| SpringDoc OpenAPI | 2.3.0 | API 文档 |
| Commons Lang3 | 3.20.0 | 工具类库 |
| Lombok | - | 代码简化 |

## 2.2 前端技术栈（用户端 + 管理端）

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue | 3.5.x | 核心框架 |
| TypeScript | ~5.9.x | 类型安全 |
| Vite | 7.2.5 (rolldown-vite) | 构建工具 |
| Element Plus | 2.13.x | UI 组件库 |
| Pinia | 3.0.x | 状态管理 |
| Axios | 1.x | HTTP 客户端 |
| Three.js | 0.172+ | 3D 粒子特效 |
| MediaPipe Hands | 0.4.x | 手部追踪 |
| Vue Router | 4.6.x | 路由管理 |

## 2.3 鸿蒙客户端技术栈

| 技术 | 用途 |
|------|------|
| ArkTS | 开发语言 |
| HarmonyOS | 移动端框架 |

---

# 3. 项目规模

## 3.1 代码统计

| 类别 | 数量 |
|------|------|
| **源代码文件总数** | 264 |
| **后端控制器** | 24 |
| **后端服务** | 39 |
| **后端实体类** | 8 |
| **前端用户端文件** | 30 |
| **前端管理端文件** | 18 |
| **数据库表** | 9 |

## 3.2 模块分布

| 模块 | 主要职责 | 文件数量 |
|------|----------|----------|
| backend/admin | 管理端 API | ~50 |
| backend/user | 用户端 API | ~50 |
| backend/common | 公共模块 | ~30 |
| frontend | 用户端前端 | 30 |
| admin-frontend | 管理端前端 | 18 |
| harmonyos | 鸿蒙客户端 | ~20 |

---

# 4. 目录结构

```
Campus_charging_stations/
│
├── backend/                          # 后端服务（Spring Boot 多模块）
│   ├── admin/                        # 管理端模块 (端口 8081)
│   │   └── src/main/java/com/tjetc/
│   │       ├── controller/          # 控制器层 (12个)
│   │       ├── service/             # 服务层
│   │       ├── interceptor/         # 拦截器
│   │       └── config/              # 配置类
│   │
│   ├── user/                         # 用户端模块 (端口 8080)
│   │   └── src/main/java/com/tjetc/
│   │       ├── controller/          # 控制器层 (12个)
│   │       ├── service/             # 服务层
│   │       └── interceptor/         # 拦截器
│   │
│   └── common/                       # 公共模块
│       └── src/main/java/com/tjetc/
│           ├── entity/              # 实体类 (8个)
│           ├── dao/                 # Mapper 接口
│           ├── dto/                 # 数据传输对象
│           ├── common/              # 工具类
│           └── resources/mapper/    # MyBatis XML (7个)
│
├── frontend/                         # 用户端前端 (端口 8888)
│   └── src/
│       ├── api/                     # API 接口 (5个)
│       ├── views/user/              # 页面视图 (12个)
│       ├── components/              # 组件 (5个)
│       ├── stores/                  # 状态管理
│       ├── router/                  # 路由配置
│       └── utils/                   # 工具函数
│
├── admin-frontend/                   # 管理端前端 (端口 9999)
│   └── src/
│       ├── api/                     # API 接口
│       ├── views/                   # 页面视图
│       └── components/              # 组件
│
├── harmonyos/                        # 鸿蒙客户端
│   └── entry/                       # 应用入口
│
├── docs/                            # 项目文档
│   └── 数据库.md.md                 # 数据库设计文档
│
├── openspec/                        # 规格文档
│   └── changes/archive/           # 历史变更记录
│
└── .superpowers/                    # 项目知识库（本目录）
    ├── project/                     # 项目理解文档
    ├── audit/                       # 审计报告
    ├── plans/                       # 计划文档
    ├── decisions/                   # 架构决策记录
    ├── prompts/                     # 提示词库
    └── reports/                     # 阶段性报告
```

---

# 5. 核心模块

## 5.1 业务模块

| 模块 | 功能 | 数据表 | 端口 |
|------|------|--------|------|
| **用户管理** | 注册、登录、个人信息 | users, admin | 8080/8081 |
| **充电站管理** | 站点查询、状态管理 | charging_stations | 8081 |
| **订单管理** | 创建、查询、状态更新 | orders | 8080/8081 |
| **支付管理** | 支付记录、退款 | payments | 8080/8081 |
| **预约管理** | 预约创建、取消 | reservations | 8080/8081 |
| **新闻管理** | 发布、分类、展示 | news | 8080/8081 |
| **系统日志** | 操作记录 | system_logs | 8081 |

## 5.2 技术模块

| 模块 | 职责 |
|------|------|
| **common** | 实体类、DTO、Mapper、工具类 |
| **admin** | 管理端 API、业务逻辑 |
| **user** | 用户端 API、业务逻辑 |
| **frontend** | 用户端 SPA |
| **admin-frontend** | 管理端 SPA |

---

# 6. 主要依赖

## 6.1 后端依赖

```xml
<!-- 核心框架 -->
Spring Boot 3.5.9

<!-- ORM -->
MyBatis-Plus 3.5.15

<!-- 数据库 -->
MySQL Connector/J

<!-- 缓存 -->
Spring Data Redis 3.5.9

<!-- 认证 -->
JJWT 0.12.5

<!-- 分页 -->
PageHelper 2.1.1

<!-- 工具类 -->
Commons Lang3 3.20.0

<!-- API 文档 -->
SpringDoc OpenAPI 2.3.0
```

## 6.2 前端依赖

```json
{
  "核心框架": "Vue 3.5.x",
  "UI 组件": "Element Plus 2.13.x",
  "状态管理": "Pinia 3.0.x",
  "HTTP 客户端": "Axios 1.x",
  "3D 渲染": "Three.js 0.172+",
  "手部追踪": "MediaPipe Hands 0.4.x",
  "构建工具": "Vite 7.2.5 (rolldown-vite)"
}
```

---

# 7. 启动方式

## 7.1 后端启动

```bash
# 1. 进入后端目录
cd backend

# 2. 清理并安装依赖
mvn clean install

# 3. 启动 user 模块（端口 8080）
cd user
mvn spring-boot:run
# 或者在 IDE 中运行 UserApplication.java

# 4. 启动 admin 模块（端口 8081）
cd ../admin
mvn spring-boot:run
# 或者在 IDE 中运行 AdminApplication.java
```

## 7.2 用户端前端启动

```bash
# 1. 进入前端目录
cd frontend

# 2. 安装依赖
npm install

# 3. 启动开发服务器（端口 8888）
npm run dev
```

## 7.3 管理端前端启动

```bash
# 1. 进入管理端前端目录
cd admin-frontend

# 2. 安装依赖
npm install

# 3. 启动开发服务器（端口 9999）
npm run dev
```

## 7.4 端口汇总

| 服务 | 端口 | 说明 |
|------|------|------|
| user API | 8080 | 用户端后端服务 |
| admin API | 8081 | 管理端后端服务 |
| frontend | 8888 | 用户端前端开发服务器 |
| admin-frontend | 9999 | 管理端前端开发服务器 |
| MySQL | 3306 | 数据库服务 |
| Redis | 6379 | 缓存服务 |

---

# 8. 风险区域

## 8.1 严重风险（需立即修复）

| 风险 | 描述 | 影响 |
|------|------|------|
| **死代码** | `selectByUsernameAndPassword` 仍存在于 Mapper | 安全混淆、潜在认证绕过 |
| **SQL 初始化脆弱性** | `data.sql` 的 `USE` 语句无错误处理 | 系统锁定风险 |
| **缺少外键约束** | orders/payments/reservations 表无 FOREIGN KEY | 数据完整性风险 |

## 8.2 中等风险（需计划修复）

| 风险 | 描述 | 影响 |
|------|------|------|
| **缺少测试覆盖** | 无单元测试和集成测试 | 回归风险高 |
| **硬编码默认凭据** | application.yml 中的默认密码 | 安全风险 |
| **@EnableAsync 无用** | admin 模块无 @Async 方法 | 代码误导 |
| **上传 API 不一致** | 部分上传函数未使用 FormData | 功能风险 |

## 8.3 低风险（可延后处理）

| 风险 | 描述 | 影响 |
|------|------|------|
| **密码比较非常量时间** | BCrypt 迁移路径使用 String.equals() | 理论安全风险 |
| **用户名枚举风险** | checkExistByUsername 公开暴露 | 信息泄露风险 |
| **UserContext null 处理** | JWT 无 userId 时仍放行 | 潜在 NPE |

---

# 9. 核心业务流程

## 9.1 用户充电流程

```
用户登录 → 查询充电站 → 选择充电桩 → 创建订单 → 支付 → 开始充电 → 结束充电 → 评价
```

## 9.2 预约充电流程

```
用户登录 → 查询可用充电桩 → 选择时间段 → 创建预约 → 确认预约 → 到店充电 → 完成
```

## 9.3 管理员操作流程

```
管理员登录 → 查看仪表盘 → 管理用户/充电站/订单 → 处理退款 → 查看日志
```

---

# 10. 数据流向

## 10.1 前端 → 后端

```
Vue Component → API Layer (axios) → HTTP Request → Controller → Service → DAO → MySQL
```

## 10.2 后端 → 前端

```
MySQL → DAO → Service → Controller → HTTP Response → axios interceptor → Store → Component
```

## 10.3 认证流程

```
登录请求 → Controller → Service (BCrypt验证) → 生成JWT → 返回Token
后续请求 → 拦截器验证Token → 解析用户信息 → 放行/拒绝
```

---

# 11. 学习路线

## 11.1 新手入门（1-2天）

1. 阅读 `readme.md` 了解项目概览
2. 阅读本文档了解技术栈和架构
3. 搭建开发环境（JDK 17、Node.js、MySQL、Redis）
4. 启动后端和前端服务
5. 浏览主要页面和功能

## 11.2 深入理解（3-5天）

1. 阅读 `docs/数据库.md.md` 了解数据库设计
2. 阅读 `.superpowers/project/architecture.md` 了解系统架构
3. 阅读 `.superpowers/project/modules.md` 了解模块划分
4. 阅读 `.superpowers/project/business-flow.md` 了解业务流程

## 11.3 开发准备（1周）

1. 阅读 `.superpowers/audit/audit-report.md` 了解项目风险
2. 阅读 `.superpowers/plans/tech-debt.md` 了解技术债
3. 熟悉代码规范和开发流程
4. 尝试修复简单问题或添加小功能

---

# 12. 相关文档

| 文档 | 路径 | 说明 |
|------|------|------|
| 项目架构 | `.superpowers/project/architecture.md` | 系统架构设计 |
| 模块说明 | `.superpowers/project/modules.md` | 模块详细说明 |
| 业务流程 | `.superpowers/project/business-flow.md` | 业务流程详解 |
| 接口体系 | `.superpowers/project/api-system.md` | API 接口文档 |
| 数据库设计 | `docs/数据库.md.md` | 数据库表结构 |
| 审计报告 | `.superpowers/audit/audit-report.md` | 代码审计结果 |
| 技术债清单 | `.superpowers/plans/tech-debt.md` | 技术债治理计划 |

---

# 13. 快速参考

## 13.1 常用命令

```bash
# 后端编译
cd backend && mvn clean compile

# 后端测试
cd backend && mvn test

# 前端构建
cd frontend && npm run build

# 管理端构建
cd admin-frontend && npm run build
```

## 13.2 配置文件位置

| 配置 | 路径 |
|------|------|
| 后端配置（admin） | `backend/admin/src/main/resources/application.yml` |
| 后端配置（user） | `backend/user/src/main/resources/application.yml` |
| 数据库初始化 | `backend/common/src/main/resources/schema.sql` |
| 初始数据 | `backend/common/src/main/resources/data.sql` |
| 前端配置 | `frontend/vite.config.ts` |
| 管理端配置 | `admin-frontend/vite.config.ts` |

## 13.3 关键类文件

| 类 | 路径 | 职责 |
|------|------|------|
| AdminApplication | `backend/admin/src/.../AdminApplication.java` | 管理端启动类 |
| UserApplication | `backend/user/src/.../UserApplication.java` | 用户端启动类 |
| LoginInterceptor | `backend/admin/src/.../LoginInterceptor.java` | 登录拦截器 |
| FileUploadUtils | `backend/common/src/.../FileUploadUtils.java` | 文件上传工具 |
| JwtTokenUtil | `backend/common/src/.../JwtTokenUtil.java` | JWT 工具类 |

---

# 版本历史

| 版本 | 日期 | 说明 |
|------|------|------|
| v1.0 | 2026-06-14 | 初始版本，完成项目概览文档 |
