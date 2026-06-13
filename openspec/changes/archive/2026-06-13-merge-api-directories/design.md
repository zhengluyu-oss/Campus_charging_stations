## Context

前端项目存在两个 API 目录：`api/`（含 chargingStationsApi.ts）和 `apis/`（含 charging.ts, user.ts, news.ts, upload.ts）。需要合并为统一的 `api/` 目录。

## Goals / Non-Goals

**Goals:**
- 合并两个目录为统一的 `api/`
- 更新所有引用路径
- 保持功能不变

**Non-Goals:**
- 不修改 API 函数的实现逻辑
- 不重命名函数

## Decisions

**决定**: 将 `apis/` 下的文件移动到 `api/`，更新所有 import 路径。

**原因**: `api/` 是更常见的命名，且已有 `chargingStationsApi.ts`。

## Risks / Trade-offs

| 风险 | 缓解措施 |
|------|---------|
| 遗漏某些引用 | 使用 grep 全面搜索 |
