/**
 * 充电桩实体模型类
 * 与后端com.tjetc.entity.core.ChargingStation实体类对应
 */
export interface ChargingStation {
  /**
   * 充电桩ID
   */
  stationId?: number;

  /**
   * 充电桩名称
   */
  stationName: string;

  /**
   * 位置信息 - 字符串格式（对应后端String类型）
   */
  location: string;

  /**
   * 状态 - 0表示关闭，1表示开启（对应后端Integer类型）
   */
  status: number;

  /**
   * 功率等级（单位：kW）
   */
  powerRating: number;

  /**
   * 每小时价格（单位：元）
   */
  pricePerHour: number;

  /**
   * 创建时间
   */
  createdTime?: string;

  /**
   * 更新时间
   */
  updatedTime?: string;
}

/**
 * 充电桩状态枚举
 */
export enum ChargingStationStatus {
  INACTIVE = 0,  // 关闭/不可用
  ACTIVE = 1     // 开启/可用
}