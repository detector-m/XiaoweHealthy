//
//  XWHPersonSettingsTBVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/7.
//

import UIKit

class XWHPersonSettingsTBVC: XWHPersonInfoTBVC {
    
    override var titleText: String {
        R.string.xwhDisplayText.设置()
    }
    
    private var appCacheSize: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAppCacheSize()
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
extension XWHPersonSettingsTBVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHPersonInfoTBCell.self, for: indexPath)
        
        var mainTitle = ""
        var subTitle = ""
        
        cell.subIconView.isHidden = false
        switch indexPath.row {
        case 0:
            mainTitle = "地图引擎"
            subTitle = "高德地图"
            
            cell.subIconView.isHidden = true
            
        case 1:
            mainTitle = "修改手机号"
            subTitle = userModel.mobile
            
        case 2:
            mainTitle = "修改密码"
            subTitle = ""
            
        case 3:
            mainTitle = "清除缓存"
            subTitle = appCacheSize.string + "M"
            
        default:
            break
        }
        
        cell.titleLb.text = mainTitle
        cell.subTitleLb.text = subTitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            // 修改手机号
        } else if indexPath.row == 2 {
            // 修改密码
            gotoResetPassword()
        } else if indexPath.row == 3 {
            // 清除缓存
            gotoCleanAppCache()
        }
    }
    
}

extension XWHPersonSettingsTBVC {
    
    private func getAppCacheSize() {
        AppCacheManager.getAllCacheSize { [weak self] cSize in
            guard let self = self else {
                return
            }
            self.appCacheSize = cSize
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}


// MARK: - UI Jump & Api
extension XWHPersonSettingsTBVC {
    
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
    
    /// 清楚缓存
    private func gotoCleanAppCache() {
        if appCacheSize == 0 {
            return
        }
        
        AppCacheManager.cleanAllCache { [weak self] _ in
            guard let self = self else {
                return
            }
            self.getAppCacheSize()
        }
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

