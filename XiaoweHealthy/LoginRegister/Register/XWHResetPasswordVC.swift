//
//  XWHResetPasswordVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHResetPasswordVC: XWHBindPhoneVC {
    
    lazy var passwordView = XWHPasswordView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func setupNavigationItems() {
        super.setupNavigationItems()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        let cColor = UIColor(hex: 0x000000, transparency: 0.9)

        titleLb.textAlignment = .left
        titleLb.text = R.string.xwhDisplayText.重置密码()
        titleLb.font = R.font.harmonyOS_Sans_Black(size: 30)
        
        let cFont = R.font.harmonyOS_Sans(size: 12)
        subLb.font = cFont
        subLb.textColor = cColor
        subLb.alpha = 0.5
        subLb.text = R.string.xwhDisplayText.请使用已注册过的手机号验证新密码长度不小于6位()
        
        let bgColor = UIColor(hex: 0x000000, transparency: 0.03)
        passwordView.layer.cornerRadius = 16
        passwordView.layer.backgroundColor = bgColor?.cgColor
        passwordView.textFiled.placeholder = R.string.xwhDisplayText.请输入新密码()
        view.addSubview(passwordView)
        
        
//        confirmBtn.setTitle(R.string.xwhDisplayText.确认修改(), for: .normal)
//        confirmBtn.titleLabel?.font = R.font.harmonyOS_Sans_Medium(size: 16)
//        confirmBtn.layer.cornerRadius = 26
//        confirmBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.24)?.cgColor
    }
    
    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.top.equalTo(128)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(40)
        }
        
        subLb.snp.makeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(6)
            make.height.equalTo(16)
        }
        
        phoneNumView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.top.equalTo(subLb.snp.bottom).offset(40)
            make.height.equalTo(52)
        }
        
        passwordView.snp.makeConstraints { make in
            make.top.equalTo(phoneNumView.snp.bottom).offset(12)
            make.centerX.size.equalTo(phoneNumView)
        }
        
        codeView.snp.makeConstraints { make in
            make.centerX.size.equalTo(passwordView)
            make.top.equalTo(passwordView.snp.bottom).offset(12)
        }
        
        confirmBtn.snp.makeConstraints { make in
            make.left.right.equalTo(codeView)
            make.top.equalTo(codeView.snp.bottom).offset(32)
            make.height.equalTo(codeView)
        }
    }
    
    @objc override func clickConfirmBtn() {
        
    }

}
