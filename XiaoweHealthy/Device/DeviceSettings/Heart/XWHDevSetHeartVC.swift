//
//  XWHDevSetHeartVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetHeartVC: XWHDevSetBaseVC {
    
    lazy var isHeartOn = ddManager.getCurrentHeartSet()?.isOn ?? false
    lazy var isHeartHighWarn = ddManager.getCurrentHeartSet()?.isHighWarn ?? false
    
    let warnMin = 100
    let warnMax = 180
    
    lazy var sIndex: Int = {
        guard let heartSet = ddManager.getCurrentHeartSet() else {
            return 0
        }
        if heartSet.highWarnValue < warnMin {
            return 0
        }
        
        let ret = (heartSet.highWarnValue - warnMin) / 10
        
        return ret
    }()

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
                guard let heartSet = ddManager.getCurrentHeartSet() else {
                    return
                }
                
                if indexPath.row == 0 {
                    heartSet.optionType = .none
                    heartSet.isOn = isOn
                    
                    self.setHeartSet(heartSet, nil) {
                        XWHDeviceDataManager.saveHeartSet(heartSet)
                        
                        self.isHeartOn = isOn
                        self.tableView.reloadData()
                    }
                } else {
                    heartSet.optionType = .highWarn
                    heartSet.isHighWarn = isOn
                    let user = XWHUserDataManager.getCurrentUser()
                    self.setHeartSet(heartSet, user) {
                        XWHDeviceDataManager.saveHeartSet(heartSet)
                        
                        self.isHeartHighWarn = isOn
                        self.tableView.reloadData()
                    }
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHDevSetCommonTBCell.self)
            cell.topLine.isHidden = false
            
            cell.titleLb.text = R.string.xwhDeviceText.心率预警值()
            
            let valueStr = (warnMin + sIndex * 10).string + R.string.xwhDeviceText.次分钟()
            cell.subTitleLb.text = valueStr
            
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
        let valueItems = stride(from: warnMin, through: warnMax, by: 10).map { $0 }
        let pickItems = valueItems.map { value in
            return value.string + R.string.xwhDeviceText.次分钟()
        }
        XWHPopupPick.show(pickItems: pickItems, sIndex: sIndex) { [unowned self] cType, index in
            if cType == .cancel {
                return
            }
            guard let heartSet = ddManager.getCurrentHeartSet() else {
                return
            }
            
            heartSet.optionType = .highWarn
            heartSet.highWarnValue = valueItems[index]
            
            let user = XWHUserDataManager.getCurrentUser()
            self.setHeartSet(heartSet, user) {
                XWHDeviceDataManager.saveHeartSet(heartSet)
                
                self.sIndex = index
                self.tableView.reloadData()
            }
        }
    }
    
}

// MARK: - Api
extension XWHDevSetHeartVC {
    
    private func setHeartSet(_ heartSet: XWHHeartSetModel, _ user: XWHUserModel?, _ completion: (() -> Void)?) {
        XWHDDMShared.setHeartSet(heartSet, user) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(_):
                completion?()
                
            case .failure(let error):
                self.view.makeInsetToast(error.message)
            }
        }
    }
    
}
