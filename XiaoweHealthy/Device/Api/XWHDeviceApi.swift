//
//  XWHDeviceApi.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/6.
//

import Foundation
import Moya

let deviceProvider = MoyaProvider<XWHDeviceApi>()

enum XWHDeviceApi {
    
    // 获取设备产品列表
    case list
    
    // 检查固件更新
    case firmwareUpdate(deviceSn: String, version: String)
    
}

extension XWHDeviceApi: XWHServiceTargetType {
    
    var path: String {
        switch self {
        case .list:
            return "/device/list"
            
        case .firmwareUpdate:
            return "/device/firmware_update"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .list, .firmwareUpdate:
            return .get
            
//        default:
//            return .post
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        
        switch self {
        case .list:
            break
            
        case let .firmwareUpdate(deviceSn: sn, version: ver):
            param = ["deviceSn": sn, "version": ver]
        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        
        if param.isEmpty {
            return .requestPlain
        }
        return .requestParameters(parameters: param, encoding: parameterEncoding)
    }
    
}
