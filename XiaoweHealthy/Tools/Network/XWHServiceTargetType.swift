//
//  XWHServiceTargetType.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/23.
//

import Foundation
import Moya


protocol XWHServiceTargetType: TargetType {
    
}

extension XWHServiceTargetType {
    
    var baseURL: URL {
        return URL(string: XWHApiDomain)!
    }
    
    var method: Moya.Method {
        return .post
    }
    
    // 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    // 请求头
    var headers: [String: String]? {
        var param = XWHNetworkHelper.getSignatureParameters()
        let signStr = XWHNetworkHelper.getApiSignature(parameterValues: Array(param.values))
        param.removeValue(forKey: "secret")
        
        param["SenseSign"] = signStr
        param["Content-Type"] = "application/json"
        
        return param
    }
    
}
