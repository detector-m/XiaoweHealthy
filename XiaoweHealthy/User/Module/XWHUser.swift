//
//  XWHUser.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import Foundation


class XWHUser {
    
    static var isHasToken: Bool {
        return XWHUserDataManager.isHasToken
    }
    
    static var isLogined: Bool {
        return XWHUserDataManager.isLogined
    }
    
    class func logout() {
        handleExpiredUserToken()
    }
    
    class func getToken() -> String? {
        return XWHUserDataManager.getToken()
    }
    
    class func setToken(token: String?) {
        let preToken = getToken()
        XWHUserDataManager.setToken(token: token)
        
        if token == nil {
            if preToken != nil {
                XWHLogin.postNotification(isLogin: false)
            }
        } else {
            XWHLogin.postNotification(isLogin: true)
        }
    }
    
    /// 用户Token 过期处理
    class func handleExpiredUserToken(_ completion: (() -> Void)? = nil) {
        if let curConnDev = ddManager.getCurrentDevice() {
            XWHDDMShared.disconnect(device: curConnDev)
            
            ddManager.remove(device: curConnDev)
        }
        
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
