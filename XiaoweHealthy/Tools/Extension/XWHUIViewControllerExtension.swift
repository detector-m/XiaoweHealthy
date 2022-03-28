//
//  XWHUIViewControllerExtension.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/25.
//

import Foundation


extension UIViewController {

    public func setNavTransparent() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    public func resetNavFromTransparent() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    public func addNavInteractivePopGestureRecognizerDelegate() {
        navigationController?.addInteractivePopGestureRecognizerDelegate()
    }

    public func removeNavInteractivePopGestureRecognizerDelegate() {
        navigationController?.removeInteractivePopGestureRecognizerDelegate()
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
