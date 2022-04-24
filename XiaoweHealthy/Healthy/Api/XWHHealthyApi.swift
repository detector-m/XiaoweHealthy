//
//  XWHHealthyApi.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/22.
//

import Foundation
import Moya

let healthyProvider = MoyaProvider<XWHHealthyApi>()

enum XWHHealthyApi {
    
    // MARK: - Heart(心率)
    /// 上传心率数据到服务
    case postHeart(_ deviceSn: String, _ data: [[String: Any]])
    
    /// 获取心率数据
    case getHeart(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
    /// 查询心率历史数据
    case getHeartHistory(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
    /// 获取心率记录的详情数据
    case getHeartDetail(_ rId: Int)
    

    // MARK: - BloodOxygen(血氧)
    /// 上传血氧数据到服务
    case postBloodOxygen(_ deviceSn: String, _ data: [[String: Any]])

    /// 获取血氧
    case getBloodOxygen(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
    /// 查询血氧历史数据
    case getBloodOxygenHistory(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
    /// 获取血氧记录的详情数据
    case getBloodOxygenDetail(_ rId: Int)
    
}


extension XWHHealthyApi: XWHServiceTargetType {
    
    var path: String {
        switch self {
        case .postHeart:
            return "/device/post_heart_rate"
            
        case .getHeart:
            return "/device/query_heart_rate"
            
        case .getHeartHistory:
            return "/device/log_heart_rate"
            
        case .getHeartDetail:
            return "/device/specify_heart_rate"
            
        case .postBloodOxygen:
            return "/device/post_blood_oxygen"
            
        case .getBloodOxygen:
            return "/device/query_blood_oxygen"
            
        case .getBloodOxygenHistory:
            return "/device/log_blood_oxygen"
            
        case .getBloodOxygenDetail:
            return "/device/specify_blood_oxygen"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postHeart, .postBloodOxygen:
            return .post
            
        case .getHeart, .getBloodOxygen, .getHeartHistory, .getBloodOxygenHistory, .getHeartDetail, .getBloodOxygenDetail:
            return .get
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        
        switch self {
        case .postHeart(let deviceSn, let data), .postBloodOxygen(let deviceSn, let data):
            param = ["deviceSn": deviceSn, "data": data]
            
        case .getHeart(let year, let month, let day, let queryType), .getBloodOxygen(let year, let month, let day, let queryType):
            param = ["year": year, "month": month, "day": day, "queryType": queryType]
            
        case .getHeartHistory(let year, let month, let day, let queryType), .getBloodOxygenHistory(let year, let month, let day, let queryType):
            param = ["year": year, "month": month, "day": day, "queryType": queryType]
            
        case .getHeartDetail(let rId), .getBloodOxygenDetail(let rId):
            param = ["id": rId]

        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        
        if param.isEmpty {
            return .requestPlain
        }
        
        return .requestParameters(parameters: param, encoding: parameterEncoding)
    }
    
}
