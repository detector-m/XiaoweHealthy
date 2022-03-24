//
//  XWHUserApi.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/23.
//

import Foundation
import Moya

let userProvider = MoyaProvider<XWHUserApi>()

enum XWHUserApi {
    
    case profile
    
    case update(parameters: [String: Any])
    
    case setPassword(parameters: [String: String])
    
}

extension XWHUserApi: XWHServiceTargetType {
    
    var path: String {
        switch self {
        case .profile:
            return "/user/profile"
            
        case .update:
            return "/user/update"
            
        case .setPassword:
            return "/user/set_password"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .profile:
            return .get
            
        case .update, .setPassword:
            return .post
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        
        switch self {
        case .profile:
//            param = ["mobile": phoneNum]
            break
            
            
        case .update(parameters: let cParam):
            param = cParam
            
        case .setPassword(parameters: let cParam):
            param = cParam
        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    }
    
}
