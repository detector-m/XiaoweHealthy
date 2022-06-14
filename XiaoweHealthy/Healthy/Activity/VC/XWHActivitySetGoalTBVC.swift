//
//  XWHActivitySetGoalTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/14.
//

import UIKit

class XWHActivitySetGoalTBVC: XWHTableViewBaseVC {
    
    override var titleText: String {
        R.string.xwhHealthyText.设置目标()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        view.backgroundColor = collectionBgColor
        tableView.backgroundColor = view.backgroundColor
        
        setLargeTitleMode()
        
        largeTitleView.titleLb.text = titleText
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
        tableView.register(cellWithClass: XWHActivitySetGoalTBCell.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHActivitySetGoalTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHActivitySetGoalTBCell.self, for: indexPath)
        
        if indexPath.section == 0 {
            cell.titleLb.text = R.string.xwhHealthyText.步数目标()
            cell.subTitleLb.text = "\(8000)" + R.string.xwhHealthyText.步()
        } else if indexPath.section == 1 {
            cell.titleLb.text = R.string.xwhHealthyText.消耗目标()
            cell.subTitleLb.text = "\(100)" + R.string.xwhHealthyText.千卡()
        } else {
            cell.titleLb.text = R.string.xwhHealthyText.距离目标()
            cell.subTitleLb.text = "\(3.3)" + R.string.xwhHealthyText.公里()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

