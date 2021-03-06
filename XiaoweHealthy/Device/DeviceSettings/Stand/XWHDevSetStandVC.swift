//
//  XWHDevSetStandVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetStandVC: XWHDevSetBaseVC {

    private lazy var curLSSet: XWHLongSitSetModel? = ddManager.getCurrentLongSitSet()
    
    lazy var isStandOn = curLSSet?.isOn ?? false
    lazy var isNotDisturbAtNoon = curLSSet?.isSiestaOn ?? false
    
    lazy var warnTimes = [30, 45, 60, 60 * 2, 60 * 3]
    lazy var sIndex: Int = {
        var ret = 2
        guard let lsSet = curLSSet else {
            return ret
        }
        
        guard let cIndex = warnTimes.firstIndex(of: lsSet.duration) else {
            return ret
        }
        
        return cIndex
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.δΉεζι()
    }
    
    // MARK: - ConfigUI
    override func registerTableViewCell() {
        tableView.register(cellWithClass: XWHDevSetSwitchTBCell.self)
        
        tableView.register(cellWithClass: XWHDevSetCommonTBCell.self)
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isStandOn {
            return 3
        }
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 3
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 52
        }
        
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != 1 {
            let cell = tableView.dequeueReusableCell(withClass: XWHDevSetSwitchTBCell.self)
            
            if indexPath.section == 0 {
                cell.titleLb.text = R.string.xwhDeviceText.εΌε―δΉεζι()
                cell.subTitleLb.text = R.string.xwhDeviceText.ζη»­ζΆι΄ζͺζ΄»ε¨θ?Ύε€ε°ιε¨ζι()
                cell.button.isSelected = isStandOn
            } else {
                cell.titleLb.text = R.string.xwhDeviceText.εδΌεζζ°()
                cell.subTitleLb.text = R.string.xwhDeviceText._1200ε°1400ηΉδΈθ¦ζζ°ζ()
                cell.button.isSelected = isNotDisturbAtNoon
            }
            
            cell.clickAction = { [unowned cell, unowned self] isOn in
                guard let longSitSet = ddManager.getCurrentLongSitSet() else {
                    return
                }
                if indexPath.section == 0 {
                    longSitSet.isOn = isOn
                } else {
                    longSitSet.isSiestaOn = isOn
                }
                
                self.setLongSitSet(longSitSet) {
                    XWHDeviceDataManager.saveLongSitSet(longSitSet)

                    if indexPath.section == 0 {
                        self.isStandOn = isOn
                        self.tableView.reloadData()
                    } else {
                        self.isNotDisturbAtNoon = isOn
                        cell.button.isSelected = isOn
                    }
                }
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHDevSetCommonTBCell.self)
            
            if indexPath.row == 0 {
                cell.titleLb.text = R.string.xwhDeviceText.εΌε§ζΆι΄()
                cell.subTitleLb.text = curLSSet?.beginTime
            } else if indexPath.row == 1 {
                cell.titleLb.text = R.string.xwhDeviceText.η»ζζΆι΄()
                cell.subTitleLb.text = curLSSet?.endTime
            } else {
                cell.titleLb.text = R.string.xwhDeviceText.ζιι΄ι()
                
                let sTimeStr = getTimeText(mTime: warnTimes[sIndex])
                cell.subTitleLb.text = sTimeStr
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1, indexPath.row == 2 {
            gotoPickStandWarnTime()
        }
    }

}

extension XWHDevSetStandVC {
    
    // ιεδΉεζιι΄ι
    private func gotoPickStandWarnTime() {
        let pickItems = warnTimes.map({ getTimeText(mTime: $0) })
        XWHPopupPick.show(pickItems: pickItems, sIndex: sIndex) { [unowned self] cType, index in
            if cType == .cancel {
                return
            }
            
            guard let longSitSet = ddManager.getCurrentLongSitSet() else {
                return
            }
            longSitSet.duration = self.warnTimes[index]
            self.setLongSitSet(longSitSet) {
                XWHDeviceDataManager.saveLongSitSet(longSitSet)
                
                self.sIndex = index
                self.tableView.reloadData()
            }
        }
    }

}

// MARK: - Api
extension XWHDevSetStandVC {
    
    // Device Api
    private func setLongSitSet(_ longSitSet: XWHLongSitSetModel, _ completion: (() -> Void)?) {
        XWHDDMShared.setLongSitSet(longSitSet) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(_):
                completion?()
                
            case .failure(_):
                self.view.makeInsetToast("δΉεζιθ?Ύη½?ε€±θ΄₯")
            }
        }
    }
    
    
}

