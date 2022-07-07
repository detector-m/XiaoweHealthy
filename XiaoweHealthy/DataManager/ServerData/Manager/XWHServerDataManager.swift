//
//  XWHServerDataManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import Foundation


class XWHServerDataManager {
    
    // MARK: - Heart(心率)
    /// 上传心率数据到服务
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    class func postHeart(deviceMac: String, deviceSn: String, data: [XWHHeartModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        XWHServerDataManager().postHeart(deviceMac: deviceMac, deviceSn: deviceSn, data: data, failureHandler: failureHandler, successHandler: successHandler)
    }
    
    /// 上传心率数据到服务
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    func postHeart(deviceMac: String, deviceSn: String, data: [XWHHeartModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cId = "XWHServerDataManager.PostHeart"

        let reqData = data.toJSON()
        guard let reqData = reqData as? [[String: Any]] else {
            handleDataParseError(cId, failureHandler)
            return
        }

        log.debug("requestId = \(cId) 上传数据")
        serverDataProvider.request(.postHeart(deviceMac, deviceSn, reqData)) { result in
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                return nil
            }
        }
    }
    
    // MARK: - BloodOxygen(血氧)
    /// 上传血氧数据到服务
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    class func postBloodOxygen(deviceMac: String, deviceSn: String, data: [XWHBloodOxygenModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        XWHServerDataManager().postBloodOxygen(deviceMac: deviceMac, deviceSn: deviceSn, data: data, failureHandler: failureHandler, successHandler: successHandler)
    }
    
    /// 上传血氧数据到服务
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    func postBloodOxygen(deviceMac: String, deviceSn: String, data: [XWHBloodOxygenModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cId = "XWHServerDataManager.PostBloodOxygen"

        let reqData = data.toJSON()
        guard let reqData = reqData as? [[String: Any]] else {
            handleDataParseError(cId, failureHandler)
            return
        }
        
        log.debug("requestId = \(cId) 上传数据")
        serverDataProvider.request(.postBloodOxygen(deviceMac, deviceSn, reqData)) { result in
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                return nil
            }
        }
    }
    
    // MARK: - Sleep(睡眠)
    /// 上传睡眠数据
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    class func postSleep(deviceMac: String, deviceSn: String, data: [XWHSleepModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        XWHServerDataManager().postSleep(deviceMac: deviceMac, deviceSn: deviceSn, data: data, failureHandler: failureHandler, successHandler: successHandler)
    }
    
    /// 上传睡眠数据
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    func postSleep(deviceMac: String, deviceSn: String, data: [XWHSleepModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cId = "XWHServerDataManager.PostSleep"

        let reqData = data.toJSON()
        guard let reqData = reqData as? [[String: Any]] else {
            handleDataParseError(cId, failureHandler)
            return
        }
        
        log.debug("requestId = \(cId) 上传数据")
        serverDataProvider.request(.postSleep(deviceMac, deviceSn, reqData)) { result in
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                return nil
            }
        }
    }
    
    // MARK: - MentalState(精神状态)
    /// 上传精神状态数据 （压力、情绪、疲劳度数据）
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    class func postMentalState(deviceMac: String, deviceSn: String, data: [XWHMentalStateModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        XWHServerDataManager().postMentalState(deviceMac: deviceMac, deviceSn: deviceSn, data: data, failureHandler: failureHandler, successHandler: successHandler)
    }
    
    /// 上传精神状态数据 （压力、情绪、疲劳度数据）
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    func postMentalState(deviceMac: String, deviceSn: String, data: [XWHMentalStateModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cId = "XWHServerDataManager.postMentalState"

        let reqData = data.toJSON()
        guard let reqData = reqData as? [[String: Any]] else {
            handleDataParseError(cId, failureHandler)
            return
        }
        
        log.debug("requestId = \(cId) 上传数据")
        serverDataProvider.request(.postMentalState(deviceMac, deviceSn, reqData)) { result in
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                return nil
            }
        }
    }
    
    // MARK: - Activity(活动数据)
    /// 上传活动数据 （步数、卡路里、距离）
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    class func postActivity(deviceMac: String, deviceSn: String, data: [XWHActivitySumModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        XWHServerDataManager().postActivity(deviceMac: deviceMac, deviceSn: deviceSn, data: data, failureHandler: failureHandler, successHandler: successHandler)
    }
    
    /// 上传活动数据 （步数、卡路里、距离）
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    func postActivity(deviceMac: String, deviceSn: String, data: [XWHActivitySumModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cId = "XWHServerDataManager.postActivity"

        let reqData = data.toJSON()
        guard let reqData = reqData as? [[String: Any]] else {
            handleDataParseError(cId, failureHandler)
            return
        }
        
        log.debug("requestId = \(cId) 上传数据")
        serverDataProvider.request(.postActivity(deviceMac, deviceSn, reqData)) { result in
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                return nil
            }
        }
    }
    
    // MARK: - Sport(运动数据)
    /// 上传运动数据 （步数、卡路里、距离）
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    class func postSport(deviceMac: String, deviceSn: String, data: [XWHSportModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        XWHServerDataManager().postSport(deviceMac: deviceMac, deviceSn: deviceSn, data: data, failureHandler: failureHandler, successHandler: successHandler)
    }
    
    /// 上传运动数据 （步数、卡路里、距离）
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    func postSport(deviceMac: String, deviceSn: String, data: [XWHSportModel], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cId = "XWHServerDataManager.postSport"

        let reqData = data.toJSON()
        
        guard let reqData = reqData as? [[String: Any]] else {
            handleDataParseError(cId, failureHandler)
            return
        }
        
        var postData: [[String: Any]] = []
        for iItem in reqData {
            var iPost = iItem
            if let stepCount = iPost["stepCount"] as? Int, stepCount == 0 {
                iPost["stepCount"] = nil
            }
            
            postData.append(iPost)
        }
        
        log.debug("requestId = \(cId) 上传数据")
        serverDataProvider.request(.postSport(deviceMac, deviceSn, postData)) { result in
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
