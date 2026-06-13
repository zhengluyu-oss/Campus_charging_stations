## Why

后端项目存在多个严重安全漏洞：管理员密码明文存储、密码被日志输出、硬编码凭据、文件上传无校验等。这些问题可能导致数据泄露、未授权访问和服务器被入侵，必须立即修复。

## What Changes

- 管理员密码改为 BCrypt 加密存储和验证
- 移除密码日志输出
- 外部化所有敏感配置（数据库、Redis、JWT Secret）
- 文件上传添加类型校验和路径净化
- 添加 `@EnableAsync` 使充电异步功能生效
- 修复 Admin 拦截器配置（Swagger 排除、UserContext 设置）
- 补充缺失的 Mapper XML 方法
- 创建 `.gitignore` 文件
- 统一密码规则和文件路径配置

## Capabilities

### New Capabilities
- `admin-auth`: 管理员密码 BCrypt 加密和安全登录
- `file-upload-security`: 文件上传类型校验和路径净化
- `config-externalization`: 敏感配置外部化

### Modified Capabilities

## Impact

- `backend/admin/src/main/java/com/tjetc/service/impl/AdminServiceImpl.java` — 密码加密和日志修复
- `backend/admin/src/main/java/com/tjetc/interceptor/LoginInterceptor.java` — UserContext 设置
- `backend/admin/src/main/java/com/tjetc/config/LoginInterceptorConfig.java` — Swagger 排除
- `backend/common/src/main/java/com/tjetc/common/FileUploadUtils.java` — 文件校验
- `backend/user/src/main/java/com/tjetc/UserApplication.java` — 添加 @EnableAsync
- `backend/*/src/main/resources/application.yml` — 配置外部化
- `backend/common/src/main/resources/mapper/UserMapper.xml` — 补充 SQL
- `.gitignore` — 新建
