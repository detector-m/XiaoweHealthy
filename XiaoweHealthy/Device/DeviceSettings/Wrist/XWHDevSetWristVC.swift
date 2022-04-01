//
//  XWHDevSetWristVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetWristVC: XWHDevSetBaseVC {

    var isWristOn = true
    
    lazy var brightTimes = [5, 10, 15]
    lazy var sIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.抬腕亮屏()
    }

    // MARK: - ConfigUI
    override func registerTableViewCell() {
        tableView.register(cellWithClass: XWHDevSetSwitchTBCell.self)
        
        tableView.register(cellWithClass: XWHDevSetCommonTBCell.self)
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isWristOn {
            return 2
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
        if indexPath.section == 0 {
            return 72
        }
        
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: XWHDevSetSwitchTBCell.self)
            
            cell.titleLb.text = R.string.xwhDeviceText.抬腕亮屏()
            cell.subTitleLb.text = R.string.xwhDeviceText.持续时间未活动设备将震动提醒()
            cell.button.isSelected = isWristOn
            
            cell.clickAction = { [unowned self] isOn in
                self.isWristOn = isOn
                self.tableView.reloadData()
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHDevSetCommonTBCell.self)
            
            cell.titleLb.text = R.string.xwhDeviceText.提醒间隔()
            
            let sTime = brightTimes[sIndex]
            cell.subTitleLb.text = "\(sTime)s"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            gotoPickBrightScreenTime()
        }
    }

}

extension XWHDevSetWristVC {
    
    // 选取亮屏时长
    private func gotoPickBrightScreenTime() {
        let pickItems = brightTimes.map({ $0.string + "s" })
        XWHPopupPick.show(pickItems: pickItems, sIndex: sIndex) { [unowned self] cType, index in
            if cType == .cancel {
                return
            }
            
            self.sIndex = index
            self.tableView.reloadData()
        }
    }
    
}
