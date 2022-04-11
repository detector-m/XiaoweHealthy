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
    
    lazy var warnTimes = [30, 45, 60, 60 * 2, 60 * 3]
    lazy var sIndex = 2

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
                    let longSitSet = XWHLongSitSetModel()
                    XWHDDMShared.setLongSitSet(longSitSet) { [weak self] result in
                        guard let self = self else {
                            return
                        }
                        
                        switch result {
                        case .success(_):
                            self.isStandOn = isOn
                            self.tableView.reloadData()
                            
                        case .failure(_):
                            self.view.makeInsetToast("久坐提醒设置失败")
                        }
                    }
                    
                } else {
                    isNotDisturbAtNoon = isOn
                    cell.button.isSelected = isOn
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHDevSetCommonTBCell.self)
            
            cell.titleLb.text = R.string.xwhDeviceText.提醒间隔()
            
            let sTimeStr = getTimeText(mTime: warnTimes[sIndex])
            cell.subTitleLb.text = sTimeStr
            
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
        let pickItems = warnTimes.map({ getTimeText(mTime: $0) })
        XWHPopupPick.show(pickItems: pickItems, sIndex: sIndex) { [unowned self] cType, index in
            if cType == .cancel {
                return
            }
            
            self.sIndex = index
            self.tableView.reloadData()
        }
    }

}

extension XWHDevSetStandVC {
    
    
    
}

