# 代码质量审计报告

## 1. 总体评分

| 维度 | 评分 | 说明 |
|------|------|------|
| 分层设计 | ⭐⭐⭐⭐☆ | 模块边界清晰，Controller→Service→DAO 分层明确 |
| 命名规范 | ⭐⭐⭐⭐☆ | 基本符合驼峰命名，少数不一致 |
| 代码重复 | ⭐⭐☆☆☆ | CSS 和辅助函数大量重复 |
| 类型安全 | ⭐⭐☆☆☆ | 前端滥用 `any`，后端 DTO/Entity 映射静默失败 |
| 单元测试 | ⭐☆☆☆☆ | 仅 2 个测试文件，覆盖几乎为零 |
| 异常处理 | ⭐⭐⭐⭐☆ | 全局异常 + Service 级别 try/catch 较完整 |
| 注释质量 | ⭐⭐⭐⭐☆ | 核心类和方法有 Javadoc/TSDoc，个别待补充 |

**综合评分：3.0 / 5.0**（中等偏上）

---

## 2. 分层设计与模块边界

### 2.1 架构概览

```
Controller（接收请求、参数校验、路由）
    ↓
Service Interface（定义业务契约）
    ↓
ServiceImpl（业务逻辑实现、事务管理）
    ↓
Mapper（数据库操作）→ XML（SQL 定义）
```

### 2.2 优点
- 三层架构清晰，各层职责明确
- 多数 Service 有接口定义，便于测试和替换
- DTO/Entity 分离，数据视图与持久化模型解耦

### 2.3 问题

#### P2 — ChargingStationController 与 ChargingPileController 功能重叠

**文件**: `backend/admin/.../controller/ChargingStationController.java`、`ChargingPileController.java`
**严重度: Medium**

两个 Controller 操作同一张 `charging_stations` 表，提供的 CRUD 接口几乎完全重复：
- `/admin/chargingStation/page` + `/admin/chargingPile/page`
- `/admin/chargingStation/add` + `/admin/chargingPile/add`
- `/admin/chargingStation/update` + `/admin/chargingPile/update`
- `/admin/chargingStation/delete` + `/admin/chargingPile/delete`

**建议**: 合并为一个 Controller，删除重复的 `ChargingPileController`。

#### P2 — Admin 与 User 模块 NewsController 重复

**文件**: `admin/.../news/NewsController.java`、`user/.../news/NewsController.java`
**严重度: Medium**

两个模块的新闻管理接口完全相同（publish、update、delete、detail、list），且 admin 模块的新闻接口没有认证保护。

**建议**: 统一到 common 模块或 user 模块，admin 通过依赖调用。

#### P2 — 用户端 OrderController 重复

**文件**: `user/.../ChargingStationOrderSelectController.java`、`user/.../OrderController.java`
**严重度: Medium**

两者都在用户端暴露订单查询功能，路径分别为 `/api/selectAll` 和 `/order/listByUserId`。

**建议**: 合并订单查询逻辑。

---

## 3. 循环依赖

### 检查结果

未发现明显的循环依赖。模块依赖方向为：
```
common ← admin
common ← user
```
admin 和 user 模块互不依赖，符合设计。

> ✅ **通过** — 无循环依赖

---

## 4. 重复代码

### P2 — CSS 样式大量重复（严重）

**影响文件**: `admin-frontend/src/views/` 下 7 个视图文件

以下 CSS 代码块在多个文件中完全或高度重复：

| CSS 块 | 出现次数 | 影响文件 |
|--------|---------|---------|
| `.glass-card` | 7 | Dashboard, User, Station, Order, Payment, Reservation, Settings |
| `.particles` / `.particle` / `@keyframes dashFloat` | 6 | Dashboard, User, Station, Order, Payment, Reservation |
| `.dark-table` 及其 `:deep` 覆盖 | 5 | User, Station, Order, Payment, Reservation |
| `.dark-input` / `.dark-select` / `.dark-datepicker` | 5+ | User, Station, Order, Payment, Reservation |
| `.pagination-wrapper` | 5 | User, Station, Order, Payment, Reservation |
| `.search-btn` / `.filter-actions` / `.filter-bar` | 6 | User, Station, Order, Payment, Reservation, Settings |
| `.stat-card` 系列 | 1 | Dashboard（唯一） |

**重复代码行数估算**: 每文件约 200-300 行重复 CSS，7 个文件总计约 **1500-2000 行** 重复样式。

**建议**: 提取到 `src/styles/common.scss` 或 `src/styles/dark-theme.scss` 中统一管理。

### P2 — 辅助函数重复

| 函数 | 出现文件数 |
|------|-----------|
| `formatTime(time)` | Dashboard, User, Order, Payment, Reservation（5 文件） |
| `statusType(status)` | Dashboard, Order, Payment, Reservation, Station（5 文件） |
| `particleStyle(n)` | Dashboard, User, Station, Order, Payment, Reservation（6 文件） |

**建议**: 提取到 `src/utils/helpers.ts` 工具文件。

### P2 — 数据获取模式重复

`OrderManagement`、`PaymentManagement`、`ReservationManagement` 中的分页查询逻辑结构高度相似：

```typescript
// 每个视图都有的模板
const fetchXxx = async () => {
  try {
    const params: any = { pageNum: ..., pageSize: ... }
    // 根据不同条件调用不同 API
    if (xxx) { params.xxx = xxx }
    const res: any = await request.post('/xxx/page/...', params)
    if (res?.data?.records) { xxxList.value = res.data.records }
  } catch { /* handled */ }
}
```

**建议**: 创建通用分页查询组合式函数 `usePagination(fetchUrl, params)`。

---

## 5. 超长函数

### 检查结果

| 文件 | 行数 | 评估 |
|------|------|------|
| `AdminServiceImpl.java` | 294 行 | 适中，含独立校验方法 |
| `OrderServiceImpl.java` | 181 行 | 适中 |
| `PaymentsServiceImpl.java` | 208 行 | 适中 |
| `ReservationServiceImpl.java` | 263 行 | 适中，每个方法 < 100 行 |
| `AdminDashboard.vue` | 541 行 | **较长**，但其中 CSS 占 300 行 |
| `UserManagement.vue` | ~350 行 | 较长，CSS 和模板混合 |
| `StationManagement.vue` | ~400 行 | 同上 |

> ✅ **通过** — 单个方法基本控制在 200 行以内，CSS 提取后可显著缩短文件长度

---

## 6. 命名规范

### 6.1 后端

| 规范 | 检查结果 |
|------|---------|
| 类名大驼峰 | ✅ 全部符合 |
| 方法名小驼峰 | ✅ 全部符合 |
| 包名全小写 | ✅ 全部符合 |
| 常量全大写 | ✅ 符合（`ALLOWED_EXTENSIONS`、`MAX_IMAGE_SIZE` 等） |
| DTO 命名模式 `XxxDTO` | ✅ 全部符合 |

### 6.2 前端

| 规范 | 检查结果 |
|------|---------|
| 组件名大驼峰 | ✅ 全部符合 |
| 变量名小驼峰 | ✅ 全部符合 |
| 路由 path 小写 | ✅ 全部符合 |
| CSS class kebab-case | ✅ 全部符合（如 `.glass-card`、`.stat-icon`） |

### 6.3 发现的问题

#### P3 — 数据库状态值不一致

| 位置 | 使用值 | 问题 |
|------|--------|------|
| schema.sql `status` 默认值 | `available / occupied / maintenance` | 语义化字符串 |
| XML `updateChargingStationStatus` | `status = 1` / `status = 0` | 数字字面量 |
| 前端过滤条件 | `s.status === 'available' \|\| s.status === '0'` | 同时兼容两种格式 |

这是**一个严重的命名/取值不一致问题**，已归类为 P0 安全/业务风险，在此仅记录命名规范问题。

#### P3 — 用户端 Mapper XML 状态使用数字

`ChargingStationsMapper.xml` 中：
```xml
<update id="updateChargingStationStatus">
    update charging_stations set status = 1 where station_id = #{stationId}
</update>
<update id="stopUpdateChargingStationStatus">
    update charging_stations set status = 0 where station_id = #{stationId}
</update>
```

但 `CAS 乐观锁` 方法 `updateStatusIfAvailable` 使用参数化 status：
```xml
<update id="updateStatusIfAvailable">
    UPDATE charging_stations SET status = #{newStatus}
    WHERE station_id = #{stationId} AND status = #{expectedStatus}
</update>
```

> 建议: 统一使用参数化状态值，废除硬编码 `1`/`0` 的方法。

---

## 7. 代码复杂度

### 7.1 控制流复杂度

| 文件 | 方法 | 圈复杂度 | 评估 |
|------|------|---------|------|
| `AdminServiceImpl.java` | `login()` | 中等 | 嵌套 if-else 控制 |
| `OrderServiceImpl.java` | 各方法 | 低 | 线性流程 |
| `ReservationServiceImpl.java` | 各方法 | 低 | 线性流程 |
| `LoginInterceptor.java` | `preHandle()` | 低 | 简单条件判断 |
| `AdminDashboard.vue` | `fetchDashboardData()` | 中 | Promise.all + 多个 .filter/.reduce |

> ✅ **通过** — 整体复杂度可控，无超复杂函数

### 7.2 条件分支

`AdminDashboard.vue` 的 `fetchDashboardData()` 中有对不同 API 返回结构的多条件处理，建议使用统一的响应类型消除条件分支。

---

## 8. 测试覆盖率

### 8.1 现状

| 模块 | 测试文件 | 测试框架 | 覆盖率估算 |
|------|---------|---------|-----------|
| backend/user | 2 个测试文件 | JUnit | < 2% |
| backend/admin | 0 | — | 0% |
| frontend | 0 | — | 0% |
| admin-frontend | 0 | — | 0% |

### 8.2 发现

仅有 `backend/user` 模块下有 2 个测试文件：
- `MyTest1.java` — 基础测试
- `TestUpdateUserService.java` — 用户更新服务测试

**核心业务逻辑（充电流程、预约、订单、支付）完全没有单元测试**。

### 8.3 建议

1. 为核心 Service（AdminService、OrderService、ReservationService）编写单元测试
2. 为异步充电流程（ChargingAsyncService）编写集成测试
3. 前端至少为 Store 和 Utils 编写测试
4. 目标覆盖率：核心模块 ≥ 60%

---

## 9. 未使用的组件/代码

### 后端

| 文件 | 状态 | 说明 |
|------|------|------|
| `ChargeMonitorServiceImpl.getNearbyStations()` | **已废弃** | 返回 `null`，硬编码未实现 |
| `SystemLogServiceImpl` | 低使用率 | 日志记录功能存在但使用有限 |
| `FileUploadUtils.isMimeTypeAllowed()` | **重复防御** | 扩展名校验后追加 MIME 校验，冗余但安全 |

### 前端

| 组件 | 状态 | 说明 |
|------|------|------|
| `AdminHeader.vue` | **未使用** | `App.vue` 内联了头部，未导入此组件 |
| `AdminSidebar.vue` | **未使用** | `App.vue` 内联了侧边栏，未导入此组件 |
| `AdminLayout.vue` | **未使用** | 仅渲染 `<router-view/>`，`App.vue` 未使用 |
| `HandParticleCanvas.vue` | **未使用** | 各视图内联了粒子 canvas，未导入此组件 |

> 建议: 清理 4 个废弃组件，或重构 App.vue 使用这些组件。

---

## 10. 杂项发现

### P2 — Orders Entity 时间字段类型不一致

**文件**: `Orders.java`

```java
private String startTime;     // 使用 String
private String endTime;       // 使用 String
private String createdTime;   // 使用 String
```

对比其他 Entity：
```java
// Reservation.java
private LocalDateTime reservedStartTime;  // 使用 LocalDateTime
private LocalDateTime reservedEndTime;    // 使用 LocalDateTime
```

`Orders` 使用 String 存储时间，增加了格式化和比较的复杂性。

### P2 — 前端 withCredentials: false

**文件**: `request.ts` 第 20 行

```typescript
withCredentials: false,
```

当前通过 Vite proxy 转发请求，此设置正确。如果未来改为直接调用后端 API（无 proxy），需改为 `true` 以携带 Cookie。

### P3 — NewsManagement.vue 是骨架页面

仅包含空表格 `el-table :data="[]"`，没有任何数据获取和业务逻辑。是一个未完成的页面。
