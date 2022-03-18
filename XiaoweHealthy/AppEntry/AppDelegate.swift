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
        
        configIQKeyboard()
        
        if #available(iOS 13.0, *) {
            
        } else {
            let cWin = UIWindow(frame: UIScreen.main.bounds)
            Self.configWindow(win: cWin)
            window = cWin
            cWin.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

// MARK: - Window
extension AppDelegate {
    
    class func configWindow(win: UIWindow) {
        let rVC = XWHRootVCProvider.getTabBarVC()
        
        win.rootViewController = rVC
    }
    
    func configIQKeyboard() {
        let kbManager = IQKeyboardManager.shared
        kbManager.enable = true
        kbManager.enableAutoToolbar = false
        kbManager.shouldResignOnTouchOutside = true
        kbManager.keyboardDistanceFromTextField = 160
    }
    
}

