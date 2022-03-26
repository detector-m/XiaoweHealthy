//
//  XWHLogin.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import Foundation
import UIKit

class XWHLogin {
    
    class func present(at targetVC: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        let loginVC = XWHLoginVC()
        let loginNav = XWHBaseNavigationVC(rootViewController: loginVC)
        loginNav.modalPresentationStyle = .fullScreen
        targetVC.present(loginNav, animated: animated, completion: completion)
    }
    
    class func presentPasswordLogin(at targetVC: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        let loginVC = XWHPasswordLoginVC()
        let loginNav = XWHBaseNavigationVC(rootViewController: loginVC)
        loginNav.modalPresentationStyle = .fullScreen
        targetVC.present(loginNav, animated: animated, completion: completion)
    }
    
}

extension XWHAlert {
    
    class func showLogin(at targetVC: UIViewController) {
        Self.show(message: R.string.xwhDeviceText.您需要登录小维账号方可使用完整功能是否立即登录(), cancelTitle: R.string.xwhDisplayText.取消(), confirmTitle: R.string.xwhDisplayText.立即登录()) { cType in
            if cType == .confirm {
                XWHLogin.present(at: targetVC)
            }
        }
    }
    
}
