# 技术债清理实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 修复代码审查中发现的技术债务，提升代码安全性、可维护性和可靠性

**Architecture:** 按优先级分层修复：严重问题（安全/稳定性）→ 重要问题（架构/功能）→ 次要问题（优化/规范）

**Tech Stack:** Spring Boot 3.5.9 / MyBatis-Plus / Vue 3 / TypeScript / JUnit 5

---

## 文件结构

### 后端修改文件
- `backend/common/src/main/resources/mapper/AdminMapper.xml` - 删除死代码
- `backend/common/src/main/java/com/tjetc/dao/AdminMapper.java` - 删除接口方法
- `backend/common/src/main/resources/data.sql` - 修复初始化脆弱性
- `backend/admin/src/main/java/com/tjetc/AdminApplication.java` - 移除无用注解
- `backend/admin/src/test/java/com/tjetc/service/AdminServiceImplTest.java` - 新增测试
- `backend/common/src/test/java/com/tjetc/common/FileUploadUtilsTest.java` - 新增测试

### 前端修改文件
- `frontend/src/api/upload.ts` - 统一上传函数

---

## 严重问题修复（合并前必须完成）

### Task 1: 删除 `selectByUsernameAndPassword` 死代码

**Files:**
- Modify: `backend/common/src/main/resources/mapper/AdminMapper.xml:23-37`
- Modify: `backend/common/src/main/java/com/tjetc/dao/AdminMapper.java`

- [ ] **Step 1: 确认无其他代码引用此方法**

```bash
cd backend
grep -r "selectByUsernameAndPassword" --include="*.java" --include="*.xml"
```

Expected: 仅在 AdminMapper.xml 和 AdminMapper.java 中找到

- [ ] **Step 2: 从 AdminMapper.xml 删除 SQL 查询**

删除以下代码块（约第 23-37 行）：
```xml
<!-- 根据用户名和密码查询管理员 -->
<select id="selectByUsernameAndPassword" resultType="com.tjetc.entity.userAndAdmin.Admin">
    SELECT
        id,
        username,
        password,
        avatar_path,
        email,
        telephone,
        qq,
        create_time,
        update_time
    FROM admin
    WHERE username = #{username} AND password = #{password}
</select>
```

- [ ] **Step 3: 从 AdminMapper.java 删除接口方法**

删除：
```java
Admin selectByUsernameAndPassword(@Param("username") String username, @Param("password") String password);
```

- [ ] **Step 4: 验证编译通过**

```bash
cd backend
mvn clean compile -pl common,admin
```

Expected: BUILD SUCCESS

- [ ] **Step 5: 运行现有测试**

```bash
cd backend
mvn test -pl common,admin
```

Expected: 所有测试通过（如果有）

- [ ] **Step 6: Commit**

```bash
git add backend/common/src/main/resources/mapper/AdminMapper.xml
git add backend/common/src/main/java/com/tjetc/dao/AdminMapper.java
git commit -m "fix: 删除 selectByUsernameAndPassword 死代码，避免安全混淆"
```

---

### Task 2: 修复 `data.sql` 初始化脆弱性

**Files:**
- Modify: `backend/common/src/main/resources/data.sql`

- [ ] **Step 1: 在 data.sql 开头添加数据库创建语句**

将 `data.sql` 修改为：
```sql
-- ============================================================
-- 校园充电桩管理系统 - 初始数据脚本
-- 说明: 使用 INSERT IGNORE 避免重复插入
-- ============================================================

-- 确保数据库存在（与 schema.sql 保持一致）
CREATE DATABASE IF NOT EXISTS campus_charging_station
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE campus_charging_station;

-- ============================================================
-- 默认管理员账号 (密码: admin123456, BCrypt加密)
-- ============================================================
INSERT IGNORE INTO admin (id, username, password, email) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVKIUi', 'admin@campus.com');

-- ============================================================
-- 示例充电桩数据
-- ============================================================
INSERT IGNORE INTO charging_stations (station_id, station_name, location, status, power_rating, price_per_hour) VALUES
(1, '校园北区充电站', '北区教学楼旁', 'available', 60.0, 1.50),
(2, '宿舍区充电站', '学生宿舍楼下', 'available', 30.0, 1.20),
(3, '图书馆充电站', '图书馆东侧', 'available', 60.0, 1.50),
(4, '体育馆充电站', '体育馆停车场', 'maintenance', 120.0, 2.00),
(5, '南门充电站', '南门停车场', 'available', 60.0, 1.50);
```

- [ ] **Step 2: 验证 SQL 语法**

```bash
# 如果有 MySQL 客户端，可以验证语法
mysql -u root -p -e "source backend/common/src/main/resources/data.sql" 2>&1 || echo "语法验证跳过（无 MySQL 客户端）"
```

- [ ] **Step 3: Commit**

```bash
git add backend/common/src/main/resources/data.sql
git commit -m "fix: 修复 data.sql 初始化脆弱性，添加 CREATE DATABASE IF NOT EXISTS"
```

---

## 重要问题修复（合并后 1 周内）

### Task 3: 移除 admin 模块无用的 `@EnableAsync`

**Files:**
- Modify: `backend/admin/src/main/java/com/tjetc/AdminApplication.java`

- [ ] **Step 1: 确认 admin 模块无 @Async 方法**

```bash
cd backend/admin
grep -r "@Async" --include="*.java" src/
```

Expected: 无结果

- [ ] **Step 2: 移除 @EnableAsync 注解和导入**

修改 `AdminApplication.java`：
```java
package com.tjetc;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.tjetc.dao")
public class AdminApplication {
    public static void main(String[] args) {
        SpringApplication.run(AdminApplication.class, args);
    }
}
```

- [ ] **Step 3: 验证编译通过**

```bash
cd backend
mvn clean compile -pl admin
```

Expected: BUILD SUCCESS

- [ ] **Step 4: Commit**

```bash
git add backend/admin/src/main/java/com/tjetc/AdminApplication.java
git commit -m "refactor: 移除 admin 模块无用的 @EnableAsync 注解"
```

---

### Task 4: 统一前端上传 API 的 FormData 处理

**Files:**
- Modify: `frontend/src/api/upload.ts`

- [ ] **Step 1: 查看当前 upload.ts 实现**

```bash
cat frontend/src/api/upload.ts
```

- [ ] **Step 2: 统一所有上传函数使用 FormData**

修改 `frontend/src/api/upload.ts`，确保所有函数都显式设置 `Content-Type: multipart/form-data`：

```typescript
import request from '../utils/request'

// 上传头像
export function uploadAvatar(file: File) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/upload/avatar',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 上传图片
export function uploadImage(file: File) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/upload/image',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 上传视频
export function uploadVideo(file: File) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/upload/video',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 通用文件上传
export function uploadFile(file: File) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/upload/file',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}
```

- [ ] **Step 3: 验证前端编译**

```bash
cd frontend
npm run build
```

Expected: 构建成功

- [ ] **Step 4: Commit**

```bash
git add frontend/src/api/upload.ts
git commit -m "fix: 统一上传 API 的 FormData 处理，避免文件序列化失败"
```

---

### Task 5: 添加 AdminServiceImpl 登录逻辑单元测试

**Files:**
- Create: `backend/admin/src/test/java/com/tjetc/service/AdminServiceImplTest.java`

- [ ] **Step 1: 创建测试目录结构**

```bash
mkdir -p backend/admin/src/test/java/com/tjetc/service
```

- [ ] **Step 2: 编写 BCrypt 登录测试**

创建 `AdminServiceImplTest.java`：
```java
package com.tjetc.service;

import com.tjetc.common.JsonResult;
import com.tjetc.dao.AdminMapper;
import com.tjetc.dto.AdminLoginDTO;
import com.tjetc.entity.userAndAdmin.Admin;
import com.tjetc.service.impl.AdminServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AdminServiceImplTest {

    @InjectMocks
    private AdminServiceImpl adminService;

    @Mock
    private AdminMapper adminMapper;

    @Mock
    private PasswordEncoder passwordEncoder;

    private Admin testAdmin;

    @BeforeEach
    void setUp() {
        testAdmin = new Admin();
        testAdmin.setId(1);
        testAdmin.setUsername("admin");
        testAdmin.setPassword("$2a$10$encodedPassword"); // BCrypt 加密后的密码
    }

    @Test
    void login_WithBCryptPassword_ShouldSucceed() {
        // Given
        AdminLoginDTO dto = new AdminLoginDTO();
        dto.setUsername("admin");
        dto.setPassword("admin123456");

        when(adminMapper.selectByUsername("admin")).thenReturn(testAdmin);
        when(passwordEncoder.matches("admin123456", "$2a$10$encodedPassword")).thenReturn(true);

        // When
        JsonResult result = adminService.login(dto);

        // Then
        assertEquals(0, result.getState());
        assertNotNull(result.getData());
    }

    @Test
    void login_WithWrongPassword_ShouldFail() {
        // Given
        AdminLoginDTO dto = new AdminLoginDTO();
        dto.setUsername("admin");
        dto.setPassword("wrongpassword");

        when(adminMapper.selectByUsername("admin")).thenReturn(testAdmin);
        when(passwordEncoder.matches("wrongpassword", "$2a$10$encodedPassword")).thenReturn(false);

        // When
        JsonResult result = adminService.login(dto);

        // Then
        assertNotEquals(0, result.getState());
        assertEquals("用户名或者密码不正确", result.getMessage());
    }

    @Test
    void login_WithPlaintextPassword_ShouldMigrateToBCrypt() {
        // Given
        testAdmin.setPassword("admin123456"); // 明文密码
        AdminLoginDTO dto = new AdminLoginDTO();
        dto.setUsername("admin");
        dto.setPassword("admin123456");

        when(adminMapper.selectByUsername("admin")).thenReturn(testAdmin);
        when(passwordEncoder.matches("admin123456", "admin123456")).thenReturn(false);
        when(passwordEncoder.encode("admin123456")).thenReturn("$2a$10$newEncodedPassword");
        when(adminMapper.updateById(any(Admin.class))).thenReturn(1);

        // When
        JsonResult result = adminService.login(dto);

        // Then
        assertEquals(0, result.getState());
        verify(adminMapper).updateById(any(Admin.class));
        assertEquals("$2a$10$newEncodedPassword", testAdmin.getPassword());
    }

    @Test
    void login_WithNonExistentUser_ShouldFail() {
        // Given
        AdminLoginDTO dto = new AdminLoginDTO();
        dto.setUsername("nonexistent");
        dto.setPassword("password");

        when(adminMapper.selectByUsername("nonexistent")).thenReturn(null);

        // When
        JsonResult result = adminService.login(dto);

        // Then
        assertNotEquals(0, result.getState());
        assertEquals("用户名或者密码不正确", result.getMessage());
    }
}
```

- [ ] **Step 3: 运行测试**

```bash
cd backend
mvn test -pl admin -Dtest=AdminServiceImplTest
```

Expected: 所有测试通过

- [ ] **Step 4: Commit**

```bash
git add backend/admin/src/test/java/com/tjetc/service/AdminServiceImplTest.java
git commit -m "test: 添加 AdminServiceImpl 登录逻辑单元测试"
```

---

### Task 6: 添加 FileUploadUtils 安全测试

**Files:**
- Create: `backend/common/src/test/java/com/tjetc/common/FileUploadUtilsTest.java`

- [ ] **Step 1: 创建测试目录结构**

```bash
mkdir -p backend/common/src/test/java/com/tjetc/common
```

- [ ] **Step 2: 编写文件上传安全测试**

创建 `FileUploadUtilsTest.java`：
```java
package com.tjetc.common;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.springframework.mock.web.MockMultipartFile;

import java.io.IOException;
import java.nio.file.Path;

import static org.junit.jupiter.api.Assertions.*;

class FileUploadUtilsTest {

    @TempDir
    Path tempDir;

    @Test
    void upload_WithValidImage_ShouldSucceed() {
        // Given
        MockMultipartFile file = new MockMultipartFile(
                "file", "test.jpg", "image/jpeg", "test content".getBytes()
        );
        String basePath = tempDir.toString();
        String returnPathPrefix = "image";

        // When
        JsonResult result = FileUploadUtils.upload(file, basePath, returnPathPrefix);

        // Then
        assertEquals(0, result.getState());
        assertNotNull(result.getData());
        assertTrue(result.getData().toString().contains(".jpg"));
    }

    @Test
    void upload_WithEmptyFile_ShouldFail() {
        // Given
        MockMultipartFile file = new MockMultipartFile(
                "file", "empty.jpg", "image/jpeg", new byte[0]
        );

        // When
        JsonResult result = FileUploadUtils.upload(file, tempDir.toString(), "image");

        // Then
        assertNotEquals(0, result.getState());
        assertTrue(result.getMessage().contains("不能为空"));
    }

    @Test
    void upload_WithNullFile_ShouldFail() {
        // When
        JsonResult result = FileUploadUtils.upload(null, tempDir.toString(), "image");

        // Then
        assertNotEquals(0, result.getState());
    }

    @Test
    void upload_WithDisallowedExtension_ShouldFail() {
        // Given
        MockMultipartFile file = new MockMultipartFile(
                "file", "malware.exe", "application/octet-stream", "malware".getBytes()
        );

        // When
        JsonResult result = FileUploadUtils.upload(file, tempDir.toString(), "file");

        // Then
        assertNotEquals(0, result.getState());
        assertTrue(result.getMessage().contains("不支持的文件类型"));
    }

    @Test
    void upload_WithPathTraversal_ShouldSanitize() {
        // Given
        MockMultipartFile file = new MockMultipartFile(
                "file", "../../../etc/passwd.jpg", "image/jpeg", "content".getBytes()
        );

        // When
        JsonResult result = FileUploadUtils.upload(file, tempDir.toString(), "image");

        // Then
        assertEquals(0, result.getState());
        assertFalse(result.getData().toString().contains(".."));
    }

    @Test
    void upload_WithNoExtension_ShouldFail() {
        // Given
        MockMultipartFile file = new MockMultipartFile(
                "file", "noextension", "application/octet-stream", "content".getBytes()
        );

        // When
        JsonResult result = FileUploadUtils.upload(file, tempDir.toString(), "file");

        // Then
        assertNotEquals(0, result.getState());
        assertTrue(result.getMessage().contains("扩展名"));
    }
}
```

- [ ] **Step 3: 运行测试**

```bash
cd backend
mvn test -pl common -Dtest=FileUploadUtilsTest
```

Expected: 所有测试通过

- [ ] **Step 4: Commit**

```bash
git add backend/common/src/test/java/com/tjetc/common/FileUploadUtilsTest.java
git commit -m "test: 添加 FileUploadUtils 安全测试用例"
```

---

## 次要问题修复（合并后 1 个月内）

### Task 7: 改进 BCrypt 迁移路径密码比较

**Files:**
- Modify: `backend/admin/src/main/java/com/tjetc/service/impl/AdminServiceImpl.java`

- [ ] **Step 1: 添加 MessageDigest 导入**

在文件顶部添加：
```java
import java.security.MessageDigest;
import java.nio.charset.StandardCharsets;
```

- [ ] **Step 2: 创建安全比较方法**

在类中添加私有方法：
```java
/**
 * 安全的密码比较（常量时间，防止时序攻击）
 */
private boolean securePasswordEquals(String rawPassword, String encodedPassword) {
    try {
        byte[] rawBytes = rawPassword.getBytes(StandardCharsets.UTF_8);
        byte[] encodedBytes = encodedPassword.getBytes(StandardCharsets.UTF_8);
        return MessageDigest.isEqual(rawBytes, encodedBytes);
    } catch (Exception e) {
        return false;
    }
}
```

- [ ] **Step 3: 替换两处 password.equals() 调用**

将：
```java
if (password.equals(admin.getPassword())) {
```

替换为：
```java
if (securePasswordEquals(password, admin.getPassword())) {
```

注意：需要替换两处（两个 login 方法中）

- [ ] **Step 4: 运行测试**

```bash
cd backend
mvn test -pl admin
```

Expected: 所有测试通过

- [ ] **Step 5: Commit**

```bash
git add backend/admin/src/main/java/com/tjetc/service/impl/AdminServiceImpl.java
git commit -m "fix: 使用 MessageDigest.isEqual 进行常量时间密码比较"
```

---

## 风险清单

| 编号 | 风险等级 | 风险描述 | 对应任务 | 状态 |
|------|----------|----------|----------|------|
| R1 | 🔴 高 | selectByUsernameAndPassword 死代码 | Task 1 | ⬜ 待修复 |
| R2 | 🔴 高 | data.sql USE 语句脆弱性 | Task 2 | ⬜ 待修复 |
| R3 | 🟡 中 | @EnableAsync 无用 | Task 3 | ⬜ 待修复 |
| R4 | 🟡 中 | 上传 API 未统一 FormData | Task 4 | ⬜ 待修复 |
| R5 | 🔴 高 | 缺少安全关键代码测试 | Task 5, 6 | ⬜ 待修复 |
| R6 | 🟢 低 | 密码比较非常量时间 | Task 7 | ⬜ 待修复 |

---

## 执行顺序建议

### 阶段一：合并前（必须）
1. Task 1: 删除死代码
2. Task 2: 修复 data.sql

### 阶段二：合并后 1 周内
3. Task 3: 移除无用注解
4. Task 4: 统一上传 API
5. Task 5: 添加登录测试
6. Task 6: 添加上传测试

### 阶段三：合并后 1 个月内
7. Task 7: 改进密码比较

---

## 验证清单

完成所有任务后，运行以下验证：

- [ ] 后端编译通过：`cd backend && mvn clean compile`
- [ ] 后端测试通过：`cd backend && mvn test`
- [ ] 前端构建通过：`cd frontend && npm run build`
- [ ] 管理端构建通过：`cd admin-frontend && npm run build`
- [ ] 无安全警告：检查日志中无 BCrypt 相关警告
- [ ] 功能正常：手动测试登录、文件上传功能
