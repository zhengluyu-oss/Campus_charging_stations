# 001 — 修复 P0 关键问题：代码复审报告

## 复审概览

| 项目 | 内容 |
|------|------|
| **复审范围** | Batch 1（状态统一）+ Batch 2（Token 安全）+ Batch 3（充电计时持久化） |
| **复审方法** | 按批次逐任务审查，确认规格符合性和代码质量 |
| **审查文件数** | 18 个文件（8 新增 + 10 修改） |
| **审查结论** | **通过，发现 3 个 Minor 问题** |

---

## Batch 1 — 充电桩状态值统一：规格符合性审查

### 1.1 数据库迁移脚本 V002

| 检查项 | 结果 |
|--------|:----:|
| schema.sql 状态值定义一致 | ✅ |
| 脏数据 `0`→`available`, `1`→`occupied` | ✅ |
| ALTER TABLE MODIFY COLUMN 保留默认值 | ✅ |

**结论**: ✅ 通过

### 1.2 ChargingStationsMapper.xml

| 检查项 | 结果 |
|--------|:----:|
| 删除 `updateChargingStationStatus` (status=1) | ✅ |
| 删除 `stopUpdateChargingStationStatus` (status=0) | ✅ |
| 删除 `updateChargingStationStatusAndTime` (status=1) | ✅ |
| 新增 `updateStatus(stationId, status)` 参数化方法 | ✅ |
| 保留 `updateStatusIfAvailable` CAS 方法 | ✅ |

**结论**: ✅ 通过

### 1.3 ChargingStationsMapper.java

| 检查项 | 结果 |
|--------|:----:|
| 接口与 XML 方法 ID 一致 | ✅ |
| @Param 注解正确 | ✅ |

**结论**: ✅ 通过

### 1.4 ChargingStationUseServiceImpl.java

| 检查项 | 结果 |
|--------|:----:|
| CAS 条件从 `"0"/"1"` 改为 `"available"/"occupied"` | ✅ |

**结论**: ✅ 通过

### 1.5 ChargingStationsReversationServiceImpl.java

| 检查项 | 结果 |
|--------|:----:|
| 状态判断 `"1"` → `"occupied"` | ✅ |
| 方法调用 `updateChargingStationStatusAndTime` → `updateStatus` | ✅ |

**结论**: ✅ 通过

### 1.6 ChargingAsyncService.java（Batch 1 部分）

| 检查项 | 结果 |
|--------|:----:|
| `stopUpdateChargingStationStatus` 全部替换为 `updateStatus(stationId, "available")` | ✅ |

**结论**: ✅ 通过

### 1.7 AdminDashboard.vue

| 检查项 | 结果 |
|--------|:----:|
| 移除 `s.status === '0'` 数字兼容条件 | ✅ |
| 改用纯语义化字符串过滤 | ✅ |

**结论**: ✅ 通过

### Batch 1 批量审查结论

**通过。0 个 Critical/Important 问题，0 个 Minor 问题。**

---

## Batch 2 — Token 安全存储：规格符合性审查

### 2.1 application.yml TTL 缩短

| 检查项 | 结果 |
|--------|:----:|
| admin 模块 expired: 1800000 | ✅ |
| user 模块 expired: 1800000 | ✅ |

**结论**: ✅ 通过

### 2.2 JwtTokenUtil Refresh Token

| 检查项 | 结果 |
|--------|:----:|
| `generateRefreshToken(subject)` — 7 天有效期 | ✅ |
| `validateToken(token)` — 静默校验不抛异常 | ✅ |
| `isRefreshToken(claims)` — 检查 type=refresh | ✅ |
| 旧方法签名向后兼容 | ✅ |
| 唯一 jti 用于防重放 | ✅ |

**结论**: ✅ 通过

### 2.3 Admin 刷新接口

| 检查项 | 结果 |
|--------|:----:|
| `AdminService.refreshToken(String)` 接口定义 | ✅ |
| `AdminServiceImpl.refreshToken()` 实现 | ✅ |
| 校验 Refresh Token 有效 | ✅ |
| 校验 type=refresh | ✅ |
| 提取用户信息重新生成 Token | ✅ |
| 登录返回 `{token, refreshToken, admin}` 结构 | ✅ |

**Minor ⚠️**: Refresh Token 防重放未使用 Redis。当前在单次请求内不会被重复使用，但如果 Refresh Token 泄露，攻击者可以在 7 天内多次使用。建议后续增加已使用 jti 的 Redis 存储。

**结论**: ✅ 通过（1 个 Minor 建议）

### 2.4 User 刷新接口

| 检查项 | 结果 |
|--------|:----:|
| 是否存在对应的刷新端点 | ❌ **未实现**（按计划跳过） |

**Minor ⚠️**: 用户端 LoginController 尚未添加刷新端点，如需完整支持需补充。当前用户端 Token 过期后只能重新登录。

**结论**: ⚠️ 条件通过（按计划范围外）

### 2.5 LoginInterceptorConfig 放行路径

| 检查项 | 结果 |
|--------|:----:|
| admin 模块添加 `/admin/refresh` | ✅ |
| user 模块添加 `/user/refresh` | ✅ |

**结论**: ✅ 通过

### 2.6 Axios 拦截器自动刷新

| 检查项 | 结果 |
|--------|:----:|
| 检测 `state === -1` 触发自动刷新 | ✅ |
| 使用 `refreshToken` 调用 `/admin/refresh` | ✅ |
| 刷新成功后更新 store Token | ✅ |
| 刷新成功后重放原始请求 | ✅ |
| 并发请求排队（`isRefreshing` + `pendingRequests`） | ✅ |
| 刷新失败后跳转登录 | ✅ |
| 避免 Refresh 自身触发刷新循环 | ✅（`isRefreshRequest` 检查） |

**Minor ⚠️**: `error.response` 处理分支中状态码 401 的处理与原计划不完全一致——自动刷新拦截在 `res.state === -1` 分支已处理，`error.response.status === 401` 分支作为兜底保留。该冗余设计可防后端直接返回 HTTP 401 的情况，但未与 Refresh 流程联动。建议后续统一。

**结论**: ✅ 通过（1 个 Minor 建议）

### 2.7 AdminStore Refresh Token 管理

| 检查项 | 结果 |
|--------|:----:|
| 新增 `refreshToken` ref | ✅ |
| 新增 `getRefreshToken` computed | ✅ |
| 新增 `setRefreshToken` 方法 | ✅ |
| `logout()` 清除 Refresh Token | ✅ |

**结论**: ✅ 通过

### Batch 2 批量审查结论

**✅ 通过。0 个 Critical/Important 问题，3 个 Minor 建议：**
1. Refresh Token 防重放缺少 Redis 存储（后续可补充）
2. 用户端刷新端点未实现（按计划跳过）
3. 401 响应兜底处理未与 Refresh 流程联动

---

## Batch 3 — 充电计时持久化：规格符合性审查

### 3.1 ChargingTimerScheduler

| 检查项 | 结果 |
|--------|:----:|
| `@Scheduled(fixedRate = 30000)` 每 30 秒执行 | ✅ |
| ZRANGEBYSCORE 获取已超时订单 | ✅ |
| 更新订单状态 `charging → completed` | ✅ |
| 释放充电桩 `occupied → available` | ✅ |
| 从 ZSET 移除已处理条目 | ✅ |
| 订单不存在或状态异常时跳过处理 | ✅ |
| 异常处理（try/catch 单个订单防止批量失败） | ✅ |

**结论**: ✅ 通过

### 3.2 ChargingAsyncService 重构

| 检查项 | 结果 |
|--------|:----:|
| 充电开始即创建订单（不再是充电结束后） | ✅ |
| 订单状态设为 `charging` | ✅ |
| 写入 Redis ZSET `charging:timers` | ✅ |
| Thread.sleep() 作为快速触发 | ✅ |
| Sleep 后检查订单是否已被定时任务处理 | ✅ |
| 防重复完成逻辑（`if (!"charging".equals(order.getOrderStatus())) return;`） | ✅ |
| 预约流程兼容（startReserveTimer 等待后创建订单再充电） | ✅ |
| 方法签名向后兼容 | ✅ |

**结论**: ✅ 通过

### 3.3 ChargingStationUseServiceImpl

| 检查项 | 结果 |
|--------|:----:|
| CAS 更新状态（Batch 1 已处理） | ✅ |
| startChargingTimer 参数匹配新签名 | ✅ |

**结论**: ✅ 通过

### 3.4 @EnableScheduling

| 检查项 | 结果 |
|--------|:----:|
| UserApplication 添加 `@EnableScheduling` | ✅ |

**结论**: ✅ 通过

### Batch 3 批量审查结论

**通过。0 个 Critical/Important 问题，0 个 Minor 问题。**

---

## 最终整体审查

| 维度 | 评分 | 说明 |
|------|:----:|------|
| 规格符合性 | ✅ 通过 | 所有 P0 问题的修复方案按 design.md 和 plan.md 完成 |
| 代码质量 | ✅ 良好 | 命名规范、异常处理、注释完整 |
| 向后兼容 | ✅ 通过 | API 响应格式变化（登录返回 `{token, refreshToken, admin}`）已同步更新前端 |
| 安全 | ✅ 改善 | Token TTL 缩短、Refresh Token 机制 |
| 性能 | ✅ 改善 | 充电计时持久化、兜底机制 |
| 数据库完整性 | ✅ 通过 | 迁移脚本幂等、ALTER TABLE 安全 |

### 总问题统计

| 级别 | 数量 | 状态 |
|:----:|:----:|:----:|
| Critical | 0 | — |
| Important | 0 | — |
| Minor | 3 | 记录在报告，不阻断开继续 |

### 未覆盖范围

以下按计划不纳入本次变更：
1. User 模块刷新端点（2.4）— 按 design.md 约定跳过
2. httpOnly Cookie 方案 — 中期计划
3. RBAC 权限控制 — P1 问题，另立变更

---

## 复审结论

| 项目 | 值 |
|------|-----|
| **总体结论** | ✅ **通过** |
| **阻断开继续的问题** | 0 |
| **待解决 Minor 建议** | 3（无需阻挡 A-6 验证） |
| **建议** | 进入 A-6 完成前验证 |
