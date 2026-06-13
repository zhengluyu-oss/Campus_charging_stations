// ets/apis/ReservationApi.ets
import { httpRequest, JsonResult } from '../utils/HttpUtil';
import { ChargingStation, Reservation, ReserveParam, CancelParam } from '../viewmodel/ReservationModel';

// 1. 获取所有充电桩
// 泛型1: JsonResult<ChargingStation[]> (返回类型)
// 泛型2: null (无请求参数)
export function getAllStations() {
  return httpRequest.get<JsonResult<ChargingStation[]>, null>('/showAll', null);
}

// 2. 获取指定充电桩的预约情况
export function getStationReservations(stationId: number) {
  return httpRequest.get<JsonResult<Reservation[]>, null>(`/reversation/getStationReservations?stationId=${stationId}`, null);
}

// 3. 获取当前用户的预约记录
export function getUserReservations(userId: string | number) {
  return httpRequest.get<JsonResult<Reservation[]>, null>(`/reversation/getUserReservations?userId=${userId}`, null);
}

// 4. 提交预约
// 泛型1: JsonResult<Reservation>
// 泛型2: ReserveParam
export function reserve(param: ReserveParam) {
  return httpRequest.post<JsonResult<Reservation>, ReserveParam>('/reversation/reserve', param);
}

// 5. 取消预约
// 泛型1: JsonResult<null>
// 泛型2: CancelParam
export function cancelReservation(param: CancelParam) {
  return httpRequest.post<JsonResult<null>, CancelParam>('/reversation/cancel', param);
}