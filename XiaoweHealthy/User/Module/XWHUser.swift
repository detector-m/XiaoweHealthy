//
//  XWHUser.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import Foundation


class XWHUser {
    
    class func isLogined() -> Bool {
        return XWHDataUserManager.isLogined()
    }
    
    class func getToken() -> String? {
        return XWHDataUserManager.getToken()
    }
    
    class func setToken(token: String?) {
        XWHDataUserManager.setToken(token: token)
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
