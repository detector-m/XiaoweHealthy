//
//  XWHChangePwdVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/20.
//

import UIKit

// 修改密码
class XWHChangePwdVC: XWHResetPasswordVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = "修改密码"
    }

}


// MARK: - Api
extension XWHChangePwdVC {
    
    override func gotoResetPassword(phoneNum: String, code: String, pw: String) {
        XWHProgressHUD.showLogin(text: "修改密码中...")
        XWHUserVM().setPassword(phoneNum: phoneNum, code: code, password: pw) { [weak self] error in
            XWHProgressHUD.hideLogin()
            self?.view.makeInsetToast(error.message)
        } successHandler: { [weak self] response in
            XWHProgressHUD.hideLogin()
            
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
}
