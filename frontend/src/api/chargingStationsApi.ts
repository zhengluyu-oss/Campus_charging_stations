import request from '@/utils/request';

// 获取所有充电桩
export function getAllChargingStations() {
  return request({
    url: '/api/showAll',
    method: 'get'
  });
}

// 根据位置获取充电桩
export function getChargingStationsByLocation(location: string) {
  return request({
    url: '/api/showByLocation',
    method: 'post',
    data: {
      location: location
    }
  });
}

// 根据状态获取充电桩
export function getChargingStationsByStatus(status: number) {
  return request({
    url: '/api/showByStatus',
    method: 'post',
    data: {
      status: status.toString()
    }
  });
}

// 开始充电
export function startCharging(userId: number, stationId: number, chargingDuration: number) {
  return request({
    url: '/user/charging/start',
    method: 'post',
    data: {
      userId: userId,
      stationId: stationId,
      chargingDuration: chargingDuration
    }
  });
}

// 结束充电
export function stopCharging(stationId: number) {
  return request({
    url: '/user/charging/stop',
    method: 'post',
    params: {
      stationId: stationId
    }
  });
}

// 预约充电桩
export function reserveChargingStation(userId: number, stationId: number, delayMinutes: number, chargingDuration: number) {
  return request({
    url: '/reversation/reserve',
    method: 'post',
    data: {
      userId: userId,
      stationId: stationId,
      delayMinutes: delayMinutes,
      chargingDuration: chargingDuration
    }
  });
}

// 获取充电记录
export function getChargingHistory(userId: number) {
  return request({
    url: '/api/selectAll',
    method: 'post',
    data: {
      userId: userId
    }
  });
}