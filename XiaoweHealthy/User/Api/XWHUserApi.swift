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
    
    // 获取用户信息
    case profile
    
    // 更新用户信息
    case update(parameters: [String: Any])
    
    // 设置密码
    case setPassword(parameters: [String: String])
    
    // 绑定设备
    case bindDevice(parameters: [String: String])
    
    // 解绑设备
    case unbindDevice(deviceSn: String)
    
    // 查询用户设备列表
    case devices
    
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
            
        case .bindDevice:
            return "/user/bind_device"
            
        case .unbindDevice:
            return "/user/remove_device"
            
        case .devices:
            return "/user/devices"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .profile:
            return .get
            
//        case .update, .setPassword:
        default:
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
                        
        case let .setPassword(parameters: cParam), let .bindDevice(parameters: cParam):
            param = cParam
            
        case .unbindDevice(deviceSn: let deviceSn):
            param = ["deviceSn": deviceSn]
            
        case .devices:
            break
        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        if param.isEmpty {
            return .requestPlain
        }
        return .requestParameters(parameters: param, encoding: JSONEncoding.default)
    }
    
}
