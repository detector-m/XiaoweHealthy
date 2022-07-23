//
//  AppImageUploadApi.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/23.
//

import Moya

let appImageUploadProvider = MoyaProvider<AppImageUploadApi>()

enum AppImageUploadApi {
    
    /// 获取阿里云oss STS 临时token授权
    case getOssStsToken
    
}

extension AppImageUploadApi: XWHServiceTargetType {
    
    var path: String {
        switch self {
        case .getOssStsToken:
            return "/sts_token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getOssStsToken:
            return .get
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        
        switch self {
        case .getOssStsToken:
            param = [:]
        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        
        if param.isEmpty {
            return .requestPlain
        }
        
        return .requestParameters(parameters: param, encoding: parameterEncoding)
    }
    
}
