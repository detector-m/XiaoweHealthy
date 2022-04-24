//
//  XWHHealthyAllDataBaseTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit


/// 所有数据基础类
class XWHHealthyAllDataBaseTBVC: XWHHealthyDataDetailListBaseTBVC {
    
    override var titleText: String {
        return R.string.xwhHealthyText.所有数据()
    }
    
    lazy var expandStates: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHHealthyAllDataCommonTBCell.self)
        tableView.register(cellWithClass: XWHHealthyDataDetailCommonTBCell.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHHealthyAllDataBaseTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return expandStates.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let isOpen = expandStates[section]
        if isOpen, indexPath.row != 0 {
            return 55
        }
        return 71
    }

}
