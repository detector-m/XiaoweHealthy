//
//  XWHActivityApi.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/15.
//

import Foundation
import Moya


let activityProvider = MoyaProvider<XWHActivityApi>()

enum XWHActivityApi {
    
    /// 查询每日活动数据概览
    case getActivitySums(_ year: Int, _ month: Int, _ queryType: String)
    
    /// 获取每日活动数据
    case getActivity(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
}

extension XWHActivityApi: XWHServiceTargetType {
    
    var path: String {
        switch self {
        case .getActivitySums:
            return "/device/query_step_data"
            
        case .getActivity:
            return "/device/step_data_exist"
            
        }
    }
    
    var method: Moya.Method {
        switch self {
//        case .postHeart, .postBloodOxygen:
//            return .post
            
        case .getActivitySums, .getActivity:
            return .get
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        
        switch self {
//        case .postHeart(let deviceSn, let data), .postBloodOxygen(let deviceSn, let data):
//            param = ["deviceSn": deviceSn, "data": data]
            
        case .getActivitySums(let year, let month, let queryType):
            param = ["year": year, "month": month, "queryType": queryType]
            
        case .getActivity(let year, let month, let day, let queryType):
            param = ["year": year, "month": month, "day": day, "queryType": queryType]
        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        
        if param.isEmpty {
            return .requestPlain
        }
        
        return .requestParameters(parameters: param, encoding: parameterEncoding)
    }
    
}
