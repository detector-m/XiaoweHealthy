//
//  XWHBaseNavigationVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit
import RTRootNavigationController

class XWHBaseNavigationVC: RTRootNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addInteractivePopGestureRecognizerDelegate()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }

}
