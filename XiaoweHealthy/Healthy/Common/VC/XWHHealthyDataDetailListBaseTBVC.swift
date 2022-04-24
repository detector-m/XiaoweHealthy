//
//  XWHHealthyDataDetailListBaseTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

/// 数据详情列表控制器基础类
class XWHHealthyDataDetailListBaseTBVC: XWHHealthyDataDetailBaseTBVC {
    
    override var titleText: String {
        ""
    }
    
    lazy var valueFont = XWHFont.harmonyOSSans(ofSize: 24, weight: .bold)
    lazy var normalFont = XWHFont.harmonyOSSans(ofSize: 14)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHHealthyDataDetailListTBCell.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHHealthyDataDetailListBaseTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
}
