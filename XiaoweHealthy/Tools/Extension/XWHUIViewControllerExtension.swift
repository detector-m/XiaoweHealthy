//
//  XWHUIViewControllerExtension.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/25.
//

import Foundation


extension UIViewController {

    func setNavTransparent() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func resetNavFromTransparent() {
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }

}
