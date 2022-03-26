//
//  XWHUser.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import Foundation


class XWHUser {
    
    class func isLogined() -> Bool {
        guard let _ = getToken() else {
            return false
        }
        
        return true
    }
    
    class func getToken() -> String? {
        return UserDefaults.standard[kToken] as? String
    }
    
    class func setToken(token: String?) {
        UserDefaults.standard[kToken] = token
    }
    
}

// MARK: - UI
extension XWHUser {
    
    class func gotoSetUserInfo(at targetVC: UIViewController, isNewer: Bool) {
        if isNewer {
            let vc = XWHGenderSelectVC()
            targetVC.navigationController?.setViewControllers([vc], animated: true)
        } else {
            targetVC.dismiss(animated: true, completion: nil)
        }
    }
    
}
