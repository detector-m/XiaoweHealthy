//
//  XWHApiConfig.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/23.
//

import Foundation

/// 接口appkey
let XWHApiKey = "mDUPfbIVV3khQQRhdMzJUtUlrXJwFWtp"

/// 开发环境
//var defaultDomain = "http://10.1.20.31"

var XWHApiDomain: String {
    if isTestServer {
        return "https://test-api.xiaowe.cc"
    }
    return "https://test-api.xiaowe.cc"
}

//var XWHApiUploadApi: String {
//    if isTestServer {
//        return ""
//    }
//    return ""
//}

/// 是否为测试服务器
public var isTestServer = true
