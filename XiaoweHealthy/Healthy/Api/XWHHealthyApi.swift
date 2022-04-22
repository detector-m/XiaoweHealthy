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
    case getHeart(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    

    // MARK: - BloodOxygen(血氧)
    case getBloodOxygen(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
}


extension XWHHealthyApi: XWHServiceTargetType {
    
    var path: String {
        switch self {
        case .getHeart:
            return "/device/query_heart_rate"
            
        case .getBloodOxygen:
            return "/device/query_blood_oxygen"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getHeart, .getBloodOxygen:
            return .get
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        
        switch self {
        case .getHeart(let year, let month, let day, let queryType), .getBloodOxygen(let year, let month, let day, let queryType):
            param = ["year": year, "month": month, "day": day, "queryType": queryType]
        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        
        if param.isEmpty {
            return .requestPlain
        }
        
        return .requestParameters(parameters: param, encoding: parameterEncoding)
    }
    
}
