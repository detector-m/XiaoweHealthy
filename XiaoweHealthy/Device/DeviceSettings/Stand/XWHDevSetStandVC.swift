//
//  XWHDevSetStandVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetStandVC: XWHDevSetBaseVC {

    var isStandOn = true
    var isNotDisturbAtNoon = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.久坐提醒()
    }
    
    // MARK: - ConfigUI
    override func registerTableViewCell() {
        tableView.register(cellWithClass: XWHDevSetSwitchTBCell.self)
        
        tableView.register(cellWithClass: XWHDevSetCommonTBCell.self)
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isStandOn {
            return 3
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 1 {
//            return 1
//        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 52
        }
        
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != 1 {
            let cell = tableView.dequeueReusableCell(withClass: XWHDevSetSwitchTBCell.self)
            
            if indexPath.section == 0 {
                cell.titleLb.text = R.string.xwhDeviceText.开启久坐提醒()
                cell.subTitleLb.text = R.string.xwhDeviceText.持续时间未活动设备将震动提醒()
                cell.button.isSelected = isStandOn
            } else {
                cell.titleLb.text = R.string.xwhDeviceText.午休免打扰()
                cell.subTitleLb.text = R.string.xwhDeviceText._1200到1400点不要打扰我()
                cell.button.isSelected = isNotDisturbAtNoon
            }
            
            cell.clickAction = { [unowned cell, unowned self] isOn in
                if indexPath.section == 0 {
                    isStandOn = isOn
                    self.tableView.reloadData()
                } else {
                    isNotDisturbAtNoon = isOn
                    cell.button.isSelected = isOn
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHDevSetCommonTBCell.self)
            
            cell.titleLb.text = R.string.xwhDeviceText.提醒间隔()
            cell.subTitleLb.text = "1小时"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            gotoPickStandWarnTime()
        }
    }

}

extension XWHDevSetStandVC {
    
    // 选取久坐提醒间隔
    private func gotoPickStandWarnTime() {
        view.makeInsetToast("选取久坐提醒间隔")
    }
    
}
