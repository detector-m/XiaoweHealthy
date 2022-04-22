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
    
    case login(parameters: [String: String])
    
}

extension XWHLoginRegisterApi: XWHServiceTargetType {
    
    var path: String {
        switch self {
        case .sendCode:
            return "/send_sms"
            
        case .login:
            return "/login"
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        
        switch self {
        case .sendCode(phoneNum: let phoneNum):
            param = ["mobile": phoneNum]
            
        case .login(parameters: let cParam):
            param = cParam
            // 登录设备型号
            param["clientMode"] = UIDevice.current.model
            // 登录设备品牌
            param["clientBrand"] = "Apple-iPhone"
        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        
        if param.isEmpty {
            return .requestPlain
        }
        
        return .requestParameters(parameters: param, encoding: parameterEncoding)
    }
    
}
