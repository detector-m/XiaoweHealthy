//
//  AliyunCredentialModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/14.
//

import HandyJSON

/// 阿里云oss Credential 参数模型
struct AliyunCredentialModel: HandyJSON {
    
    var keyId: String = ""
    var keySecret: String = ""
    var securityToken: String = ""
    var expirationTimeInGMTFormat: String = ""
    var endPoint: String = ""
    
}
