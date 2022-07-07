//
//  XWHAppManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/7.
//

import Foundation


class XWHAppManager {
    
    private static let kPrivacyKey = "AppPrivacy"
    
    static var isAllowPrivacy: Bool {
        get {
            UserDefaults.standard.bool(forKey: kPrivacyKey)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: kPrivacyKey)
        }
    }
    
    /// 隐私弹出框
    class func checkPrivacy(completion: @escaping (() -> Void), btnAction: @escaping ((Bool) -> Void)) {
        if XWHAppManager.isAllowPrivacy {
            btnAction(true)
            return
        }
        let title = "小维健康"
        let message = "\n亲，感谢您对\(title)一直以来的信任！我们依据最新的监管要求更新了\(title)《隐私权政策》，特向您说明如下\n1.为向您提供交易相关基本功能，我们会收集、使用必要的信息；\n2.基于您的明示授权，我们可能会获取您的位置（为您提供附近的商品、店铺及优惠资讯等）等信息，您有权拒绝或取消授权；\n3.我们会采取业界先进的安全措施保护您的信息安全；\n4.未经您同意，我们不会从第三方处获取、共享或向提供您的信息；"
        
        XWHAlert.show(title: "《隐私权政策》", message: message, messageAlignment: .left, cancelTitle: "不同意", confirmTitle: "同意") { aType in
            if aType == .cancel {
                XWHAppManager.isAllowPrivacy = false
                btnAction(false)
            } else {
                XWHAppManager.isAllowPrivacy = true
                btnAction(true)
            }
        }
        
        completion()
    }
    
}
