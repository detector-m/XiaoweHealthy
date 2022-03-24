//
//  XWHUserVM.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/23.
//

import Foundation


class XWHUserVM {
    
    // 更新用户信息
    func update(userModel: XWHUserModel, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cParam = userModel.toJSON() ?? [:]
        userProvider.request(.update(parameters: cParam)) { result in
            let cId = "User.Update"
            var retError = XWHError()
            retError.identifier = cId
            
            switch result {
            case .failure(let error):
                retError.message = error.errorDescription ?? ""
                
                log.error(retError)
                
                failureHandler?(retError)
                
            case .success(let response):
                let cJson = try? JSON(data: response.data)
                guard let json = cJson else {
                    retError.message = tdParseFailed
                    
                    log.error(retError)
                    
                    failureHandler?(retError)
                    
                    return
                }
                
                log.info(json.dictionaryObject)
                if json["code"].intValue != 0 {
                    retError.code = json["code"].stringValue
                    retError.message = json["message"].stringValue
                    
                    log.error(retError)
                    
                    failureHandler?(retError)
                    return
                }
                
                let retResponse = XWHResponse()
                retResponse.identifier = cId
                successHandler?(retResponse)
            }
        }
    }
    
    // 设置密码
    func setPassword(phoneNum: String, code: String, password: String, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let cParam = ["mobile": phoneNum, "code": code, "password": password]
        userProvider.request(.setPassword(parameters: cParam)) { result in
            let cId = "User.SetPassword"
            var retError = XWHError()
            retError.identifier = cId
            
            switch result {
            case .failure(let error):
                retError.message = error.errorDescription ?? ""
                
                log.error(retError)
                
                failureHandler?(retError)
                
            case .success(let response):
                let cJson = try? JSON(data: response.data)
                guard let json = cJson else {
                    retError.message = tdParseFailed
                    
                    log.error(retError)
                    
                    failureHandler?(retError)
                    
                    return
                }
                
                log.info(json.dictionaryObject)
                if json["code"].intValue != 0 {
                    retError.code = json["code"].stringValue
                    retError.message = json["message"].stringValue
                    
                    log.error(retError)
                    
                    failureHandler?(retError)
                    return
                }
                
                let retResponse = XWHResponse()
                retResponse.identifier = cId
                successHandler?(retResponse)
            }
        }
    }
    
}
