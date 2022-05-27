//
//  XWHServerDataManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import Foundation


class XWHServerDataManager {
    
    // MARK: - Heart(心率)
    /// 上传心率数据
    class func postHeart(deviceSn: String, data: [XWHHeartModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        XWHServerDataManager().postHeart(deviceSn: deviceSn, data: data, failureHandler: failureHandler, successHandler: successHandler)
    }
    
    /// 上传心率数据
    func postHeart(deviceSn: String, data: [XWHHeartModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cId = "XWHServerDataManager.PostHeart"

        let reqData = data.toJSON()
        guard let reqData = reqData as? [[String: Any]] else {
            handleDataParseError(cId, failureHandler)
            return
        }

        log.debug("requestId = \(cId) 上传数据")
        serverDataProvider.request(.postHeart(deviceSn, reqData)) { result in
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                return nil
            }
        }
    }
    
    // MARK: - BloodOxygen(血氧)
    /// 上传血氧数据
    class func postBloodOxygen(deviceSn: String, data: [XWHBloodOxygenModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        XWHServerDataManager().postBloodOxygen(deviceSn: deviceSn, data: data, failureHandler: failureHandler, successHandler: successHandler)
    }
    
    func postBloodOxygen(deviceSn: String, data: [XWHBloodOxygenModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cId = "XWHServerDataManager.PostBloodOxygen"

        let reqData = data.toJSON()
        guard let reqData = reqData as? [[String: Any]] else {
            handleDataParseError(cId, failureHandler)
            return
        }
        
        log.debug("requestId = \(cId) 上传数据")
        serverDataProvider.request(.postBloodOxygen(deviceSn, reqData)) { result in
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                return nil
            }
        }
    }
    
    // MARK: - Sleep(睡眠)
    /// 上传睡眠
    class func postSleep(deviceSn: String, data: [XWHSleepModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        XWHServerDataManager().postSleep(deviceSn: deviceSn, data: data, failureHandler: failureHandler, successHandler: successHandler)
    }
    func postSleep(deviceSn: String, data: [XWHSleepModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cId = "XWHServerDataManager.PostSleep"

        let reqData = data.toJSON()
        guard let reqData = reqData as? [[String: Any]] else {
            handleDataParseError(cId, failureHandler)
            return
        }
        
        log.debug("requestId = \(cId) 上传数据")
        serverDataProvider.request(.postSleep(deviceSn, reqData)) { result in
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                return nil
            }
        }
    }
    
    // MARK: - MentalState(精神状态)
    /// 上传精神状态数据 （压力、情绪、疲劳度数据）
    class func postMentalState(deviceSn: String, data: [XWHMentalStateModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        XWHServerDataManager().postMentalState(deviceSn: deviceSn, data: data, failureHandler: failureHandler, successHandler: successHandler)
    }
    func postMentalState(deviceSn: String, data: [XWHMentalStateModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cId = "XWHServerDataManager.postMentalState"

        let reqData = data.toJSON()
        guard let reqData = reqData as? [[String: Any]] else {
            handleDataParseError(cId, failureHandler)
            return
        }
        
        log.debug("requestId = \(cId) 上传数据")
        serverDataProvider.request(.postMentalState(deviceSn, reqData)) { result in
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                return nil
            }
        }
    }
    
}

extension XWHServerDataManager {
    
    private static let kParseFailedString = "数据解析错误"
    
    private func handleDataParseError(_ cId: String, _ failureHandler: FailureHandler? = nil) {
        var error = XWHError(message: XWHServerDataManager.kParseFailedString)
        error.identifier = cId
        log.error(error)
        failureHandler?(error)
    }
    
}
