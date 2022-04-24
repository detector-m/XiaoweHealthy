//
//  XWHHealthyVM.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/22.
//

import Foundation
import HandyJSON


class XWHHealthyVM {
    
    // MARK: - Heart(心率)
    /// 上传心率数据
    func postHeart(deviceSn: String, data: [XWHHeartModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let reqData = data.toJSON()
        guard let reqData = reqData as? [[String: Any]] else {
            log.error(tdParseFailed)
            return
        }

        healthyProvider.request(.postHeart(deviceSn, reqData)) { result in
            let cId = "Healthy.PostHeart"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                return nil
            }
        }
    }
    
    /// 获取心率数据
    func getHeart(date: Date, dateType: XWHHealthyDateSegmentType, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        healthyProvider.request(.getHeart(date.year, date.month, date.day, dateType.rawValue)) { result in
            let cId = "Healthy.GetHeart"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
//                response.data = [XWHDeviceProductModel].deserialize(from: json.arrayObject)
                
                return nil
            }
        }
    }
    
    
    // MARK: - 血氧(心率)
    /// 上传血氧数据
    func postBloodOxygen(deviceSn: String, data: [XWHBloodOxygenModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let reqData = data.toJSON()
        guard let reqData = reqData as? [[String: Any]] else {
            log.error(tdParseFailed)
            return
        }
        
        healthyProvider.request(.postBloodOxygen(deviceSn, reqData)) { result in
            let cId = "Healthy.PostBloodOxygen"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                return nil
            }
        }
    }
    
    /// 获取血氧数据
    func getBloodOxygen(date: Date, dateType: XWHHealthyDateSegmentType, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        healthyProvider.request(.getBloodOxygen(date.year, date.month, date.day, dateType.rawValue)) { result in
            let cId = "Healthy.GetBloodOxygen"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
//                response.data = [XWHDeviceProductModel].deserialize(from: json.arrayObject)
                
                return nil
            }
        }
    }
    
}
