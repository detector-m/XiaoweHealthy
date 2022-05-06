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
//    func postHeart(deviceSn: String, data: [XWHHeartModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
//        let reqData = data.toJSON()
//        guard let reqData = reqData as? [[String: Any]] else {
//            log.error(tdParseFailed)
//            return
//        }
//
//        healthyProvider.request(.postHeart(deviceSn, reqData)) { result in
//            let cId = "Healthy.PostHeart"
//            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
//                
//                return nil
//            }
//        }
//    }
    
    /// 用户心率数据是否存在查询
    func getHeartExistDate(date: Date, dateType: XWHHealthyDateSegmentType, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        healthyProvider.request(.getHeartExistDate(date.year, date.month, dateType.rawValue)) { result in
            let cId = "Healthy.GetHeartExistDate"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                response.code = dateType.rawValue
                
                guard let items = json.arrayObject as? [String] else {
                    log.error("\(cId) 获取用户心率数据是否存在错误")
                    return nil
                }
                
                response.data = self.getExistDataDateModel(date, dateType, items)
                
                return nil
            }
        }
    }
    
    /// 获取心率数据
    func getHeart(date: Date, dateType: XWHHealthyDateSegmentType, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        healthyProvider.request(.getHeart(date.year, date.month, date.day, dateType.rawValue)) { result in
            let cId = "Healthy.GetHeart"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = XWHHeartUIHeartModel.deserialize(from: json.dictionaryObject)
                return nil
            }
        }
    }

    
    /// 获取心率年的历史数据
    func getYearHeartHistory(date: Date, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        healthyProvider.request(.getHeartHistory(date.year, date.month, date.day, XWHHealthyDateSegmentType.year.rawValue)) { result in
            let cId = "Healthy.GetYearHeartHistory"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = [XWHHeartUIAllDataItemModel].deserialize(from: json.arrayObject)
                return nil
            }
        }
    }
    
    /// 获取心率日的历史数据
    func getDayHeartHistory(date: Date, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        healthyProvider.request(.getHeartHistory(date.year, date.month, date.day, XWHHealthyDateSegmentType.day.rawValue)) { result in
            let cId = "Healthy.GetYearHeartHistory"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = [XWHHeartModel].deserialize(from: json.arrayObject)
                return nil
            }
        }
    }
    
    /// 获取心率记录的详情数据
    func getHeartDetail(rId: Int, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        healthyProvider.request(.getHeartDetail(rId)) { result in
            let cId = "Healthy.GetHeartDetail"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = XWHHeartModel.deserialize(from: json.dictionaryObject)
                return nil
            }
        }
    }
    
    
    // MARK: - 血氧(心率)
    /// 上传血氧数据
//    func postBloodOxygen(deviceSn: String, data: [XWHBloodOxygenModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
//        let reqData = data.toJSON()
//        guard let reqData = reqData as? [[String: Any]] else {
//            log.error(tdParseFailed)
//            return
//        }
//
//        healthyProvider.request(.postBloodOxygen(deviceSn, reqData)) { result in
//            let cId = "Healthy.PostBloodOxygen"
//            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
//
//                return nil
//            }
//        }
//    }
    
    /// 用户血氧数据是否存在查询
    func getBloodOxygenExistDate(date: Date, dateType: XWHHealthyDateSegmentType, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        healthyProvider.request(.getBloodOxygenExistDate(date.year, date.month, dateType.rawValue)) { result in
            let cId = "Healthy.GetBloodOxygenExistDate"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                response.code = dateType.rawValue
                guard let items = json.arrayObject as? [String] else {
                    log.error("\(cId) 获取用户血氧数据是否存在错误")
                    return nil
                }
                
                response.data = self.getExistDataDateModel(date, dateType, items)
                return nil
            }
        }
    }
    
    /// 获取血氧数据
    func getBloodOxygen(date: Date, dateType: XWHHealthyDateSegmentType, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        healthyProvider.request(.getBloodOxygen(date.year, date.month, date.day, dateType.rawValue)) { result in
            let cId = "Healthy.GetBloodOxygen"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                response.data = XWHBOUIBloodOxygenModel.deserialize(from: json.dictionaryObject)
                
                return nil
            }
        }
    }
    
    /// 获取血氧年的历史数据
    func getYearBloodOxygenHistory(date: Date, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        healthyProvider.request(.getBloodOxygenHistory(date.year, date.month, date.day, XWHHealthyDateSegmentType.year.rawValue)) { result in
            let cId = "Healthy.GetYearBloodOxygenHistory"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in

                response.data = [XWHBOUIBloodOxygenAllDataItemModel].deserialize(from: json.arrayObject)
                return nil
            }
        }
    }
    
    /// 获取血氧日的历史数据
    func getDayBloodOxygenHistory(date: Date, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        healthyProvider.request(.getBloodOxygenHistory(date.year, date.month, date.day, XWHHealthyDateSegmentType.day.rawValue)) { result in
            let cId = "Healthy.GetDayBloodOxygenHistory"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = [XWHBloodOxygenModel].deserialize(from: json.arrayObject)
                return nil
            }
        }
    }
    
    /// 获取血氧记录的详情数据
    func getBloodOxygenDetail(rId: Int, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        healthyProvider.request(.getBloodOxygenDetail(rId)) { result in
            let cId = "Healthy.GetBloodOxygenDetail"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = XWHBloodOxygenModel.deserialize(from: json.dictionaryObject)
                return nil
            }
        }
    }
    
}

// MARK: - Private
extension XWHHealthyVM {
    
    private func getExistDataDateModel(_ sDate: Date, _ sDateType: XWHHealthyDateSegmentType, _ items: [String]) -> XWHHealthyExistDataDateModel? {
        if items.isEmpty {
            return nil
        }

        var cId: String = ""
        switch sDateType {
        case .day, .week:
            cId = sDate.string(withFormat: "yyyy-MM")
            
        case .month, .year:
            cId = sDate.year.string
        }
        
        var tItems = items.compactMap({ $0.date(withFormat: "yyyy-MM-dd") })
        if sDateType == .year {
            tItems = tItems.filter({ $0.year.string == cId })
        }
        if tItems.isEmpty {
            return nil
        }
        
        let cModel = XWHHealthyExistDataDateModel()
        cModel.identifier = cId
        cModel.code = sDateType.rawValue
        cModel.items = tItems
        
        return cModel
    }
    
}
