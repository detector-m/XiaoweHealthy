//
//  XWHSportSettingsTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/25.
//

import UIKit

class XWHSportSettingsTBVC: XWHTableViewBaseVC {
    
    override var largeTitleWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }
    
    override var titleText: String {
        R.string.xwhSportText.运动设置()
    }
    
    private lazy var sportSet = XWHSportDataManager.getCurrentSportSet() ?? XWHSportSetModel()
    
    /// 语音播报开关
    private var isSpeechOpen: Bool {
        sportSet.isOn
    }
    
    private lazy var speechTimeIntervalValues = [5, 10, 15, 30, 60]
    private lazy var sSpeechTimeIndex: Int = {
        let _index = speechTimeIntervalValues.firstIndex(of: sportSet.timeInterval) ?? 1
        
        return _index
    }()
    
    /// 心率预警提醒开关
    lazy var isHeartWarnOpen = ddManager.getCurrentHeartSet()?.isHighWarn ?? false
    
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
    
//    override func setupNavigationItems() {
//        super.setupNavigationItems()
//    }
    
    override func setNavigationBarWithLargeTitle() {
        setNav(color: .white)

        navigationItem.title = titleText
        
//        setNavHidden(false, animated: true, async: isFirstTimeSetNavHidden)
    }
    
    @objc private func clickNavLeftItem() {
        
    }
    
    override func resetNavigationBarWithoutLargeTitle() {
        setNavTransparent()
        
        navigationItem.title = nil
        
//        setNavHidden(true, animated: true, async: isFirstTimeSetNavHidden)
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.backgroundColor = collectionBgColor
        
        setLargeTitleMode()
        
        tableView.backgroundColor = view.backgroundColor
        tableView.backgroundColor = tableView.backgroundColor
        tableView.separatorStyle = .none
        
        largeTitleView.titleLb.text = titleText
    }
    
    override func relayoutSubViews() {
        tableView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        relayoutLargeTitle()
        relayoutLargeTitleContentView()
    }
    
    override func relayoutLargeTitleContentView() {
        largeTitleView.relayout { ltView in
            ltView.button.snp.remakeConstraints { make in
                make.right.equalToSuperview().inset(12)
                make.size.equalTo(24)
                make.centerY.equalTo(ltView.titleLb)
            }

            ltView.titleLb.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(40)
                make.left.equalToSuperview().inset(12)
                make.right.lessThanOrEqualTo(ltView.button.snp.left).offset(-10)
            }
        }
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHSportSettingsSwitchTBCell.self)
        tableView.register(cellWithClass: XWHSportSettingsCommponTBCell.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHSportSettingsTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if isSpeechOpen {
                return 6
            }
            
            return 1
        } else {
            if isHeartWarnOpen {
                return 2
            }
            
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 66
        }
        
        return 46
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 5 {
                let cell = tableView.dequeueReusableCell(withClass: XWHSportSettingsCommponTBCell.self)
                cell.titleLb.text = "播报频率"
                
                let timeInterval = speechTimeIntervalValues[sSpeechTimeIndex]
                cell.subTitleLb.text = "\(timeInterval) 分钟"
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withClass: XWHSportSettingsSwitchTBCell.self)
            
            cell.titleLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)
            cell.titleLb.textColor = fontDarkColor.withAlphaComponent(0.6)
            if row == 0 {
                cell.titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
                cell.titleLb.textColor = fontDarkColor
                
                cell.titleLb.text = "语音播报"
                cell.button.isSelected = isSpeechOpen
            } else if row == 1 {
                cell.titleLb.text = "距离"
                cell.button.isSelected = sportSet.isDistanceOn
            } else if row == 2 {
                cell.titleLb.text = "时长"
                cell.button.isSelected = sportSet.isDurationOn
            } else if row == 3 {
                cell.titleLb.text = "配速"
                cell.button.isSelected = sportSet.isPaceOn
            } else if row == 4 {
                cell.titleLb.text = "心率"
                cell.button.isSelected = sportSet.isHeartOn
            }
            
            cell.clickAction = { [unowned self] isOk in
                if row == 0 {
                    sportSet.isOn = isOk
                } else if row == 1 {
                    sportSet.isDistanceOn = isOk
                } else if row == 2 {
                    sportSet.isDurationOn = isOk
                } else if row == 3 {
                    sportSet.isPaceOn = isOk
                } else if row == 4 {
                    sportSet.isHeartOn = isOk
                }
                
                XWHSportDataManager.saveCurrentSportSet(self.sportSet)

                self.tableView.reloadData()
            }
            
            return cell
        } else {
            if row == 0 {
                let cell = tableView.dequeueReusableCell(withClass: XWHSportSettingsSwitchTBCell.self)
                cell.button.isSelected = isHeartWarnOpen
                
                cell.titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
                cell.titleLb.textColor = fontDarkColor
                
                cell.titleLb.text = "心率预警"
                
                cell.clickAction = { [unowned self] isOk in
                    self.isHeartWarnOpen = isOk
                    self.tableView.reloadData()
                }
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withClass: XWHSportSettingsCommponTBCell.self)
            cell.titleLb.text = "预警值设定范围"
            cell.subTitleLb.text = (warnMin + sIndex * 10).string
            
            return cell
        }
    }
    
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       rounded(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }

//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
//    }

//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 20
//    }
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let cView = UIView()
//        cView.backgroundColor = collectionBgColor
//
//        return cView
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {
            if row == 5 {
                gotoPickSpeechTimeIntervalValue()
            }
        } else {
            if row == 1 {
                gotoPickHeartWarnValue()
            }
        }
    }
    
}

// MARK: -
extension XWHSportSettingsTBVC {
    
    private func gotoPickSpeechTimeIntervalValue() {
        let pickItems = speechTimeIntervalValues.map { value in
            return value.string + R.string.xwhDeviceText.分钟()
        }
        XWHPopupPick.show(pickItems: pickItems, sIndex: sSpeechTimeIndex) { [unowned self] cType, index in
            if cType == .cancel {
                return
            }
            
            self.sSpeechTimeIndex = index
            self.sportSet.timeInterval = self.speechTimeIntervalValues[index]
            XWHSportDataManager.saveCurrentSportSet(self.sportSet)
            
            self.tableView.reloadData()
        }
    }
    
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
