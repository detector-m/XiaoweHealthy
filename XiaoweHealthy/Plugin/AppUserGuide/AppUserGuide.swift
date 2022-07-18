//
//  AppUserGuide.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/30.
//

import Foundation
import UIKit


/// App 用户引导
class AppUserGuide {
    
    private static let kUserGuideNotShow = "AppUserGuideNotShow"
    static var isShow: Bool {
        get {
//            !UserDefaults.standard.bool(forKey: kUserGuideNotShow)
            false
        }
        set {
            UserDefaults.standard[kUserGuideNotShow] = !newValue
        }
    }
    
    class func getGuideVC(btnAction: @escaping AppUserGuideVC.AppUserGuideBtnAction) -> AppUserGuideVC {
        let vc = AppUserGuideVC()
        vc.btnAction = btnAction
        
        return vc
    }
    
}
