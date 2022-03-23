//
//  XWHLoginRegisterVM.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/23.
//

import Foundation
import SwiftyJSON


class XWHLoginRegisterVM {
    
    /// 发送验证码
    func sendCode(phoneNum: String, completion: ((Bool) -> Void)? = nil) {
        loginRegisterProvider.request(.sendCode(phoneNum: phoneNum)) { result in
            if case .success(let response) = result {
                let cJson = try? JSON(data: response.data)
                guard let json = cJson else {
                    completion?(false)
                    return
                }
                
                log.info(json.dictionaryObject)
                if json["code"].intValue != 0 {
                    completion?(false)
                    return
                }
            } else {
                completion?(false)
            }
        }
    }
    
}
