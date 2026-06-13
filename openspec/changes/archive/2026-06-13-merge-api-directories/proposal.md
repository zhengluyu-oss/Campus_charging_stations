## Why

前端项目存在两个功能相同的 API 目录（`api/` 和 `apis/`），命名不一致，结构混乱，需要合并为统一的目录以提高代码可维护性。

## What Changes

- 将 `apis/` 目录下的文件移动到 `api/` 目录
- 更新所有引用路径
- 删除空的 `apis/` 目录

## Capabilities

### New Capabilities

### Modified Capabilities

## Impact

- `frontend/src/api/` — 目标目录
- `frontend/src/apis/` — 源目录（将被删除）
- 所有引用 `@/apis/` 的文件需要更新路径
