//
//  XWHDevSetHeartVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetHeartVC: XWHDevSetBaseVC {
    
    var isHeartOn = true
    var isHeartHighWarn = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.心率设置()
    }
    
    // MARK: - ConfigUI
    override func registerTableViewCell() {
        tableView.register(cellWithClass: XWHDevSetSwitchTBCell.self)
        
        tableView.register(cellWithClass: XWHDevSetCommonTBCell.self)
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isHeartOn, isHeartHighWarn {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHeartOn {
            if section == 0 {
                return 2
            }

            return 1
        } else {
            return 1
        }
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
            
            if indexPath.row == 0 {
                cell.titleLb.text = R.string.xwhDeviceText.自动监测心率()
                cell.subTitleLb.text = R.string.xwhDeviceText._24小时自动监测心率()
                cell.button.isSelected = isHeartOn
            } else {
                cell.titleLb.text = R.string.xwhDeviceText.心率过高预警()
                cell.subTitleLb.text = R.string.xwhDeviceText.若心率达到预警值设备将震动提醒()
                cell.button.isSelected = isHeartHighWarn
            }
        
            cell.clickAction = { [unowned self] isOn in
                if indexPath.row == 0 {
                    self.isHeartOn = isOn
                    self.tableView.reloadData()
                } else {
                    self.isHeartHighWarn = isOn
                    self.tableView.reloadData()
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHDevSetCommonTBCell.self)
            cell.topLine.isHidden = false
            
            cell.titleLb.text = R.string.xwhDeviceText.心率预警值()
            cell.subTitleLb.text = "5s"
            
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            gotoPickHeartWarnValue()
        }
    }
    
}

// MARK: -
extension XWHDevSetHeartVC {
    
    private func gotoPickHeartWarnValue() {
        view.makeInsetToast("选取一个心率预警值")
    }
    
}
