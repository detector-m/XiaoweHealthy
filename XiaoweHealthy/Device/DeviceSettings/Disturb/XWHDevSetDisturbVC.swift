//
//  XWHDevSetDisturbVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetDisturbVC: XWHDevSetBaseVC {

    var isNotDisturb = false
    var isShockOn = false
    var isChatOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.勿扰模式()
    }

    // MARK: - ConfigUI
    override func registerTableViewCell() {
        tableView.register(cellWithClass: XWHDevSetSwitchTBCell.self)
        
        tableView.register(headerFooterViewClassWith: XWHTBHeaderFooterBaseView.self)
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isNotDisturb {
            return 2
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 72
        }
        
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHDevSetSwitchTBCell.self)

        if indexPath.section == 0 {
            cell.titleLb.text = R.string.xwhDeviceText.开启勿扰模式()
            if isNotDisturb {
                cell.subTitleLb.text = R.string.xwhDeviceText.开启勿扰模式后设备会自动关闭抬腕亮屏功能()
            } else {
                cell.subTitleLb.text = R.string.xwhDeviceText.开启勿扰模式后设备会自动关闭抬腕亮屏功能可选择关闭震动和消息提醒功能()
            }
            cell.button.isSelected = isNotDisturb
            
            cell.relayoutTitleSubTitleLb()
        } else if indexPath.section == 1 {
            cell.titleLb.text = R.string.xwhDeviceText.关闭设备震动()
            cell.subTitleLb.text = nil
            cell.button.isSelected = isShockOn
            
            cell.relayoutTitleLb()
        } else {
            cell.titleLb.text = R.string.xwhDeviceText.关闭消息推送()
            cell.subTitleLb.text = nil
            cell.button.isSelected = isChatOn
            
            cell.relayoutTitleLb()
        }
        
        cell.clickAction = { [unowned self, unowned cell] isOn in
            if indexPath.section == 0 {
                self.isNotDisturb = isOn
                self.tableView.reloadData()
            } else if indexPath.section == 1 {
                self.isShockOn = isOn
                cell.button.isSelected = isOn
            } else {
                self.isChatOn = isOn
                cell.button.isSelected = isOn
            }   
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 16
        }
        
        return 0.001
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header = tableView.dequeueReusableHeaderFooterView(withClass: XWHTBHeaderFooterBaseView.self)
            header.titleLb.text = R.string.xwhDeviceText.选择关闭震动和消息提醒功能()
            
            return header
        }
        
        return UIView()
    }

}

extension XWHDevSetDisturbVC {
    
    
    
}

