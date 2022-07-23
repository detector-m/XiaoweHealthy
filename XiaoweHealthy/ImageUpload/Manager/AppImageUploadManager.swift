//
//  AppImageUploadManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/23.
//

import Foundation
import HandyJSON


class AppImageUploadManager {
    
    // MARK: - 获取阿里云oss STS 临时token授权
    class func getOssStsToken(failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cId = "AppImageUploadManager.getOssStsToken"

        log.debug("requestId = \(cId) 获取阿里云oss STS 临时token授权")
        appImageUploadProvider.request(.getOssStsToken) { result in
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = AliyunCredentialModel.deserialize(from: json.dictionaryObject, designatedPath: nil)
                
                return nil
            }
        }
    }
    
}
