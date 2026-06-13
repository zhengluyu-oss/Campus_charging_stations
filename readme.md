# 校园充电桩管理系统

校园充电桩管理平台，为校园用户提供便捷的充电桩查询、预约、充电及支付一体化服务。

## 项目结构

```
Campus_charging_stations/
├── backend/          后端服务（Spring Boot 3.5.9 + MyBatis-Plus + MySQL）
├── frontend/         用户端前端（Vue 3 + TypeScript + Vite）
├── admin-frontend/   管理员端前端（Vue 3 + TypeScript + Vite + 手部追踪粒子特效）
├── harmonyos/        鸿蒙客户端（ArkTS）
└── docs/             项目文档
```

## 各模块说明

### backend - 后端服务

Spring Boot 多模块 Maven 项目，包含三个子模块：

| 模块 | 端口 | 说明 |
|------|------|------|
| `user` | 8080 | 用户端 API，提供充电桩查询、预约、充电订单、积分商城、个人信息等服务 |
| `admin` | 8081 | 管理端 API，提供充电桩管理、订单管理、用户管理、营销管理等后台功能 |
| `common` | - | 公共模块，包含实体类、DTO、Mapper、工具类等 |

技术栈：Spring Boot 3.5.9 / MyBatis-Plus 3.5.15 / MySQL 8.0 / JWT / PageHelper / JDK 17

### frontend - 用户端前端

Vue 3 + TypeScript + Vite 构建的用户端单页应用，通过 API 调用后端 `user` 模块（端口 8080）。

**特色功能：手部追踪粒子特效**
- 3000 个 Three.js 粒子，自定义着色器 + 发光效果
- MediaPipe Hands 实时手部追踪（双手支持）
- 手指吸引、捏合爆炸、手指展开螺旋轨道
- 手部移动轨迹粒子
- 右下角摄像头开关按钮，权限拒绝时优雅降级

### admin-frontend - 管理员端前端

Vue 3 + TypeScript + Vite 构建的管理员后台，通过 API 调用后端 `admin` 模块（端口 8081）。

**管理页面：**
- 仪表盘（数据总览、快捷操作）
- 用户管理（增删改查、搜索筛选）
- 充电站管理（卡片式展示、状态切换）
- 订单管理（筛选、详情、导出）
- 支付管理（退款操作）
- 预约管理（确认/取消）
- 新闻管理（发布、编辑、分类）
- 系统设置（管理员信息、密码修改）

**同样包含手部追踪粒子特效**，与用户端共享相同的视觉风格。

### harmonyos - 鸿蒙客户端

HarmonyOS（ArkTS）移动端应用，功能包括：
- 充电站搜索与导航
- 电池健康监测
- 预约充电、订单管理
- 积分商城、优惠券、红包
- 故障报修、个人中心

### docs - 项目文档

- `数据库.md.txt`：MySQL 数据库建表语句（16 张表）及初始数据

## 快速启动

### 后端
```bash
cd backend
mvn clean install
# 启动 user 模块（端口 8080）
# 启动 admin 模块（端口 8081）
```

### 用户端前端
```bash
cd frontend
npm install
npm run dev    # 端口 8888
```

### 管理员端前端
```bash
cd admin-frontend
npm install
npm run dev    # 端口 9999
```

## 数据库

数据库名：`campus_charging_station`，共 16 张表，覆盖用户管理、充电站、订单、支付、预约、积分、优惠券、红包、商城等功能。详见 `docs/数据库.md.txt`。

## 视觉风格

所有前端项目共享统一的暗色玻璃拟态（Glassmorphism）主题：
- 背景渐变：`#0f2027 → #203a43 → #2c5364`
- 卡片：`rgba(255,255,255,0.08)` + `backdrop-filter: blur(12px)`
- 强调色：`#00c9ff → #92fe9d`（青色到薄荷绿渐变）
- Three.js 粒子背景 + MediaPipe 手部追踪交互
