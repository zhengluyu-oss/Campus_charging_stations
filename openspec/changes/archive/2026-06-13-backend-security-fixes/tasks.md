## 1. 严重安全修复

- [x] 1.1 修改 `AdminServiceImpl.add()` 方法：使用 `passwordEncoder.encode()` 加密密码后再插入数据库
- [x] 1.2 修改 `AdminServiceImpl.login()` 方法：改为按用户名查询，使用 `passwordEncoder.matches()` 验证密码
- [x] 1.3 添加管理员密码自动迁移逻辑：检测到明文密码匹配时自动加密更新数据库
- [x] 1.4 移除 `AdminServiceImpl.checkAdmin()` 第 107 行的密码日志输出
- [x] 1.5 修改 `AdminMapper.xml`：添加按用户名查询的 SQL（已存在 selectByUsername）

## 2. 配置外部化

- [x] 2.1 修改 admin `application.yml`：数据库凭据改为读取环境变量 `${DB_USERNAME:root}` / `${DB_PASSWORD:123456}`
- [x] 2.2 修改 user `application.yml`：数据库凭据改为读取环境变量
- [x] 2.3 修改 admin `application.yml`：Redis 密码改为读取环境变量 `${REDIS_PASSWORD:123456}`
- [x] 2.4 修改 admin `application.yml`：JWT Secret 改为读取环境变量 `${JWT_SECRET:campus-charging-station-dev-secret-key-32bytes!}`
- [x] 2.5 修改 user `application.yml`：JWT Secret 改为读取环境变量
- [x] 2.6 修改文件路径配置：改为读取环境变量 `${FILE_BASE_PATH:D:/temp}`

## 3. 文件上传安全

- [x] 3.1 修改 `FileUploadUtils.upload()`：添加文件扩展名白名单校验（jpg, jpeg, png, gif, webp, mp4, avi, mov, mkv）
- [x] 3.2 修改 `FileUploadUtils.upload()`：净化文件名，移除路径遍历字符
- [x] 3.3 修改 `FileUploadUtils.upload()`：添加 null 检查和无扩展名处理
- [x] 3.4 修改 `application.yml`：将最大上传文件大小从 1024MB 降低到合理值（图片 10MB，视频 100MB）

## 4. 功能修复

- [x] 4.1 在 `UserApplication` 上添加 `@EnableAsync` 注解
- [x] 4.2 在 `AdminApplication` 上添加 `@EnableAsync` 注解
- [x] 4.3 在 `UserMapper.xml` 中添加 `selectPageByUsernameLike` SQL 方法

## 5. 配置优化

- [x] 5.1 修改 admin `LoginInterceptorConfig`：添加 Swagger 路径排除（`/v3/api-docs/**`, `/swagger-ui/**`）
- [x] 5.2 修改 admin `LoginInterceptor`：添加 UserContext 设置（从 JWT 提取 userId 和 username）
- [x] 5.3 在项目根目录创建 `.gitignore` 文件
- [x] 5.4 在 `backend/` 目录创建 `.gitignore` 文件
- [x] 5.5 删除 admin 模块中重复的 `FileUploadUtils.java`（使用 common 模块的）
- [x] 5.6 统一密码校验规则：最小 6 位，最大 30 位
