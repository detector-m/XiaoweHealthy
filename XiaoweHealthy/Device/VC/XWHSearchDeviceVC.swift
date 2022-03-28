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
        titleLb.snp.makeConstraints { make in
            make.top.equalTo(74)
            make.height.equalTo(40)

            make.left.right.equalToSuperview().inset(28)
        }
        detailLb.snp.makeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(6)
            make.height.equalTo(20)
        }
    }
    
    @objc func clickNavRightBtn() {
        gotoHelp()
    }

}

// MARK: - UI Jump
extension XWHSearchDeviceVC {
    
    fileprivate func gotoHelp() {
        XWHSafari.present(at: self, urlStr: kRedirectURL)
    }
    
}
