//
//  XWHDevSetCallVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetCallVC: XWHDevSetBloodPressureVC {
    
    private static var isShowAuthorize = true
    
    private lazy var isOnCall = ddManager.getCurrentNoticeSet()?.isOnCall ?? false

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = R.string.xwhDeviceText.来电提醒()
    }
    
    // MARK: - ConfigUI
//    override func registerTableViewCell() {
//        tableView.register(cellWithClass: XWHDevSetSwitchTBCell.self)
//    }

    // MARK: - UITableViewDataSource, UITableViewDelegate
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 72
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHDevSetSwitchTBCell.self)
        cell.titleLb.text = R.string.xwhDeviceText.来电提醒()
        cell.subTitleLb.text = R.string.xwhDeviceText.手机有来电时手表会同步震动提醒此功能需要设备和手机是连接状态且蓝牙是开启的()
        
        cell.button.isSelected = isOnCall
        
        cell.clickAction = { [unowned cell, unowned self] isOn in
            guard let noticeSet = ddManager.getCurrentNoticeSet() else {
                return
            }
            noticeSet.isOnCall = isOn
            
            if isOn {
                if Self.isShowAuthorize {
                    XWHAlert.show(title: R.string.xwhDeviceText.授权说明(), message: R.string.xwhDeviceText.在使用过程中本应用需要访问通讯录权限以便在设备上显示来电联系人姓名(), cancelTitle: R.string.xwhDeviceText.拒绝(), confirmTitle: R.string.xwhDeviceText.允许()) { cType in
                        if cType == .confirm {
                            self.setNoticeSet(noticeSet) {
                                XWHDataDeviceManager.saveNoticeSet(noticeSet)
                                
                                isOnCall = isOn
                                cell.button.isSelected = isOnCall
                            }
                        }
                    }
                    
                    Self.isShowAuthorize = false

                    return
                }
            }
            
            self.setNoticeSet(noticeSet) {
                XWHDataDeviceManager.saveNoticeSet(noticeSet)
                
                isOnCall = isOn
                cell.button.isSelected = isOnCall
            }
        }
        
        return cell
    }

}


// MARK: - Api
extension XWHDevSetCallVC {
    
    private func setNoticeSet(_ noticeSet: XWHNoticeSetModel, _ completion: (() -> Void)?) {
        XWHDDMShared.setNoticeSet(noticeSet) { [weak self] result in
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
