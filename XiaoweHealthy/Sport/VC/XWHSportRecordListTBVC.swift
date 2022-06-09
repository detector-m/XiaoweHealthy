//
//  XWHSportRecordListTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/9.
//

import UIKit

class XWHSportRecordListTBVC: XWHTableViewBaseVC {
    
    override var titleText: String {
        return R.string.xwhSportText.运动记录()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        navigationItem.title = titleText
    }

}
