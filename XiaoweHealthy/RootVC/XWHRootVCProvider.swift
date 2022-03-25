//
//  XWHRootVCProvider.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import ESTabBarController_swift
import RTRootNavigationController
import UIKit

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
        
        let font = XWHFont.harmonyOSSans(ofSize: 10, weight: .medium)
        let itemAttr: [NSAttributedString.Key : Any] = [.font: font]
        
        UITabBarItem.appearance().setTitleTextAttributes(itemAttr, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(itemAttr, for: .selected)
        
        nav1.tabBarItem = UITabBarItem.init(title: R.string.xwhDisplayText.健康(), image: R.image.tabHealth(), selectedImage: R.image.tabHealth())
//        nav1.tabBarItem.setTitleTextAttributes(normalAttr, for: .normal)
//        nav1.tabBarItem.setTitleTextAttributes(selectedAttr, for: .selected)
        
        nav2.tabBarItem = UITabBarItem.init(title: R.string.xwhDisplayText.运动(), image: R.image.tabSport(), selectedImage: R.image.tabSport())

//        nav2.tabBarItem.setTitleTextAttributes(normalAttr, for: .normal)
//        nav2.tabBarItem.setTitleTextAttributes(selectedAttr, for: .selected)
        
        nav3.tabBarItem = UITabBarItem.init(title: R.string.xwhDisplayText.设备(), image: R.image.tabDevice(), selectedImage: R.image.tabDevice())
//        nav3.tabBarItem.setTitleTextAttributes(normalAttr, for: .normal)
//        nav3.tabBarItem.setTitleTextAttributes(selectedAttr, for: .selected)
        
        nav4.tabBarItem = UITabBarItem.init(title: R.string.xwhDisplayText.我的(), image: R.image.tabMe(), selectedImage: R.image.tabMe())
//        nav4.tabBarItem.setTitleTextAttributes(normalAttr, for: .normal)
//        nav4.tabBarItem.setTitleTextAttributes(selectedAttr, for: .selected)
        
//        UITabBar.appearance().tintColor = UIColor.clear
//        tabBarController.tabBar.backgroundColor = UIColor(hex: 0x000000, transparency: 0.06)
        tabBarController.tabBar.layer.backgroundColor = UIColor.white.cgColor
        tabBarController.tabBar.tintColor = UIColor(hex: 0x000000, transparency: 0.9)
        tabBarController.tabBar.barTintColor = UIColor.white
        
        tabBarController.tabBar.backgroundImage = UIImage()
        tabBarController.tabBar.shadowImage = UIImage()
        tabBarController.tabBar.shadowColor = UIColor(hex: 0x000000, transparency: 0.06)
        tabBarController.tabBar.shadowOffset = CGSize(width: 0, height: -0.5)
        tabBarController.tabBar.shadowOpacity = 1
        tabBarController.tabBar.shadowRadius = 0
        
        tabBarController.tabBar.layer.cornerRadius = 16
//        tabBarController.tabBar.layer.masksToBounds = true
        
//        tabBarController.tabBar.isTranslucent = false
        
        tabBarController.viewControllers = [nav1, nav2, nav3, nav4]
        
        return tabBarController
    }
    
}
