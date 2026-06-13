export interface User {
    id: number
    username: string
    password: string
    avatarPath: string
    email: string,
    telephone: string,
    qq: string,
    updateTime: string,
    createTime: string,
    licensePlate?: string, // 车牌号，可选字段
    carModel?: string      // 车辆型号，可选字段
    // 兼容后端可能返回的字段名
    avatar_path?: string   // 后端可能返回的字段名
    phone?: string         // 后端可能返回的字段名
    updated_time?: string  // 后端可能返回的字段名
    created_time?: string  // 后端可能返回的字段名
}