//
//  XWHDevSetWeatherVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetWeatherVC: XWHDevSetPressureVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.天气推送()
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHDevSetSwitchTBCell.self)
        cell.titleLb.text = R.string.xwhDeviceText.天气推送()
        cell.subTitleLb.text = R.string.xwhDeviceText.开启后设备将接收手机的天气信息()
        
        cell.clickAction = { [unowned cell] isOn in
            cell.button.isSelected = isOn
        }
        
        return cell
    }


}
