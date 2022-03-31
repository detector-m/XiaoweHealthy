//
//  XWHDevSetOxygenVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetOxygenVC: XWHDevSetBaseVC {
    
    var isOxygenOn = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.血氧饱和度设置()
    }
    
    // MARK: - ConfigUI
    override func registerTableViewCell() {
        tableView.register(cellWithClass: XWHDevSetSwitchTBCell.self)
        
        tableView.register(cellWithClass: XWHDevSetCommonTBCell.self)
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isOxygenOn {
            return 2
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
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
            cell.titleLb.text = R.string.xwhDeviceText.自动监测血氧饱和度()
            cell.subTitleLb.text = R.string.xwhDeviceText._24小时自动监测血氧饱和度()
            
            cell.clickAction = { [unowned cell] isOn in
                cell.button.isSelected = isOn
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHDevSetCommonTBCell.self)
            
            cell.titleLb.text = R.string.xwhDeviceText.监测频率()
            cell.subTitleLb.text = "每1小时"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            gotoPickMonitorTime()
        }
    }

}

extension XWHDevSetOxygenVC {
    
    // 选取监测频率
    fileprivate func gotoPickMonitorTime() {
        view.makeInsetToast("选取监测频率")
    }
    
}
