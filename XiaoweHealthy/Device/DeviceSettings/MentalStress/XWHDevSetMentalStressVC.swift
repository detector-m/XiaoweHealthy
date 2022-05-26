//
//  XWHDevSetMentalStressVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/9.
//

import UIKit

class XWHDevSetMentalStressVC: XWHDevSetBaseVC {
    
    private lazy var isMsOn = ddManager.getCurrentMentalStressSet()?.isOn ?? false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.情绪压力设置()
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
        
        cell.button.isSelected = isMsOn
        
        cell.clickAction = { [unowned cell, unowned self] isOn in
            guard let msSet = ddManager.getCurrentMentalStressSet() else {
                return
            }
            msSet.isOn = isOn
            self.setMentalStressSet(msSet) {
                ddManager.saveMentalStressSet(msSet)
                
                isMsOn = isOn
                cell.button.isSelected = isMsOn
            }
        }
        
        return cell
    }

}

extension XWHDevSetMentalStressVC {
    
    private func setMentalStressSet(_ mentalStressSet: XWHMentalStressSetModel, _ completion: (() -> Void)?) {
        XWHDDMShared.setMentalStressSet(mentalStressSet) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(_):
                completion?()

            case .failure(_):
                self.view.makeInsetToast("精神压力设置失败")
            }
        }
    }
    
}
