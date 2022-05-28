//
//  XWHUIViewControllerExtension.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/25.
//

import Foundation
import UIKit


extension UIViewController {

    public func setNavTransparent() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    public func resetNavFromTransparent() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    public func setNav(color : UIColor) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(color: color, size: CGSize(width: 1, height: 1)), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    public func setNavHidden(_ isHidden: Bool, animated: Bool = true, async: Bool = false) {
        guard let nav = navigationController else {
            return
        }
        
        if async {
            DispatchQueue.main.async {
                nav.setNavigationBarHidden(isHidden, animated: animated)
            }
        } else {
            nav.setNavigationBarHidden(isHidden, animated: animated)
        }
    }
    
//    public func addNavInteractivePopGestureRecognizerDelegate() {
//        navigationController?.addInteractivePopGestureRecognizerDelegate()
//    }
//
//    public func removeNavInteractivePopGestureRecognizerDelegate() {
//        navigationController?.removeInteractivePopGestureRecognizerDelegate()
//    }
    
    /// navigationController 倒数第二个 VC
    public func navTopPreviousVC() -> UIViewController? {
        var vcArray = navigationController?.viewControllers
        vcArray?.removeLast()
        
        return vcArray?.last
    }

}

//extension UIViewController: UIGestureRecognizerDelegate {
//    
//    public func addNavInteractivePopGestureRecognizerDelegate() {
//        navigationController?.interactivePopGestureRecognizer?.delegate = self
//    }
//    
//    public func removeNavInteractivePopGestureRecognizerDelegate() {
//        navigationController?.interactivePopGestureRecognizer?.delegate = nil
//    }
//    
//    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if children.count == 1 {
//            return false
//        }
//        
//        return true
//    }
//    
//}
