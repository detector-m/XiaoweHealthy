//
//  XWHDevSetOxygenVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetOxygenVC: XWHDevSetBaseVC {
    
    var isOxygenOn = true
    
    lazy var monitorTimes = [10, 30, 60, 60 * 2, 60 * 3,  60 * 4,  60 * 5,  60 * 6,  60 * 7,  60 * 8]
    lazy var sIndex = 2

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
            
            cell.clickAction = { [unowned cell, unowned self] isOn in
                let boSet = XWHBloodOxygenSetModel()
                boSet.isOn = isOn
                self.setBloodOxygen(boSet) {
                    XWHDataDeviceManager.saveBloodOxygenSet(boSet)
                    cell.button.isSelected = isOn
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHDevSetCommonTBCell.self)
            
            cell.titleLb.text = R.string.xwhDeviceText.监测频率()
            
            let sTimeStr = getTimeText(mTime: monitorTimes[sIndex])
            cell.subTitleLb.text = sTimeStr
            
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
        let pickItems = monitorTimes.map({ getTimeText(mTime: $0) })
        XWHPopupPick.show(pickItems: pickItems, sIndex: sIndex) { [unowned self] cType, index in
            if cType == .cancel {
                return
            }
            
            let bloodOxygenSet = XWHBloodOxygenSetModel()
            bloodOxygenSet.isSetBeginEndTime = true
            bloodOxygenSet.duration = self.monitorTimes[index]
            self.setBloodOxygen(bloodOxygenSet) {
                bloodOxygenSet.isSetBeginEndTime = false
                XWHDataDeviceManager.saveBloodOxygenSet(bloodOxygenSet)
                self.sIndex = index
                self.tableView.reloadData()
            }
        }
    }
    
}

// MARK: - Api
extension XWHDevSetOxygenVC {
    
    private func setBloodOxygen(_ bloodOxygenSet: XWHBloodOxygenSetModel, _ completion: (() -> Void)?) {
        XWHDDMShared.setBloodOxygenSet(bloodOxygenSet) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(_):
                completion?()
                
            case .failure(_):
                self.view.makeInsetToast("血氧设置失败")
            }
        }
    }
    
}
