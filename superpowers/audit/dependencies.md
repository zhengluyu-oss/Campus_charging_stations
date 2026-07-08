# 依赖与技术债审计报告

## 1. 第三方依赖概览

### 1.1 后端 Maven 依赖

| 依赖 | 当前版本 | 类型 | 评估 |
|------|---------|------|------|
| Spring Boot | 3.5.9 | 框架 | ✅ LTS 最新版 |
| JDK | 17 | 运行时 | ✅ LTS 支持中 |
| MyBatis-Plus | 3.5.15 | ORM | ✅ 最新版 |
| PageHelper | 2.1.1 | 分页 | ✅ 兼容 |
| jjwt | 0.12.5 | JWT | ✅ 最新版 |
| commons-lang3 | 3.20.0 | 工具 | ✅ 最新版 |
| SpringDoc OpenAPI | 2.3.0 | API 文档 | ✅ 兼容 Spring Boot 3.x |
| lombok | 1.18.36 | 注解 | ✅ 最新版 |
| spring-security-crypto | (由 spring boot parent 管理) | 加密 | ✅ |
| flatten-maven-plugin | 1.6.0 | 构建 | ✅ 最新版 |

### 1.2 前端 npm 依赖

| 依赖 | 当前版本 | 类型 | 评估 |
|------|---------|------|------|
| vue | ^3.5.16 | 框架 | ✅ 最新 3.5.x |
| vue-router | ^4.6.2 | 路由 | ✅ 最新 |
| pinia | ^3.0.2 | 状态管理 | ✅ Pinia 3.x |
| pinia-plugin-persistedstate | ^4.1.3 | 持久化 | ✅ 最新 |
| element-plus | ^2.13.0 | UI 组件 | ✅ 最新 |
| axios | ^1.9.0 | HTTP | ✅ 最新 |
| three | ^0.175.0 | 3D 引擎 | ✅ 最新 |
| @mediapipe/hands | ^0.4.1675469240 | 手势识别 | ⚠️ 已归档，Google 已迁移至 MediaPipe Solutions |
| qs | ^6.14.0 | 查询字符串 | ✅ |
| @vitejs/plugin-vue | ^5.2.4 | Vite 插件 | ✅ |
| typescript | ~5.9.0 | 语言 | ✅ |
| **rolldown-vite** | **^7.2.5** | **构建工具** | **⚠️ 实验性** |
| vue-tsc | ^2.2.10 | TS 编译器 | ✅ |

---

## 2. 安全漏洞扫描

### 2.1 已知 CVE 检查

> ⚠️ **注意**: 项目未集成任何依赖安全扫描工具（如 OWASP Dependency-Check、Snyk、Dependabot）。

以下依赖已知有历史 CVE，当前版本是否受影响需进一步确认：

| 依赖 | 已知风险 | 操作建议 |
|------|---------|---------|
| **jjwt 0.12.5** | 低风险 | 0.12.x 已修复早期版本中签名绕过和密钥管理问题 ✅ |
| **Spring Boot 3.5.9** | 需关注 | 使用最新 patch 版本 |
| **axios 1.9.0** | 低风险 | 1.x 已修复 SSRF 和原型污染问题 |
| **lodash (间接依赖)** | 中风险 | 需检查是否有间接依赖的旧版 lodash |
| **tough-cookie (间接依赖)** | 中风险 | 需检查是否有间接依赖的旧版 |

### 2.2 立即建议

1. **集成依赖安全扫描**: 
   - 后端: 添加 `org.owasp:dependency-check-maven` 插件
   - 前端: 启用 `npm audit` 或集成 GitHub Dependabot
2. **后端添加**: 
   ```xml
   <plugin>
     <groupId>org.owasp</groupId>
     <artifactId>dependency-check-maven</artifactId>
     <version>11.1.1</version>
   </plugin>
   ```
3. **前端配置**: `npm audit` 在 CI 中作为必过步骤

---

## 3. 过时或高风险依赖

### P2 — rolldown-vite（实验性构建工具）

**文件**: `admin-frontend/package.json` 第 31 行、`frontend/package.json`
**严重度: P2 — Medium**

```json
{
  "devDependencies": {
    "rolldown-vite": "^7.2.5"
  }
}
```

`rolldown-vite` 是 Vite 的一个实验性分支，使用 Rust 打包器 Rolldown 替代 Rollup。

**风险**:
1. 非官方主流版本，社区支持有限
2. 可能存在与 Vue 3、Element Plus 等依赖的兼容性问题
3. 在 `dist/` 构建输出中已经发现生成的文件名和 chunk 结构与标准 Vite 有差异
4. 升级官方 Vite 时需要进行迁移

**建议**: 回退到官方 `vite` 包：
```json
{
  "devDependencies": {
    "vite": "^6.3.0",
    "vite-plugin-vue": "^5.2.4"
  }
}
```

### P2 — @mediapipe/hands 已归档

**文件**: 两个前端项目的 `package.json`
**严重度: P2 — Medium**

```json
"@mediapipe/hands": "^0.4.1675469240",
"@mediapipe/camera_utils": "^0.3.1675466862",
"@mediapipe/drawing_utils": "^0.3.1675466124"
```

Google MediaPipe 团队已停止维护 JavaScript SDK，迁移至新的 `@mediapipe/tasks-vision` 包。

**风险**:
1. 不再获得安全更新和性能优化
2. 在新型浏览器上可能不再兼容
3. 除非项目活跃使用手势识别功能，否则可移除

**建议**: 
1. 评估手势识别功能是否被实际使用
2. 如不再使用，移除依赖以减小构建体积
3. 如继续使用，升级至 `@mediapipe/tasks-vision` 或使用 WebAssembly 版本

### ✅ 版本检查通过项

| 检查项 | 状态 |
|--------|------|
| Spring Boot 3.5.9 使用最新 patch 版本 | ✅ |
| MyBatis-Plus 3.5.15 使用最新版本 | ✅ |
| jjwt 0.12.5 使用推荐版本 | ✅ |
| Lombok 最新版 | ✅ |
| Element Plus 2.13 最新版 | ✅ |
| Vue 3.5 最新版 | ✅ |
| Pinia 3 最新版 | ✅ |
| commons-lang3 3.20 最新版 | ✅ |

---

## 4. 技术债务

### 4.1 技术债汇总

| 类别 | 项目 | 优先级 | 估算工时 |
|------|------|--------|---------|
| **架构重构** | 合并 ChargingStationController 和 ChargingPileController | P2 | 2h |
| **架构重构** | 统一分页方案（清除 PageHelper，统一 MP Page） | P2 | 4h |
| **架构重构** | 清理废弃前端组件（AdminHeader/Sidebar/Layout） | P2 | 1h |
| **功能补全** | NewsManagement.vue 页面完整化 | P2 | 3h |
| **功能修复** | 充电桩状态值统一（1/0 vs available/occupied） | P0 | 3h |
| **异步重构** | Thread.sleep() 替换为 Redis 延时队列 | P0 | 8h |
| **测试** | 为核心模块编写单元测试 | P2 | 16h |
| **代码清理** | 提取重复 CSS 到共享文件 | P2 | 2h |
| **代码清理** | 提取公共辅助函数到 utils | P2 | 1h |
| **安全加固** | Token 存储方案升级 | P1 | 4h |
| **安全加固** | RBAC 权限控制 | P1 | 8h |
| **性能优化** | 添加缺失的数据库索引 | P1 | 1h |
| **配置修复** | 生产环境关闭 Swagger | P2 | 0.5h |
| **依赖升级** | rolldown-vite 回退到官方 Vite | P2 | 1h |
| **依赖清理** | 评估 MediaPipe 手势识别依赖 | P3 | 1h |

### 4.2 技术债评分

| 维度 | 评分 | 说明 |
|------|------|------|
| 依赖新鲜度 | ⭐⭐⭐⭐☆ | 大部分依赖为最新版，rolldown-vite 和 @mediapipe 例外 |
| 技术栈一致性 | ⭐⭐⭐☆☆ | 多种分页方案并存 |
| 代码可维护性 | ⭐⭐⭐☆☆ | 重复代码较多，但整体结构清晰 |
| 测试覆盖 | ⭐☆☆☆☆☆ | 严重不足 |
| 安全实践 | ⭐⭐⭐☆☆ | 基础安全实践到位，纵深防御不足 |

**综合技术债评分: 2.8 / 5.0**（中等）

---

## 5. 修复优先级矩阵

| 编号 | 项目 | P0 | P1 | P2 | P3 | 估时 |
|------|------|:--:|:--:|:--:|:--:|:----:|
| 1 | 充电桩状态值统一 | ✓ | | | | 3h |
| 2 | @Async Thread.sleep 重构 | ✓ | | | | 8h |
| 3 | Token 安全性（localStorage） | | ✓ | | | 4h |
| 4 | RBAC 权限控制 | | ✓ | | | 8h |
| 5 | 数据库索引优化 | | ✓ | | | 1h |
| 6 | dev.yml 密码加固 | | ✓ | | | 0.5h |
| 7 | 代码重复清理 | | | ✓ | | 3h |
| 8 | 统一分页方案 | | | ✓ | | 4h |
| 9 | 重复 Controller 合并 | | | ✓ | | 2h |
| 10 | 废弃组件清理 | | | ✓ | | 1h |
| 11 | 单元测试 | | | ✓ | | 16h |
| 12 | 角色校验（后端） | | ✓ | | | 4h |
| 13 | Swagger 生产关闭 | | | ✓ | | 0.5h |
| 14 | rolldown-vite 回退 | | | ✓ | | 1h |
| 15 | 新闻缓存一致性 | | | ✓ | | 2h |
| 16 | 前端密码传输优化 | | | | ✓ | 1h |
| 17 | MediaPipe 依赖评估 | | | | ✓ | 1h |
| 18 | 日志敏感数据处理 | | | ✓ | | 1h |

**总估算工时: ~60 小时**
