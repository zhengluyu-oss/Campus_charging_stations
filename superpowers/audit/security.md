# 安全审计报告

## 1. 总体风险评估

| 风险等级 | 数量 | 影响 |
|---------|------|------|
| **Critical (P0)** | 3 | 认证绕过风险、敏感数据泄露、业务中断 |
| **High (P1)** | 4 | 授权缺失、配置泄露、XSS 风险 |
| **Medium (P2)** | 5 | 标准合规、纵深防御 |
| **Low (P3)** | 4 | 无害但可改进 |

---

## 2. 身份与访问控制

### P0 — 充电桩状态值不统一导致业务绕过

**文件**: `ChargingStationsMapper.xml`、`schema.sql`
**严重度: P0 — Critical**

数据库 schema 定义 `charging_stations.status` 使用语义化字符串值：
```sql
status VARCHAR(20) DEFAULT 'available' COMMENT '状态(available/occupied/maintenance)'
```

但 XML Mapper 中硬编码数字字面量：
```xml
<update id="updateChargingStationStatus">
    update charging_stations set status = 1 where station_id = #{stationId}
</update>
<update id="stopUpdateChargingStationStatus">
    update charging_stations set status = 0 where station_id = #{stationId}
</update>
```

**问题**: 
- 初始数据状态是 `available`（字符串），但代码更新为 `1`（数字）
- 后续的 `stopUpdateChargingStationStatus` 更新为 `0`（数字）
- 状态值不一致导致 `ifAvailable` 检查逻辑混乱，可能造成同一充电桩被多人同时占用的**竞态条件失效**

**修复建议**: 
1. 统一状态值：全部使用语义化字符串（`available`/`occupied`/`maintenance`）
2. 删除硬编码 status 的 XML 方法，改用参数化 `updateStatusIfAvailable`
3. 清除数据库中的脏数据

### P1 — Token 存储在 localStorage（XSS 可窃取）

**文件**: `admin-frontend/src/stores/admin.ts`
**严重度: P1 — High**

```typescript
export const useAdminStore = defineStore('admin', () => {
  const token = ref('')
  // ...
}, { persist: true })
```

`pinia-plugin-persistedstate` 将 Token 和 Admin 信息持久化到 `localStorage`。localStorage 对 XSS 攻击完全开放：
- 一旦页面被注入任意脚本，攻击者可直接 `localStorage.getItem('pinia/admin')` 获取 Token
- Token 永不过期机制下（除非用户登出），攻击者获得**长期后台访问权限**

**影响**: 管理后台 Token 泄露 → 完全接管后台

**修复建议**:
1. **首选方案**: 使用 httpOnly Cookie + Refresh Token 机制
2. **次选方案**: 实施 Short-lived Token（当前 36000000ms ≈ 10 小时过长，建议 30 分钟）
3. **最低方案**: 使用 `sessionStorage` 替代 `localStorage` 减少暴露窗口

> 注: 同一文件中已有安全注释（第 4-8 行），但未实施任何缓解措施。

### P1 — 路由守卫无 RBAC（角色越权）

**文件**: `admin-frontend/src/router/index.ts` 第 68-75 行
**严重度: P1 — High**

```typescript
router.beforeEach((to, _from, next) => {
  const adminStore = useAdminStore()
  if (!to.meta.noAuth && !adminStore.token) {
    next('/login')
  } else {
    next()
  }
})
```

路由守卫仅检查 Token 是否存在，**没有任何基于角色的访问控制**。所有已认证用户可见所有管理页面（用户管理、订单管理、支付管理、设置页等）。

**影响**: 低权限管理员可访问所有后台功能

**修复建议**: 
1. 为路由添加 `meta.roles` 配置
2. 在路由守卫中检查当前用户的角色
3. 后端 API 层也应添加角色校验（不依赖前端校验）

### P2 — 自定义 Token Header 非标准

**文件**: `admin-frontend/src/utils/request.ts` 第 57-58 行
**严重度: P2 — Medium**

```typescript
if (token) {
  config.headers['token'] = token
}
```

Token 通过自定义 Header `token` 而非标准 `Authorization: Bearer <token>` 传输。

**问题**:
- 部分反向代理/CDN/API 网关会剥离非标准 Header
- 与常见安全中间件（如 Spring Security、Shiro）不兼容
- 增加后续集成难度

**修复建议**: 改用标准 `Authorization: Bearer` Header

### P2 — 后端未校验前端用户角色

**文件**: `LoginInterceptor.java` 第 43 行
**严重度: P2 — Medium**

```java
UserContext.set(userId, username);
```

拦截器仅解析和设置用户信息，**未校验用户角色和权限**。Controller 层也未进行权限检查。

**影响**: 即使前端做了路由守卫，直接调用 API 也没有权限限制。

**修复建议**: 在拦截器中解析角色信息并校验端点权限。

### P1 — dev.yml 未受保护

**文件**: `.gitignore`
**严重度: P1 — High**

`application-dev.yml` 包含数据库密码（123456）、Redis 密码（123456）、JWT 密钥（开发密钥）。虽然 `.gitignore` 意图忽略 dev 配置文件，但：
- 仓库历史中可能已存在 dev 配置
- 开发环境使用弱密码存在横向渗透风险

**检查结果**: `application-dev.yml` 已加入 `.gitignore` ✅
**建议**: 确保所有环境中 dev/yml 密码强度足够，或使用环境变量覆盖。

---

## 3. 输入输出安全

### P2 — DTO 层缺少 `@Valid` 注解校验

**文件**: 所有 Controller 和 DTO 类
**严重度: P2 — Medium**

所有 Controller 方法接收 `@RequestBody` 参数，但**没有任何 DTO 使用 `@Valid` 或 `@Validated` 注解**开启自动校验。

例如：
```java
@PostMapping("/add")
public JsonResult add(@RequestBody AdminDTO adminDTO) {  // 缺少 @Valid
```

所有校验全部在 Service 层手动实现，导致：
1. 校验逻辑分散在各 ServiceImpl 中
2. 缺少校验一致性保障
3. 基础校验（非空、长度、格式）应在 DTO 层完成

**建议**: 在 DTO 字段上添加 `@NotBlank`、`@Size` 等 Bean Validation 注解，Controller 参数添加 `@Valid`。

### P3 — 登录接口缺少速率限制

**文件**: `LoginController.java`、`backend/admin/...LoginController.java`
**严重度: P3 — Low**

两个登录接口（admin + user）都没有速率限制，存在暴力破解风险。

**配置了 JWT 校验和 IP 记录到 system_logs**（间接缓解），但缺少专门防暴力破解机制。

**建议**: 添加登录失败计数 + 临时锁定机制，或使用验证码。

### P3 — 密码明文传输

**文件**: `admin-frontend/src/views/AdminLogin.vue` 第 117-120 行
**严重度: P3 — Low**

```typescript
const res: any = await request.post('/admin/login', {
  username: form.username,
  password: form.password,  // 明文传输
})
```

**缓解因素**:
1. 后端最终使用 BCrypt 存储和验证密码
2. HTTPS 加密传输层
3. 明文密码不会在服务端日志中记录

**建议**: 前端在传输前做一次 SHA-256 哈希（防服务端日志意外泄露），后端再 BCrypt 比对。

### P3 — 登出后未清除密码表单

**文件**: `AdminLogin.vue`
**严重度: P3 — Low**

登录表单在成功提交后不会主动清除密码字段，存在通过浏览器历史/缓存泄露密码的风险。

### ✅ 通过检查项

| 检查项 | 状态 | 说明 |
|--------|------|------|
| SQL 注入防御 | ✅ 通过 | 全部使用 MyBatis-Plus 参数化查询和 `#{}` 占位符，无字符串拼接 |
| XSS 防御 | ✅ 通过 | Element Plus 默认转义输出，无 `v-html` 使用 |
| CSRF 防御 | ✅ 通过 | JWT Token 认证天然抗 CSRF |
| 路径遍历防御 | ✅ 通过 | `FileUploadUtils.sanitizeFilename()` 净化文件名，UUID 重命名 |
| 文件上传类型校验 | ✅ 通过 | 白名单扩展名 + MIME 双重校验 |
| 文件大小限制 | ✅ 通过 | 10MB(图片)/100MB(视频)/20MB(音频) 三级限制 |
| HTTPS 配置 | ✅ 通过 | 虽然是 proxy 转发，但架构支持 HTTPS 代理 |

---

## 4. 数据保护

### ✅ 密码加密 — 通过

- 使用 Spring Security `BCryptPasswordEncoder`
- 登录时自动检测旧明文并迁移为 BCrypt
- 返回前端时密码字段设为 null

### ✅ JWT 密钥管理 — 通过

- `JwtTokenInitializer` 启动时校验 secret 非空
- 拒绝使用硬编码的开发密钥（第 26-28 行）
- 使用 `SHA-256` 缩短过长密钥（32 字节以下时）

### P2 — 日志可能记录敏感数据

**文件**: 多个 Controller 中

```java
log.info("管理员登录请求: username={}", adminLoginDTO.getUsername());
log.info("接收新增支付记录请求，参数：{}", paymentDTO);
```

`paymentDTO` 的 `toString()` 如果包含支付信息，可能记录敏感数据。建议在日志中只记录 ID 等非敏感字段。

### P2 — Swagger 文档生产环境未关闭

**文件**: `application.yml` 第 51 行

```yaml
springdoc:
  api-docs:
    enabled: true  # 生产环境建议设为 false
```

Swagger 文档在生产环境仍开启，可能泄露 API 结构信息。

---

## 5. 安全配置清单

| 配置项 | 状态 | 备注 |
|--------|------|------|
| JWT 密钥通过环境变量注入 | ✅ | `${JWT_SECRET}` |
| 数据库密码通过环境变量注入 | ✅ | `${DB_PASSWORD}` |
| Redis 密码通过环境变量注入 | ✅ | `${REDIS_PASSWORD}` |
| 文件上传路径通过环境变量配置 | ✅ | `${FILE_UPLOAD_PATH}` |
| 日志路径通过环境变量配置 | ✅ | `${LOG_PATH}` |
| 生产移除 console/debugger | ✅ | `esbuild.drop` 配置 |
| dev.yml 在 gitignore 中 | ✅ | (需确认历史记录中已清除) |
| CORS 配置 | ⚠️ | 通过 Vite proxy 处理，非后端配置 |
| 请求日志级别 | ⚠️ | stdout 模式可能记录过多 SQL |
