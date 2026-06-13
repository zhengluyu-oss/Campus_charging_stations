## Context

后端项目经过全面审查，发现 4 个严重安全漏洞、3 个高风险问题、多个中等风险问题。项目使用 Spring Boot 3.5.9 + MyBatis-Plus + JWT，包含 admin（端口 8081）和 user（端口 8080）两个模块。

## Goals / Non-Goals

**Goals:**
- 修复所有严重安全漏洞（密码明文、日志泄露、硬编码凭据）
- 添加文件上传安全校验
- 修复功能性 Bug（@Async 未生效、缺失的 SQL）
- 提高代码质量和可维护性

**Non-Goals:**
- 不重构整体架构
- 不添加新的业务功能
- 不修改前端代码（已单独处理）
- 不添加 Redis 缓存或消息队列

## Decisions

### 1. 管理员密码 BCrypt 加密

**决定**: 复用 common 模块已有的 `PasswordEncoder` Bean，修改 `AdminServiceImpl` 的登录和注册逻辑。

**原因**: 项目已有 `BCryptPasswordEncoder` 配置（在 `SecurityConfig.java`），用户模块已正确使用，管理员模块应保持一致。

**实现方式**:
- `add()` 方法：调用 `passwordEncoder.encode(password)` 后再 insert
- 登录方法：改为按用户名查询，然后用 `passwordEncoder.matches()` 验证
- 添加自动迁移逻辑：检测到明文密码匹配时自动加密更新

### 2. 配置外部化

**决定**: 使用 Spring 的 `@Value` 注解配合环境变量，格式为 `${ENV_VAR:default}`。

**原因**: 保持开发环境开箱即用（有默认值），同时支持生产环境通过环境变量覆盖。

**环境变量命名**:
- `DB_USERNAME` / `DB_PASSWORD`
- `REDIS_PASSWORD`
- `JWT_SECRET`
- `FILE_BASE_PATH`

### 3. 文件上传校验

**决定**: 在 `FileUploadUtils.upload()` 方法中添加扩展名白名单校验和文件名净化。

**原因**: 在工具类层面统一校验，所有调用方自动受益。

**白名单**: jpg, jpeg, png, gif, webp, mp4, avi, mov, mkv

### 4. 异步功能修复

**决定**: 在 `UserApplication` 和 `AdminApplication` 上添加 `@EnableAsync` 注解。

**原因**: 最小改动，使已有的 `@Async` 注解生效。

**注意**: `Thread.sleep()` 方案虽然不理想，但作为课程项目可以接受，暂不改为 ScheduledExecutorService。

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|---------|
| 修改登录逻辑可能影响现有管理员账号 | 添加自动迁移逻辑，明文密码首次登录时自动加密 |
| 环境变量配置可能遗漏 | 提供合理的默认值，开发环境无需配置 |
| 文件白名单可能不够全面 | 按需扩展，初期只允许常见图片和视频格式 |

## Migration Plan

1. **Phase 1 — 严重安全修复**（优先级最高）
   - 管理员密码 BCrypt 加密
   - 移除密码日志
   - 外部化敏感配置

2. **Phase 2 — 功能修复**
   - 文件上传校验
   - 添加 @EnableAsync
   - 补充缺失的 Mapper XML

3. **Phase 3 — 配置优化**
   - Admin 拦截器修复
   - 创建 .gitignore
   - 统一配置
