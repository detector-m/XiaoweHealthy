//
//  XWHUser.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import Foundation


class XWHUser {
    
    static var isHasToken: Bool {
        return XWHDataUserManager.isHasToken
    }
    
    static var isLogined: Bool {
        return XWHDataUserManager.isLogined
    }
    
    class func getToken() -> String? {
        return XWHDataUserManager.getToken()
    }
    
    class func setToken(token: String?) {
        XWHDataUserManager.setToken(token: token)
    }
    
    /// 用户Token 过期处理
    class func handleExpiredUserToken(_ completion: (() -> Void)? = nil) {
        setToken(token: nil)
        completion?()
    }
    
    class func handleExpiredUserTokenUI(_ targetVC: UIViewController?, _ completion: (() -> Void)? = nil) {
        let nextTopVC = targetVC?.navTopPreviousVC()
        targetVC?.navigationController?.popViewController(animated: true)
        nextTopVC?.view.makeInsetToast("用户登录信息失效, 请重新登录")
        completion?()
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
