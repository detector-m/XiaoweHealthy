//
//  XWHDevSetBloodOxygenVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetBloodOxygenVC: XWHDevSetBaseVC {
    
    private lazy var curBOSet: XWHBloodOxygenSetModel? = ddManager.getCurrentBloodOxygenSet()
    lazy var isOxygenOn = curBOSet?.isOn ?? false
    
    lazy var monitorTimes = [10, 30, 60, 60 * 2, 60 * 3,  60 * 4,  60 * 5,  60 * 6,  60 * 7,  60 * 8]
    lazy var sIndex: Int = {
        var ret = 2
        guard let boSet = curBOSet else {
            return ret
        }
        
        guard let cIndex = monitorTimes.firstIndex(of: boSet.duration) else {
            return ret
        }
        
        return cIndex
    }()

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
        if section == 0 {
            return 1
        }
        
        return 3
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
            
            cell.button.isSelected = isOxygenOn
            
            cell.clickAction = { [unowned self] isOn in
                guard let boSet = ddManager.getCurrentBloodOxygenSet() else {
                    return
                }
                
                boSet.isOn = isOn
                
                self.setBloodOxygen(boSet) {
                    XWHDeviceDataManager.saveBloodOxygenSet(boSet)
                    self.isOxygenOn = isOn
                    self.tableView.reloadData()
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHDevSetCommonTBCell.self)
            
            if indexPath.row == 0 {
                cell.titleLb.text = R.string.xwhDeviceText.开始时间()
                cell.subTitleLb.text = curBOSet?.beginTime
            } else if indexPath.row == 1 {
                cell.titleLb.text = R.string.xwhDeviceText.结束时间()
                cell.subTitleLb.text = curBOSet?.endTime
            } else {
                cell.titleLb.text = R.string.xwhDeviceText.监测频率()
            
                let sTimeStr = getTimeText(mTime: monitorTimes[sIndex])
                cell.subTitleLb.text = sTimeStr
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1, indexPath.row == 2 {
            gotoPickMonitorTime()
        }
    }

}

extension XWHDevSetBloodOxygenVC {
    
    // 选取监测频率
    fileprivate func gotoPickMonitorTime() {
        let pickItems = monitorTimes.map({ getTimeText(mTime: $0) })
        XWHPopupPick.show(pickItems: pickItems, sIndex: sIndex) { [unowned self] cType, index in
            if cType == .cancel {
                return
            }
            guard let boSet = ddManager.getCurrentBloodOxygenSet() else {
                return
            }
            
            boSet.duration = self.monitorTimes[index]
            self.setBloodOxygen(boSet) {
                XWHDeviceDataManager.saveBloodOxygenSet(boSet)
                
                self.sIndex = index
                self.tableView.reloadData()
            }
        }
    }
    
}

// MARK: - Api
extension XWHDevSetBloodOxygenVC {
    
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
