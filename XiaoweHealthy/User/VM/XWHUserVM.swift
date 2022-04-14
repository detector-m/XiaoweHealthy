//
//  XWHUserVM.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/23.
//

import Foundation


class XWHUserVM {
    
    // 获取用户信息
    func profile(failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        userProvider.request(.profile) { result in
            let cId = "User.Profile"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                let userModel = XWHUserModel.deserialize(from: json.dictionaryValue)
                response.data = userModel
                
                if var cUser = userModel {
                    XWHDataUserManager.deleteAll()
                    XWHDataUserManager.saveUser(&cUser)
                }
                
                return userModel
            }
        }
    }
    
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
    
    // 绑定设备
    func bindDevice(deviceInfo: [String: String], failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let reqParam = ["deviceName": "", "deviceMode": "deviceSn", "macAddr": ""]
        userProvider.request(.bindDevice(parameters: reqParam)) { result in
            let cId = "User.BindDevice"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                return nil
            }
        }
    }
    
    // 解绑设备
    func unbindDevice(deviceSn: String, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        userProvider.request(.unbindDevice(deviceSn: deviceSn)) { result in
            let cId = "User.UnbindDevice"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler)
        }
    }

    // 查询用户设备列表
    func devices(deviceSn: String, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        userProvider.request(.devices) { result in
            let cId = "User.Devices"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler)
        }
    }
    
}
