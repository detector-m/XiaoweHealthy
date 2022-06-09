//
//  XWHSportRecordDetailVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/9.
//

import UIKit


/// 运动详情
class XWHSportRecordDetailVC: XWHBaseVC {
    
    override var titleText: String {
        return "运动详情"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        setNav(color: .white)
        navigationItem.title = titleText
    }

}
