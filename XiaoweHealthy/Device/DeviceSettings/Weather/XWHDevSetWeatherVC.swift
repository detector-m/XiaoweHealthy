//
//  XWHDevSetWeatherVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetWeatherVC: XWHDevSetBloodPressureVC {
    
    private lazy var isOnWeather = ddManager.getCurrentWeatherSet()?.isOn ?? false

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
        
        cell.button.isSelected = isOnWeather
        
        cell.clickAction = { [unowned cell, unowned self] isOn in
            guard let weatherSet = ddManager.getCurrentWeatherSet() else {
                return
            }
            
            weatherSet.isOn = isOn
            
            if isOn {
                self.checkLocationState { isOk in
                    if isOk {
                        ddManager.saveWeatherSet(weatherSet)

                        self.isOnWeather = isOn
                        cell.button.isSelected = self.isOnWeather
                    }
                }
            } else {
                ddManager.saveWeatherSet(weatherSet)
                
                isOnWeather = isOn
                cell.button.isSelected = isOnWeather
            }
        }
        
        return cell
    }


}

// MARK: - Api
extension XWHDevSetWeatherVC {
    
    private func checkLocationState(_ completion: ((Bool) -> Void)?) {
        AppLocationManager.shared.requestAuthorizationOneTime { [weak self] isEnable, authStatus in
            if !isEnable {
                self?.view.makeInsetToast("未开启定位功能")
                
                return
            }
            
            if authStatus.isAuthorized {
                completion?(authStatus.isAuthorized)
                self?.sendWeatherInfo()
            } else {
                self?.view.makeInsetToast("未授权定位功能")
            }
            
        }
    }
    
    private func sendWeatherInfo() {
        // "CN101010100"
        guard let loc = AppLocationManager.shared.lastLocation else {
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
