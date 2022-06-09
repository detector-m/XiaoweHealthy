//
//  XWHSportMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHSportMainVC: XWHBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = collectionBgColor
    }
    
    override func setupNavigationItems() {
        setNav(color: .white)
        
//        let leftItem = getNavItem(text: R.string.xwhDeviceText.我的设备(), font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium), image: nil, target: self, action: #selector(clickNavLeftItem))
//        navigationItem.leftBarButtonItem = leftItem
        
        let rightItem = getNavItem(text: R.string.xwhSportText.运动记录(), font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium), image: nil, target: self, action: #selector(clickNavRightItem))
        navigationItem.rightBarButtonItem = rightItem
    }
//    @objc private func clickNavLeftItem() {
//
//    }
    
    @objc private func clickNavRightItem() {
        gotoSportRecordList()
    }

}


// MARK: - UI Jump
extension XWHSportMainVC {
    
    /// 运动记录列表
    private func gotoSportRecordList() {
        let vc = XWHSportRecordListTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
