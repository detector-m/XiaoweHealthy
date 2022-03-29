//
//  XWHSearchDeviceVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/28.
//

import UIKit

class XWHSearchDeviceVC: XWHDeviceBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        navigationItem.rightBarButtonItem = getNavItem(text: R.string.xwhDeviceText.帮助(), image: nil, target: self, action: #selector(clickNavRightBtn))
    }
    
    override func relayoutSubViews() {
        relayoutTitleAndDetailLb()
    }
    
    @objc func clickNavRightBtn() {
//        gotoHelp()
        gotoTest()
    }

}

// MARK: - UI Jump
extension XWHSearchDeviceVC {
    
    fileprivate func gotoHelp() {
        XWHDevice.gotoHelp(at: self)
    }
    
    fileprivate func gotoTest() {
        let vc = XWHBindDeviceVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
