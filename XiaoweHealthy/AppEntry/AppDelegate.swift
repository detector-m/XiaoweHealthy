//
//  AppDelegate.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/15.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configAppearance()
        
        configLog()
        configGaodeMap()
        
//        configAppDatabase()
        
        configCache()
        
        configUM()
        
        configIQKeyboard()
        configToast()
        
//        if #available(iOS 13.0, *) {
//
//        } else {
            let cWin = UIWindow(frame: UIScreen.main.bounds)
            Self.configWindow(win: cWin)
            window = cWin
            cWin.makeKeyAndVisible()
//        }
        
//        XWHDevice.shared.connect()
        XWHDevice.shared.config()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    @available(iOS 13.0, *)
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        log.debug("handleOpen -> url:\(url), options: = \(options)")
        
        return XWHUMManager.handleOpen(url: url, options: options)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        log.debug("handleOpen -> url:\(url), sourceApplication: = \(sourceApplication ?? ""), annotation: \(annotation)")

        return XWHUMManager.handleOpen(url: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        log.debug("handleOpen -> url:\(url)")

        return XWHUMManager.handleOpen(url: url)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        log.debug("handleUniversalLink useractivity = \(userActivity)")
        XWHUMManager.handleUniversalLink(userActivity: userActivity)
        
        return true
    }
    
}

// MARK: - Window
extension AppDelegate {
    
    /// ?????? ????????????
    class func configWindow(win: UIWindow) {
        var rVC: UIViewController
        if AppPrivacy.isShow {
            rVC = AppPrivacy.getPrivacyVC(completion: {
                AppDelegate.configWindow(win: win)
            })
        } else if AppUserGuide.isShow {
            rVC = AppUserGuide.getGuideVC(btnAction: { isSkip in
                AppDelegate.configWindow(win: win)
            })
        } else {
            rVC = XWHRootVCProvider.getTabBarVC()
        }
        
        win.rootViewController = rVC
    }
    
    // ?????? App UI
    fileprivate func configAppearance() {
        UINavigationBar.appearance().setTitleFont(XWHFont.harmonyOSSans(ofSize: 17, weight: .medium), color: fontDarkColor)
    }
    
    fileprivate func configLog() {
        AppLogManager.configLog()
    }
    
    // ???????????????
    fileprivate func configAppDatabase() {
        appDB.connect()
    }
    
    // ????????????
    fileprivate func configCache() {
        XWHCache.config()
    }
    
    fileprivate func configIQKeyboard() {
        let kbManager = IQKeyboardManager.shared
        kbManager.enable = true
        kbManager.enableAutoToolbar = false
        kbManager.shouldResignOnTouchOutside = true
        kbManager.keyboardDistanceFromTextField = 160
    }
    
    fileprivate func configToast() {
        // create a new style
        var style = ToastStyle()

        // this is just one of many style options
        style.messageColor = UIColor(hex: 0x000000, transparency: 0.9)!
        style.messageFont = XWHFont.harmonyOSSans(ofSize: 14)
        style.cornerRadius = 20
        style.backgroundColor = UIColor(hex: 0xeeeeee, transparency: 0.85)!
        style.verticalPadding = 14

        // or perhaps you want to use this style for all toasts going forward?
        // just set the shared style and there's no need to provide the style again
        ToastManager.shared.style = style

        // toggle "tap to dismiss" functionality
        ToastManager.shared.isTapToDismissEnabled = true

        // toggle queueing behavior
        ToastManager.shared.isQueueEnabled = true
        
        ToastManager.shared.position = .bottom
    }
    
    // ????????????
    fileprivate func configUM() {
        XWHUMManager.configUMCommon()
        
        XWHUMManager.configShare()
    }
    
    // ??????gaode??????
    fileprivate func configGaodeMap() {
        XWHGaodeMapManager.config()
    }
    
}

