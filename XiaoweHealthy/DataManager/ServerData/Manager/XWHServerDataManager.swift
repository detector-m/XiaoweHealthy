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

        serverDataProvider.request(.postHeart(deviceSn, reqData)) { result in
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                return nil
            }
        }
    }
    
    // MARK: - 血氧(心率)
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
        
        serverDataProvider.request(.postBloodOxygen(deviceSn, reqData)) { result in
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
