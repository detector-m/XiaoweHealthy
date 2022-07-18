//
//  AppPrivacy.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/18.
//

import Foundation


/// 隐私协议
class AppPrivacy {
    
    private static let kPrivacyNotShow = "AppPrivacyNotShow"
    static var isShow: Bool {
        get {
            !UserDefaults.standard.bool(forKey: kPrivacyNotShow)
        }
        set {
            UserDefaults.standard[kPrivacyNotShow] = !newValue
        }
    }
    
    class func getPrivacyVC(completion: @escaping () -> Void) -> UINavigationController {
        let vc = AppPrivacyVC()
        let nav = UINavigationController(rootViewController: vc)
        
        vc.completion = completion
        
        return nav
    }
    
}
