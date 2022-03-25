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
        let normalAttr: [NSAttributedString.Key : Any] = [.font: font]
        let selectedAttr: [NSAttributedString.Key : Any] = [.font: font, .foregroundColor: UIColor.orange]
        
        nav1.tabBarItem = ESTabBarItem.init(title: R.string.xwhDisplayText.健康(), image: R.image.tabHealth(), selectedImage: R.image.tabHealth())
//        nav1.tabBarItem.setTitleTextAttributes(normalAttr, for: .normal)
//        nav1.tabBarItem.setTitleTextAttributes(selectedAttr, for: .selected)
        
        nav2.tabBarItem = ESTabBarItem.init(title: R.string.xwhDisplayText.运动(), image: R.image.tabSport(), selectedImage: R.image.tabSport())
//        nav2.tabBarItem.setTitleTextAttributes(normalAttr, for: .normal)
//        nav2.tabBarItem.setTitleTextAttributes(selectedAttr, for: .selected)
        
        nav3.tabBarItem = ESTabBarItem.init(title: R.string.xwhDisplayText.设备(), image: R.image.tabDevice(), selectedImage: R.image.tabDevice())
//        nav3.tabBarItem.setTitleTextAttributes(normalAttr, for: .normal)
//        nav3.tabBarItem.setTitleTextAttributes(selectedAttr, for: .selected)
        
        nav4.tabBarItem = ESTabBarItem.init(title: R.string.xwhDisplayText.我的(), image: R.image.tabMe(), selectedImage: R.image.tabMe())
//        nav4.tabBarItem.setTitleTextAttributes(normalAttr, for: .normal)
//        nav4.tabBarItem.setTitleTextAttributes(selectedAttr, for: .selected)
        
        tabBarController.viewControllers = [nav1, nav2, nav3, nav4]
        
//        tabBarController.tabBar.backgroundColor = UIColor.white
//        tabBarController.tabBar.tintColor = UIColor.orange
//        tabBarController.tabBar.barTintColor = UIColor.white
//        tabBarController.tabBar.isTranslucent = false
//        
//        UIBarItem.appearance().setTitleTextAttributes(normalAttr, for: .normal)
//        UIBarItem.appearance().setTitleTextAttributes(selectedAttr, for: .selected)
        
        return tabBarController
    }
    
}
