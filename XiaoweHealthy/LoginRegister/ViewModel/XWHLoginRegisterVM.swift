//
//  XWHLoginRegisterVM.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/23.
//

import Foundation

enum XWHLoginType: String {
    
    case phone
    case password
    case weibo
    case weixin
    case qq
    
}

class XWHLoginRegisterVM {
    
    /// 发送验证码
    func sendCode(phoneNum: String, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        loginRegisterProvider.request(.sendCode(phoneNum: phoneNum)) { result in
            var retError = XWHError()
            retError.identifier = "sendCode"
            
            switch result {
            case .failure(let error):
                retError.message = error.errorDescription ?? ""
                failureHandler?(retError)
                
            case .success(let response):
                let cJson = try? JSON(data: response.data)
                guard let json = cJson else {
                    retError.message = "解析失败"
                    failureHandler?(XWHError())
                    return
                }
                
                log.info(json.dictionaryObject)
                if json["code"].intValue != 0 {
                    retError.message = "code = \(json["code"].intValue)"

                    failureHandler?(retError)
                    return
                }
            }
        }
    }
    
    // 登录
    func login(parameters: [String: String], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        loginRegisterProvider.request(.login(parameters: parameters)) { result in
            let retId = "login"
            var retError = XWHError()
            retError.identifier = retId
            
            switch result {
            case .failure(let error):
                retError.message = error.errorDescription ?? ""
                
                log.error("登录失败 parameters: = \(parameters), error = \(error)")
                
//                failureHandler?(retError)
                DispatchQueue.main.async {
                    failureHandler?(retError)
                }
                
            case .success(let response):
                guard let json = try? JSON(data: response.data) else {
                    retError.message = "数据解析失败"
                    
                    log.error("登录失败 parameters: = \(parameters), error = \(retError)")

                    DispatchQueue.main.async {
                        failureHandler?(retError)
                    }

                    return
                }
                
                log.info(json.dictionaryObject)
                if json["code"].intValue != 0 {
                    retError.code = json["code"].stringValue
                    retError.message = json["message"].stringValue
                    
                    log.error("登录失败 parameters: = \(parameters), error = \(retError)")
                    
                    DispatchQueue.main.async {
                        failureHandler?(retError)
                    }

                    return
                }
                
                let retResponse = XWHResponse()
                retResponse.identifier = retId
                retResponse.data = json["data"]
                
                if let token = json["data"]["token"].string, !token.isEmpty {
                    XWHUser.setToken(token: token)
                    
                    XWHUserVM().profile()
                }

                DispatchQueue.main.async {
                    successHandler?(retResponse)
                }
            }
        }
    }
    
}

extension XWHLoginRegisterVM {
    
    func getCodeLoginParameters(phoneNum: String, code: String) -> [String: String] {
        return ["mobile": phoneNum, "code": code, "loginType": "phone"]
    }
    
    func getPasswordLoginParameters(phoneNum: String, password: String) -> [String: String] {
        return ["mobile": phoneNum, "password": password, "loginType": "password"]
    }
    
    func getWeixinLoginParameters(phoneNum: String, code: String, nickname: String, avatar: String, wxOpenid: String) -> [String: String] {
        return ["mobile": phoneNum, "code": code, "nickname": nickname, "avatar": avatar, "wxOpenid": wxOpenid, "loginType": "weixin"]
    }
    
    func getQQLoginParameters(phoneNum: String, code: String, nickname: String, avatar: String, qqOpenid: String) -> [String: String] {
        return ["mobile": phoneNum, "code": code, "nickname": nickname, "avatar": avatar, "qqOpenid": qqOpenid, "loginType": "qq"]
    }
    
}
