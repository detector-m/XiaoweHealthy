//
//  XWHCheckPhoneVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/20.
//

import UIKit

/// 验证手机
class XWHCheckPhoneVC: XWHBindPhoneVC {
    
    lazy var userPhone = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = "修改手机号"
        subLb.text = "为保证账号安全，请先进行身份验证"
        
        phoneNumView.textFiled.text = userPhone
        phoneNumView.textFiled.isEnabled = false
        isPhoneOk = true
    }
    
    override func clickConfirmBtn() {
        view.endEditing(true)
        
        if !isCodeOk || !isPhoneOk {
            return
        }
        
        gotoBindPhone()
    }

}

extension XWHCheckPhoneVC {
    
    private func gotoBindPhone() {
        let vc = XWHRebindPhoneVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
