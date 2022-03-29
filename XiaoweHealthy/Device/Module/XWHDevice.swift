//
//  XWHDevice.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import Foundation

class XWHDevice {
    
    class func gotoHelp(at targetVC: UIViewController) {
        XWHSafari.present(at: targetVC, urlStr: kRedirectURL)
    }
    
}
