//
//  XWHLoginRegisterApi.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/23.
//

import Foundation
import Moya


let loginRegisterProvider = MoyaProvider<XWHLoginRegisterApi>()

enum XWHLoginRegisterApi {
    
    case sendCode(phoneNum: String)
    
}

extension XWHLoginRegisterApi: XWHServiceTargetType {
    
    var path: String {
        switch self {
        case .sendCode:
            return "/send_sms"
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        
        switch self {
        case .sendCode(phoneNum: let phoneNum):
            param = ["mobile": phoneNum]
        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    }
    
}
