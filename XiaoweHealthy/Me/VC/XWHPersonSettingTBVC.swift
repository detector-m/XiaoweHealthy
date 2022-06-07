//
//  XWHPersonSettingTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/7.
//

import UIKit

class XWHPersonSettingTBVC: XWHPersonInfoTBVC {
    
    override var titleText: String {
        R.string.xwhDisplayText.设置()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()

        tbFooter.button.setTitle(R.string.xwhDisplayText.退出登录(), for: .normal)
        tbFooter.clickCallback = { [unowned self] in
            self.gotoLogout()
        }
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHPersonInfoTBCell.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
extension XWHPersonSettingTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHPersonInfoTBCell.self, for: indexPath)
        
        cell.titleLb.text = "修改密码"
        
        return cell
    }
    
//   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }

//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 12
//    }
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let cView = UIView()
//        cView.backgroundColor = collectionBgColor
//
//        return cView
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            gotoResetPassword()
        }
    }
    
}


// MARK: - UI Jump & Api
extension XWHPersonSettingTBVC {
    
    /// 修改密码
    private func gotoResetPassword() {
        let vc = XWHResetPasswordVC()
//        vc.userModel = userModel
//        vc.isUpdate = true
//
//        vc.updateCallback = { [weak self] cUserModel in
//            self?.userModel.gender = cUserModel.gender
//            self?.tableView.reloadData()
//        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 退出登录
    private func gotoLogout() {
        if XWHDevice.shared.isSyncing {
            view.makeInsetToast(R.string.xwhDeviceText.正在同步数据())
            return
        }
        
        XWHUser.logout()
        
        navigationController?.popToRootViewController(animated: true)
    }
    
}

