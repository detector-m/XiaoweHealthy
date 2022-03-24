//
//  XWHNetworkHelper.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/23.
//

import Foundation
import CryptoSwift


class XWHNetworkHelper {
    
    class func getSignatureParameters() -> [String: String] {
        // 随机字符串
        let nonce = String.random(ofLength: 32)
        
        // 调用接口时的毫秒时间戳
        
        let timestamp = (Date().timeIntervalSince1970 * 1000).int.string
        
        // 协商后由后台下发 密钥
        let secret = XWHApiKey
        // 客户端的类型 ios或者android
        let device = "ios"
        // 客户端应用版本号，比如v1.0
        let infoDictionary : [String : Any] = Bundle.main.infoDictionary!
        let version = infoDictionary["CFBundleShortVersionString"] as! String
        
        return ["SenseNonce": nonce, "SenseTimestamp": timestamp, "secret": secret, "SenseDevice": device, "SenseVersion": version]
    }
    
    class func getApiSignature(parameterValues: [String]) -> String {
        let param = parameterValues.sorted()
        let str = param.joined(separator: "")
        let signStr = str.sha1()
        
        return signStr
    }
    
    class func getToken() -> String? {
        return UserDefaults.standard[kToken] as? String
    }
    
    class func setToken(token: String?) {
        UserDefaults.standard[kToken] = token
    }
    
}
