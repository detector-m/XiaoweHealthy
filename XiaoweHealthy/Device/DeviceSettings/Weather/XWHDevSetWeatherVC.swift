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
        
        cell.clickAction = { [unowned cell, unowned self] isOn in
            self.checkLocationState { isOk in
                if isOk {
                    cell.button.isSelected = isOn
                }
            }
        }
        
        return cell
    }


}

// MARK: - Api
extension XWHDevSetWeatherVC {
    
    private func checkLocationState(_ completion: ((Bool) -> Void)?) {
        if !XWHLocation.shared.locationEnabled() {
            view.makeInsetToast("未开启定位功能")
            return
        }
        
        XWHLocation.shared.checkState { [weak self] isOk in
            if isOk {
                completion?(isOk)
                self?.sendWeatherInfo()
            } else {
                self?.view.makeInsetToast("未授权定位功能")
            }
        }
    }
    
    private func sendWeatherInfo() {
        // "CN101010100"
        guard let loc = XWHLocation.shared.currentLocation else {
            view.makeInsetToast("未定位到坐标")
            return
        }
        
        XWHDDMShared.sendWeatherServiceWeatherInfo(cityId: nil, latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude) { [weak self] result in
            switch result {
            case .success(_):
                self?.view.makeInsetToast("设置天气成功")

            case .failure(let error):
                self?.view.makeInsetToast(error.message)
            }
        }
    }
    
}
