//
//  XWHHealthyDataDetailBaseTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

class XWHHealthyDataDetailBaseTBVC: XWHTableViewBaseVC {
    
    override var titleText: String {
        R.string.xwhHealthyText.数据详情()
    }
    
    lazy var detailId = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        largeTitleView.titleLb.text = titleText
    }
    
    override func setNavigationBarWithLargeTitle() {
        super.setNavigationBarWithLargeTitle()
        
        navigationItem.title = titleText
    }
    
    
    override func resetNavigationBarWithoutLargeTitle() {
        super.resetNavigationBarWithoutLargeTitle()
        
        navigationItem.title = nil
    }
    
    override func addSubViews() {
        super.addSubViews()
        tableView.separatorStyle = .none
        
        setLargeTitleMode()
    }
    
    override func relayoutSubViews() {
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
        
        largeTitleView.button.isHidden = true
        relayoutLargeTitle()
        largeTitleView.relayout(leftRightInset: 16)
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHHealthyDataDetailTBCell.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHHealthyDataDetailBaseTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        rounded(tableView, willDisplay: cell, forRowAt: indexPath, cornerRadius: 12, bgColor: collectionBgColor)
    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
}

