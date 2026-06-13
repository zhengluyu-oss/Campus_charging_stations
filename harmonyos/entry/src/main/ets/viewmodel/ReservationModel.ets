// ets/viewmodel/ReservationModel.ets

// 对应后端 ChargingStation 实体
export interface ChargingStation {
  stationId: number; // 对应后端 stationId
  stationName: string; // 对应后端 stationName
  location: string;
  status: string;
  type?: string;
  power?: string;
  powerRating?: string; // 对应后端 powerRating
  pricePerHour?: number; // 对应后端 pricePerHour
}

// 对应后端 Reservation 实体
export interface Reservation {
  reservationId: number;
  userId: number;
  stationId: number;
  reservedStartTime: string; // 后端 LocalDateTime 序列化为字符串
  reservedEndTime: string;
  status: string; // confirmed, used, cancelled
  createdAt?: string;
}

// 预约请求参数
export interface ReserveParam {
  stationId: number;
  userId: string | number;
  startTime: string;
  endTime: string;
}

// 取消预约参数
export interface CancelParam {
  reservationId: number;
  userId: string | number;
}