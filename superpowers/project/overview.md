# 项目全景与启动手册

## 基本信息

| 项目 | 内容 |
|------|------|
| **项目名称** | 校园充电桩管理系统 (Campus Charging Stations) |
| **仓库路径** | `F:\guochuang\my_project\Campus_charging_stations` |
| **一句话描述** | 为校园用户提供充电桩查询、预约、充电及支付一体化的多端管理平台 |
| **目标用户** | 校园师生（用户端）+ 系统管理员（管理端） |
| **成熟度** | 功能开发中（有完整的核心功能、积分商城正在开发、鸿蒙端功能完善中） |

## 技术栈全景

### 后端 (Backend)

| 技术 | 版本 | 用途 |
|------|------|------|
| Java | 17 | 编程语言 |
| Spring Boot | 3.5.9 | 主框架 |
| MyBatis-Plus | 3.5.15 | ORM 框架 |
| PageHelper | 2.1.1 | 分页插件 |
| MySQL | 8.0 | 关系型数据库 |
| Redis | - | 缓存 + 充电计时持久化 |
| JWT (jjwt) | 0.12.5 | 身份认证 Token |
| SpringDoc OpenAPI | 2.3.0 | API 文档 (Swagger UI) |
| Lombok | - | 代码简化 |
| Commons-Lang3 | 3.20.0 | 工具类 |
| Spring Security Crypto | - | 密码加密 (BCrypt) |
| Maven | - | 构建工具 |

### 用户端前端 (User Frontend)

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue | 3.5.24 | 前端框架 |
| TypeScript | 5.9.3 | 类型系统 |
| Vite (Rolldown) | 7.2.5 | 构建工具 |
| Vue Router | 4.6.4 | 路由管理 |
| Pinia | 3.0.4 | 状态管理 + 持久化 |
| Axios | 1.13.2 | HTTP 客户端 |
| Element Plus | 2.13.1 | UI 组件库 |
| Three.js | 0.172.0 | 3D 粒子特效 |
| MediaPipe Hands | 0.4 | 手部追踪交互 |
| qs | 6.14.1 | URL 参数序列化 |

### 管理端前端 (Admin Frontend)

| 技术 | 版本 | 用途 |
|------|------|------|
| Vue | 3.5.16 | 前端框架 |
| TypeScript | 5.9.0 | 类型系统 |
| Vite (Rolldown) | 7.2.5 | 构建工具 |
| Vue Router | 4.6.2 | 路由管理 |
| Pinia | 3.0.2 | 状态管理 + 持久化 |
| Axios | 1.9.0 | HTTP 客户端 |
| Element Plus | 2.13.0 | UI 组件库 |
| Three.js | 0.175.0 | 3D 粒子特效 |
| MediaPipe Hands | 0.4 | 手部追踪 |
| qs | 6.14.0 | URL 参数序列化 |

### 鸿蒙客户端 (HarmonyOS)

| 技术 | 用途 |
|------|------|
| ArkTS | 应用开发语言 |
| @ohos/axios | HTTP 客户端 |
| HarmonyOS API | 原生能力调用 |

## 仓库目录结构

```
Campus_charging_stations/
├── backend/                         # 后端 Maven 多模块项目
│   ├── pom.xml                      # 父 POM（统一依赖管理）
│   ├── common/                      # 公共模块（entity、mapper、DTO、工具类）
│   │   ├── src/main/java/com/tjetc/
│   │   │   ├── common/              # 公共工具类（JsonResult、JwtTokenUtil、PasswordUtils 等）
│   │   │   ├── config/              # 公共配置（JWT 初始化、密码编码器）
│   │   │   ├── dao/                 # MyBatis-Plus Mapper 接口
│   │   │   ├── dto/                 # 数据传输对象（~50 个）
│   │   │   └── entity/              # 实体类
│   │   │       ├── core/            # 核心实体（Orders、ChargingStation、Reservation 等）
│   │   │       └── userAndAdmin/    # 用户和管理员实体
│   │   └── src/main/resources/mapper/ # XML Mapper 文件
│   ├── admin/                       # 管理端 API（端口 8081，context-path: /admin）
│   │   ├── src/main/java/com/tjetc/
│   │   │   ├── config/              # 拦截器配置
│   │   │   ├── controller/          # 管理端控制器
│   │   │   ├── interceptor/         # 登录拦截器（Token 验证）
│   │   │   └── service/             # 服务层接口+实现
│   │   └── src/main/resources/
│   │       ├── application.yml      # 主配置（DB、Redis、JWT、文件上传）
│   │       └── application-dev.yml  # 开发环境配置
│   └── user/                        # 用户端 API（端口 8080）
│       ├── src/main/java/com/tjetc/
│       │   ├── config/              # 拦截器、Redis、Swagger 配置
│       │   ├── controller/          # 用户端控制器（按功能分包）
│       │   │   ├── charge/          # 充电监控
│       │   │   ├── CoreFunctionController/ # 核心功能（查询、使用、预约、订单）
│       │   │   ├── news/            # 新闻
│       │   │   └── userFunctionController/ # 用户功能（登录、注册、信息管理）
│       │   ├── interceptor/         # 登录拦截器
│       │   └── service/             # 服务层
│       │       ├── Impl/            # 服务实现
│       │       └── service/         # 服务接口
│       └── src/main/resources/
│           ├── application.yml      # 主配置
│           └── application-dev.yml  # 开发配置
├── frontend/                        # 用户端前端（Vue 3，端口 8888）
│   ├── src/
│   │   ├── api/                     # API 调用层（user.ts、charging.ts、news.ts、upload.ts）
│   │   ├── assets/                  # 静态资源
│   │   ├── components/              # 公共组件（Header、Footer、Particle Canvas 等）
│   │   ├── router/                  # Vue Router 路由配置
│   │   ├── stores/                  # Pinia 状态管理
│   │   ├── utils/                   # 工具类（axios 封装 request.ts）
│   │   ├── viewmodel/               # 视图模型类型定义
│   │   └── views/                   # 页面视图（welcome、user/ 目录下 12 个页面）
│   └── vite.config.ts               # Vite 配置（代理到 8080）
├── admin-frontend/                  # 管理端前端（Vue 3，端口 9999）
│   ├── src/
│   │   ├── components/              # 公共组件（侧边栏、头部、粒子 canvas）
│   │   ├── layouts/                 # 布局组件
│   │   ├── router/                  # 路由配置
│   │   ├── stores/                  # Pinia 状态管理（admin）
│   │   ├── utils/                   # axios 封装（含 Token 自动刷新）
│   │   └── views/                   # 8 个管理页面
│   └── vite.config.ts               # Vite 配置（代理到 8081）
├── harmonyos/                       # 鸿蒙客户端（ArkTS）
│   ├── AppScope/                    # 应用配置
│   ├── entry/src/main/ets/          # 主入口
│   │   ├── apis/                    # API 接口（ReservationApi、UserApi、UploadImageApi）
│   │   ├── entryability/            # Ability 定义
│   │   ├── goods-shop/              # 积分商城模块（含首页、分类、订单、我的）
│   │   └── pages/                   # 页面
│   └── build-profile.json5          # 构建配置
├── docs/                            # 文档
│   └── 数据库.md.md                 # 数据库建表语句 + 初始数据（全文 16 张表）
├── openspec/                        # OpenSpec 工作流配置
│   ├── config.yaml                  # 工作流配置
│   └── changes/                     # 变更记录
├── superpowers/                     # 项目认知文档目录
│   ├── project/                     # 本项目文件目录
│   └── audit/                       # 审计记录
├── .env.example                     # 环境变量模板
├── readme.md                        # 项目 README
└── package.json                     # 根包配置（dompurify 依赖）
```

## 子模块说明

### 1. backend — 后端服务（Spring Boot 多模块 Maven 项目）

| 模块 | 端口 | 服务路径 | 职能 |
|------|------|----------|------|
| `user` | 8080 | - | 用户端 API：充电桩查询、预约、充电、订单、登录注册、新闻 |
| `admin` | 8081 | `/admin` | 管理端 API：充电桩管理、订单管理、用户管理、管理员管理、支付、预约、新闻 |
| `common` | - | - | 公共模块：实体类、DTO、Mapper 接口、工具类（JWT、文件上传、密码加密） |

### 2. frontend — 用户端前端（端口 8888）

用户端 SPA，12 个页面，覆盖充电全流程。

### 3. admin-frontend — 管理员端前端（端口 9999）

管理后台 SPA，8 个管理页面。**特色：含 Token 自动刷新机制**。

### 4. harmonyos — 鸿蒙客户端

基于 ArkTS 的移动端应用，含积分商城模块（商品浏览、订单管理、红包卡券）。

## 本地启动手册

### 前置条件

- JDK 17+
- Maven 3.9+
- Node.js 18+
- MySQL 8.0+（数据库名 `campus_charging_station`）
- Redis 6.0+
- HarmonyOS SDK（可选，仅在开发鸿蒙端时需要）

### 数据库准备

```sql
-- 执行建表语句
source docs/数据库.md.md
```

或复制 `docs/数据库.md.md` 中的 SQL 到 MySQL 客户端执行。

### 环境变量配置

复制 `.env.example` 为 `.env` 或在系统环境变量中设置：

```bash
DB_USERNAME=root
DB_PASSWORD=your_password
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password
JWT_SECRET=your_jwt_secret_at_least_32_bytes
FILE_UPLOAD_PATH=D:/uploads
FILE_BASE_PATH=D:/uploads
LOG_PATH=D:/logs/app.log
```

### 后端启动

```bash
cd backend
mvn clean install -DskipTests

# 启动 user 模块（端口 8080）
cd user
mvn spring-boot:run

# 另开终端启动 admin 模块（端口 8081）
cd admin
mvn spring-boot:run
```

### 用户端前端启动

```bash
cd frontend
npm install
npm run dev    # 访问 http://localhost:8888
```

### 管理员端前端启动

```bash
cd admin-frontend
npm install
npm run dev    # 访问 http://localhost:9999
```

### 默认账号

**用户端：**
- 用户名：`郑陆宇` / 密码：`123456`（学生）
- 用户名：`张三东风` / 密码：`123456`
- 用户名：`老马是式` / 密码：`123456`（教师）

**管理端：**
- 用户名：`郑陆宇` / 密码：`123456`
- 用户名：`admin2` / 密码：`123456`
- 用户名：`admin3` / 密码：`123456`

## 环境变量与配置项

| 配置项 | 默认值 | 含义 | 来源文件 |
|--------|--------|------|----------|
| `DB_USERNAME` | `root` | 数据库用户名 | `backend/*/application.yml` |
| `DB_PASSWORD` | — | 数据库密码 | `backend/*/application.yml` |
| `REDIS_HOST` | `127.0.0.1` | Redis 主机 | `backend/*/application.yml` |
| `REDIS_PORT` | `6379` | Redis 端口 | `backend/*/application.yml` |
| `REDIS_PASSWORD` | — | Redis 密码 | `backend/*/application.yml` |
| `REDIS_DATABASE` | `1` (admin) / `3` (user) | Redis 数据库编号 | `backend/*/application.yml` |
| `JWT_SECRET` | — | JWT 签名密钥（≥32字节） | `backend/*/application.yml` |
| `JWT_TOKEN_EXPIRED` | `1800000` (30分钟) | Access Token 过期时间(ms) | `backend/*/application.yml` |
| `FILE_UPLOAD_PATH` | `F:\guochuang\...` | 文件上传存储路径 | `backend/*/application.yml` |
| `FILE_BASE_PATH` | `D:/temp` / `F:\guochuang\...` | 文件基路径 | `backend/*/application.yml` |
| `LOG_PATH` | `D:/temp/mylog.log` | 日志文件路径 | `backend/*/application.yml` |
| `spring.sql.init.mode` | `always` | 数据库自动初始化模式 | `backend/*/application.yml` |

## 外部依赖服务

| 依赖 | 用途 | 连接方式 | 配置位置 |
|------|------|----------|----------|
| MySQL `campus_charging_station` | 业务数据存储 | JDBC 连接 | `backend/*/application.yml` |
| Redis (database 1/3) | 充电计时持久化、可扩展缓存 | Jedis/Lettuce | `backend/*/application.yml` |
| MediaPipe CDN | 手部追踪模型 | 页面 CDN 加载 | 前端 `index.html` |
| SpringDoc OpenAPI | API 文档 | 内嵌 Swagger UI | `http://localhost:8080/swagger-ui.html` |

## 规模与复杂度粗估

| 指标 | 数量 |
|------|------|
| Java 代码文件数 | ~80 (entity 8 + dto ~50 + controller 16 + service 15 + mapper 8 + util 6 + config 4) |
| Vue 组件/页面数 | 用户端 12 个页面 + 6 个组件 + 管理端 8 个页面 + 3 个组件 + 1 个布局 |
| 鸿蒙 .ets 文件数 | 442 个（含完整的积分商城子系统） |
| 数据库表数 | 16 张（核心 7 张 + 积分商城 9 张） |
| API 接口数 | ~60 个（user 端 ~20 + admin 端 ~40） |
| Maven 模块数 | 3 个 |

## 文档与规范索引

| 文档 | 位置 | 说明 |
|------|------|------|
| 数据库建表 | `docs/数据库.md.md` | 16 张表的 SQL 建表语句与初始数据 |
| OpenSpec 工作流 | `openspec/config.yaml` | OpenSpec 模式工作流配置 |
| OpenSpec 变更 | `openspec/changes/` | 变更记录目录 |
| 项目 README | `readme.md` | 项目概览与快速启动 |
| 后端 README | `backend/readme.md` | 后端说明 |
| .env 模板 | `.env.example` | 环境变量配置模板 |
| 项目认知文档 | `superpowers/project/` | 本系列文档 |

> 来源：根目录目录结构、各模块 pom.xml/package.json、readme.md（`readme.md:1-104`）
