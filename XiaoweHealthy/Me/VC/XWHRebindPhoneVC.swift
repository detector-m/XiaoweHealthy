//
//  XWHRebindPhoneVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/20.
//

import UIKit

class XWHRebindPhoneVC: XWHCheckPhoneVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func addSubViews() {
        super.addSubViews()
        
        titleLb.text = "绑定手机号"
        subLb.text = ""
        
        phoneNumView.textFiled.text = nil
        phoneNumView.textFiled.isEnabled = true
        isPhoneOk = false
    }

}
