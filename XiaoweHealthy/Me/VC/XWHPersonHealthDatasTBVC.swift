//
//  XWHPersonHealthDatasTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/8.
//

import UIKit


/// 我的数据
class XWHPersonHealthDatasTBVC: XWHTableViewBaseVC {
    
    override var titleText: String {
        R.string.xwhDisplayText.我的数据()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNav(color: .white)
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        navigationItem.title = titleText
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        tableView.separatorStyle = .none
    }
    
    override func relayoutSubViews() {
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHMeNormalTBCell.self)
        
        tableView.register(headerFooterViewClassWith: XWHTBHeaderFooterBaseView.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHPersonHealthDatasTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHMeNormalTBCell.self, for: indexPath)
        
        cell.titleLb.text = nil
        cell.subTitleLb.text = nil
        
        if indexPath.section == 0 {
            if indexPath.row == 0 { // 步数
                cell.titleLb.text = "步数"
            } else if indexPath.row == 1 { // 距离
                cell.titleLb.text = "距离"
            } else if indexPath.row == 2 { // 热量
                cell.titleLb.text = "热量"
            }
        } else {
            if indexPath.row == 0 { // 心率
                cell.titleLb.text = "心率"
            } else if indexPath.row == 1 { // 血氧
                cell.titleLb.text = "血氧"
            } else if indexPath.row == 2 { // 睡眠
                cell.titleLb.text = "睡眠"
            } else if indexPath.row == 3 { // 压力
                cell.titleLb.text = "压力"
            } else if indexPath.row == 4 { // 情绪
                cell.titleLb.text = "情绪"
            }
        }
        
        return cell
    }
    
//   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withClass: XWHTBHeaderFooterBaseView.self)
        
        if section == 0 {
            headerView.titleLb.text = "活动统计"
        } else {
            headerView.titleLb.text = "健康状况"
        }
        
        return headerView
    }

//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 12
//    }
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let cView = UIView()
//        cView.backgroundColor = collectionBgColor
//
//        return cView
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 { // 步数
                
            } else if indexPath.row == 1 { // 距离
                
            } else if indexPath.row == 2 { // 热量
                
            }
        } else {
            if indexPath.row == 0 { // 心率
                gotoHeartDatas()
            } else if indexPath.row == 1 { // 血氧
                gotoBODatas()
            } else if indexPath.row == 2 { // 睡眠
                gotoSleepDatas()
            } else if indexPath.row == 3 { // 压力
                gotoMentalStressDatas()
            } else if indexPath.row == 4 { // 情绪
                gotoMoodDatas()
            }
        }
    }
    
}


// MARK: - UI Jump
extension XWHPersonHealthDatasTBVC {
    
    /// 跳转心率数据
    private func gotoHeartDatas() {
        let vc = XWHHeartAllDataTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转血氧数据
    private func gotoBODatas() {
        let vc = XWHBOAllDataTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转睡眠数据
    private func gotoSleepDatas() {
        let vc = XWHSleepAllDataTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转压力数据
    private func gotoMentalStressDatas() {
        let vc = XWHMentalStressAllDataTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 情绪数据
    private func gotoMoodDatas() {
        let vc = XWHMoodAllDataTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
