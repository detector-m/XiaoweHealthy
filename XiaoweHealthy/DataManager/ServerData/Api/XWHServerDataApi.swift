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
    case postHeart(_ deviceSn: String, _ data: [[String: Any]])
    

    // MARK: - BloodOxygen(血氧)
    /// 上传血氧数据到服务
    case postBloodOxygen(_ deviceSn: String, _ data: [[String: Any]])
    

    // MARK: - Sleep(睡眠)
    /// 上传睡眠数据
    case postSleep(_ deviceSn: String, _ data: [[String: Any]])
    
    // MARK: - MentalState(精神状态)
    /// 上传精神状态数据 （压力、情绪、疲劳度数据）
    case postMentalState(_ deviceSn: String, _ data: [[String: Any]])
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
        case .postHeart(let deviceSn, let data), .postBloodOxygen(let deviceSn, let data), .postMentalState(let deviceSn, let data):
            param = ["deviceSn": deviceSn, "data": data]
            
        case .postSleep(let deviceSn, let data):
            param = data.last ?? [:]
        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        
        if param.isEmpty {
            return .requestPlain
        }
        
        return .requestParameters(parameters: param, encoding: parameterEncoding)
    }
    
}
