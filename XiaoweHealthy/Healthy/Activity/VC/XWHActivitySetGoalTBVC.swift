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

    private var stepGoalValues: [Int] {
        [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 15000, 20000, 25000, 30000, 35000, 40000, 50000]
    }
    
    private var calGoalValues: [Int] {
        [100, 200, 300, 400, 500, 600, 700, 800, 900, 1000]
    }
    
    private var distanceGoalValues: [Int] {
        [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
    }
    
    private var sAtType: XWHActivityType = .step
    
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
        
        let user = XWHDataUserManager.getCurrentUser()
        
        if indexPath.section == 0 {
            cell.titleLb.text = R.string.xwhHealthyText.步数目标()
            cell.subTitleLb.text = "\(user?.stepGoal ?? 8000)" + R.string.xwhHealthyText.步()
        } else if indexPath.section == 1 {
            cell.titleLb.text = R.string.xwhHealthyText.消耗目标()
            cell.subTitleLb.text = "\(user?.caloriesGoal ?? 300)" + R.string.xwhHealthyText.千卡()
        } else {
            cell.titleLb.text = R.string.xwhHealthyText.距离目标()
            let distanceGoal = (user?.distanceGoal ?? 3000) / 1000
            cell.subTitleLb.text = "\(distanceGoal)" + R.string.xwhHealthyText.公里()
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let atTypes: [XWHActivityType] = [.step, .cal, .distance]
        sAtType = atTypes[indexPath.section]
        
        gotoPickGoalValue()
    }
    
}

extension XWHActivitySetGoalTBVC {
    
    /// 选择目标数
    private func gotoPickGoalValue() {
        guard var user = XWHDataUserManager.getCurrentUser() else {
            log.error("未获取用户信息")
            return
        }
        
        var pickItems: [String] = []
        var sIndex = 0
        if sAtType == .step {
            sIndex = stepGoalValues.firstIndex(of: user.stepGoal) ?? 7
            pickItems = stepGoalValues.map { value in
                return value.string + R.string.xwhHealthyText.步()
            }
        } else if sAtType == .cal {
            sIndex = calGoalValues.firstIndex(of: user.caloriesGoal) ?? 2
            
            pickItems = calGoalValues.map { value in
                return value.string + R.string.xwhHealthyText.千卡()
            }
        } else {
            sIndex = distanceGoalValues.firstIndex(of: user.distanceGoal) ?? 2
            
            pickItems = distanceGoalValues.map { value in
                let kmValue = value / 1000
                return kmValue.string + R.string.xwhHealthyText.公里()
            }
        }
        
        XWHPopupPick.show(pickItems: pickItems, sIndex: sIndex) { [unowned self] cType, index in
            if cType == .cancel {
                return
            }
            
            if sAtType == .step {
                user.stepGoal = stepGoalValues[index]
            } else if sAtType == .cal {
                user.caloriesGoal = calGoalValues[index]
            } else {
                user.distanceGoal = distanceGoalValues[index]
            }
            
            XWHDataUserManager.saveUser(&user)
            
            self.tableView.reloadData()
        }
    }
    
}

