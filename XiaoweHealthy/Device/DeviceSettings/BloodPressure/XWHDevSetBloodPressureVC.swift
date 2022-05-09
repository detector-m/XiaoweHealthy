//
//  XWHDevSetBloodPressureVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetBloodPressureVC: XWHDevSetBaseVC {
    
    private lazy var isBpOn = ddManager.getCurrentBloodPressureSet()?.isOn ?? false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.压力设置()
    }
    
    // MARK: - ConfigUI
    override func registerTableViewCell() {
        tableView.register(cellWithClass: XWHDevSetSwitchTBCell.self)
    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHDevSetSwitchTBCell.self)
        cell.titleLb.text = R.string.xwhDeviceText.压力自动监测()
        cell.subTitleLb.text = R.string.xwhDeviceText.开启后设备将根据HRV等生理指标测量你的压力情况()
        
        cell.button.isSelected = isBpOn
        
        cell.clickAction = { [unowned cell, unowned self] isOn in
            guard let bpSet = ddManager.getCurrentBloodPressureSet() else {
                return
            }
            bpSet.isOn = isOn
            self.setBloodPressureSet(bpSet) {
                ddManager.saveBloodPressureSet(bpSet)
                
                isBpOn = isOn
                cell.button.isSelected = isBpOn
            }
        }
        
        return cell
    }

}

extension XWHDevSetBloodPressureVC {
    
    private func setBloodPressureSet(_ bloodPressureSet: XWHBloodPressureSetModel, _ completion: (() -> Void)?) {
        XWHDDMShared.setBloodPressureSet(bloodPressureSet) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(_):
                completion?()
                
            case .failure(_):
                self.view.makeInsetToast("血压设置失败")
            }
        }
    }
    
}
