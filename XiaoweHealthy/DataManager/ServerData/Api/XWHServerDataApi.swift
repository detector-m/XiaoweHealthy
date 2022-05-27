//
//  XWHDeviceServerDataApi.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import Foundation
import Moya

let serverDataProvider = MoyaProvider<XWHServerDataApi>()

enum XWHServerDataApi {
    
    // MARK: - Heart(心率)
    /// 上传心率数据到服务
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    case postHeart(_ deviceMac: String, _ deviceSn: String, _ data: [[String: Any]])
    

    // MARK: - BloodOxygen(血氧)
    /// 上传血氧数据到服务
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    case postBloodOxygen(_ deviceMac: String, _ deviceSn: String, _ data: [[String: Any]])
    

    // MARK: - Sleep(睡眠)
    /// 上传睡眠数据
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    case postSleep(_ deviceMac: String, _ deviceSn: String, _ data: [[String: Any]])
    
    // MARK: - MentalState(精神状态)
    /// 上传精神状态数据 （压力、情绪、疲劳度数据）
    /// - Parameters:
    ///     - deviceMac: 设备的mac 地址 （必选）
    ///     - deviceSn: 设备唯一标识码 (可选)
    ///     - data: 上传的数据 （必选）
    case postMentalState(_ deviceMac: String, _ deviceSn: String, _ data: [[String: Any]])
    
}


extension XWHServerDataApi: XWHServiceTargetType {
    
    var path: String {
        switch self {
        case .postHeart:
            return "/device/post_heart_rate"
            
        case .postBloodOxygen:
            return "/device/post_blood_oxygen"
            
        case .postSleep:
            return "/device/post_sleep_data"
            
        case .postMentalState:
            return "/device/post_spirit_data"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postHeart, .postBloodOxygen, .postSleep, .postMentalState:
            return .post
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        
        switch self {
        case .postHeart(let deviceMac, let deviceSn, let data), .postBloodOxygen(let deviceMac, let deviceSn, let data), .postMentalState(let deviceMac, let deviceSn, let data):
            param = ["mac": deviceMac, "deviceSn": deviceSn, "data": data]
            
        case .postSleep(_, _, let data):
            param = ["itemList": data]
        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        
        if param.isEmpty {
            return .requestPlain
        }
        
        return .requestParameters(parameters: param, encoding: parameterEncoding)
    }
    
}
