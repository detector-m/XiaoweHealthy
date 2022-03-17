//
//  XWHPasswordLoginVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHPasswordLoginVC: XWHLoginRegisterBaseVC {
    
    lazy var subLb = UILabel()
    lazy var phoneNumView = XWHPhoneNumView()
    lazy var passwordView = XWHPasswordView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        navigationItem.rightBarButtonItem = getNavRightItem()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        bgView.image = R.image.loginBg()
        
        titleLb.textAlignment = .left
        titleLb.text = R.string.xwhDisplayText.欢迎使用小维健康()
        
        let cFont = R.font.harmonyOS_Sans(size: 12)
        let cColor = UIColor(hex: 0x000000, transparency: 0.9)
        subLb.font = cFont
        subLb.textColor = cColor
        subLb.alpha = 0.5
        subLb.text = R.string.xwhDisplayText.请使用已经注册过的手机号登录()
        view.addSubview(subLb)
        
        let bgColor = UIColor(hex: 0x000000, transparency: 0.03)
        phoneNumView.layer.cornerRadius = 16
        phoneNumView.layer.backgroundColor = bgColor?.cgColor
        view.addSubview(phoneNumView)
        
        passwordView.layer.cornerRadius = 16
        passwordView.layer.backgroundColor = bgColor?.cgColor
        view.addSubview(passwordView)
        
        checkProtocolView.protocolLb.text = R.string.xwhDisplayText.我已阅读并同意用户协议隐私政策()
    }
    
    override func relayoutSubViews() {
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLb.snp.makeConstraints { make in
            make.top.equalTo(128)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(40)
        }
        
        subLb.snp.makeConstraints { make in
            make.left.right.size.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(6)
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
        
        checkProtocolView.snp.makeConstraints { make in
            make.left.right.equalTo(passwordView)
            make.top.equalTo(passwordView.snp.bottom).offset(20)
            make.height.equalTo(36)
        }
        
        checkProtocolView.protocolLb.snp.updateConstraints { make in
            make.height.equalTo(16)
        }
        
        loginBtn.snp.makeConstraints { make in
            make.centerX.width.equalTo(checkProtocolView)
            make.top.equalTo(checkProtocolView.snp.bottom).offset(32)
            make.height.equalTo(52)
        }
        
        otherLoginView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(69)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-44)
            make.height.equalTo(110)
        }
    }

}
