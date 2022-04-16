//
//  XWHDialApi.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import Foundation
import Moya

let dialProvider = MoyaProvider<XWHDialApi>()


enum XWHDialApi {
    
    // 用户新增表盘
    case add(_ dialNo: String, _ deviceSn: String)
    
    // 用户移除表盘
    case delete(_ dialNo: String, _ deviceSn: String)
    
    // 获取我的当前设备表盘
    case getMyDial(_ deviceSn: String, _ page: Int, _ pageSize: Int)
    
    // 表盘市场列表页数据
    case getMarketDialCategory(_ deviceSn: String)
    
    // 表盘市场分类页数据
    case getMarketCategoryDial(_ categoryId: Int, _ deviceSn: String, _ page: Int, _ pageSize: Int)
    
}

extension XWHDialApi: XWHServiceTargetType {
    
    var path: String {
        switch self {
        case .add:
            return "/user/add_dial"
            
        case .delete:
            return "/user/remove_dial"
            
        case .getMyDial:
            return "/user/dials"
            
        case .getMarketDialCategory:
            return "/device/dial_store"
            
        case .getMarketCategoryDial:
            return "/device/dial_category"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .add, .delete:
            return .post
            
        case .getMyDial, .getMarketDialCategory, .getMarketCategoryDial:
            return .get
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        
        switch self {
        case .add(let dialNo, let deviceSn), .delete(let dialNo, let deviceSn):
            param = ["dialNo": dialNo, "deviceSn": deviceSn]
            
        case .getMyDial(let deviceSn, let page, let pageSize):
            param = ["deviceSn": deviceSn, "page": page, "pageSize": pageSize]
            
        case .getMarketDialCategory(let deviceSn):
            param = ["deviceSn": deviceSn]
            
        case .getMarketCategoryDial(let categoryId, let deviceSn, let page, let pageSize):
            param = ["categoryId": categoryId, "deviceSn": deviceSn, "page": page, "pageSize": pageSize]
        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        
        if param.isEmpty {
            return .requestPlain
        }
        
        return .requestParameters(parameters: param, encoding: parameterEncoding)
    }
    
}
