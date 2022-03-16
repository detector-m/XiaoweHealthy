//
//  XWHRootVCProvider.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import ESTabBarController_swift
import RTRootNavigationController

enum XWHRootVCProvider {
    
    static func getTabBarVC() -> XWHTabBarVC {
        let tabBarController = XWHTabBarVC()
        let v1 = XWHHealthyMainVC()
        let v2 = XWHSportMainVC()
        let v3 = XWHDeviceMainVC()
        let v4 = XWHMeMainVC()
        
        let nav1 = XWHBaseNavigationVC(rootViewController: v1)
        let nav2 = XWHBaseNavigationVC(rootViewController: v2)
        let nav3 = XWHBaseNavigationVC(rootViewController: v3)
        let nav4 = XWHBaseNavigationVC(rootViewController: v4)
        
        nav1.tabBarItem = ESTabBarItem.init(title: R.string.xwhDisplayText.健康(), image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        nav2.tabBarItem = ESTabBarItem.init(title: R.string.xwhDisplayText.运动(), image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        nav3.tabBarItem = ESTabBarItem.init(title: R.string.xwhDisplayText.设备(), image: UIImage(named: "photo"), selectedImage: UIImage(named: "photo_1"))
        nav4.tabBarItem = ESTabBarItem.init(title: R.string.xwhDisplayText.我的(), image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        
        tabBarController.viewControllers = [nav1, nav2, nav3, nav4]
        
        return tabBarController
    }
    
}
