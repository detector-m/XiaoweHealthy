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
    
    private var isPhoneOk = false
    private var isPasswordOk = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumView.textFiled.addTarget(self, action: #selector(textFiledChanged(sender:)), for: .editingChanged)
        passwordView.textFiled.addTarget(self, action: #selector(textFiledChanged(sender:)), for: .editingChanged)
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
        
        let cFont = XWHFont.harmonyOSSans(ofSize: 12)
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
        
        otherLoginView.loginBtn3.isSelected = true
        otherLoginView.loginBtn3.setTitle(R.string.xwhDisplayText.验证码登录(), for: .normal)
        otherLoginView.clickCallback = { [weak self] cType in
            if cType == .phone {
                let vc = XWHLoginVC()
                self?.navigationController?.setViewControllers([vc], animated: true)
                
                return
            }
            
            self?.getThirdPlatformUserInfo(loginType: cType)
        }
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
            make.left.right.equalTo(titleLb)
            make.height.equalTo(20)
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
            make.top.greaterThanOrEqualTo(loginBtn.snp.bottom).offset(30)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-44).priority(.low)
            make.height.equalTo(110)
        }
    }
    
    @objc override func clickNavRightBtn() {
        let vc = XWHResetPasswordVC()
        navigationController?.pushViewController(vc, completion: nil)
    }
    
    @objc override func clickLoginBtn() {
        if !isPhoneOk || !isPasswordOk {
            return
        }
        
        if !checkProtocolView.button.isSelected {
            XWHAlert.show(title: R.string.xwhDisplayText.同意隐私条款(), message: R.string.xwhDisplayText.登录注册需要您阅读并同意用户协议隐私政策(), cancelTitle: R.string.xwhDisplayText.不同意(), confirmTitle: R.string.xwhDisplayText.同意()) { [weak self] acType in
                if acType == .confirm {
                    self?.checkProtocolView.button.isSelected = true
                    self?.gotoLogin()
                }
            }
            
            return
        }
        
        gotoLogin()
    }
    
    @objc func textFiledChanged(sender: UITextField) {
        if sender == phoneNumView.textFiled {
            let phoneCount = phoneNumView.textFiled.text?.count ?? 0
            if phoneCount == 11 {
                isPhoneOk = true
            } else {
                isPhoneOk = false
            }
        } else if sender == passwordView.textFiled {
            let pwCount = passwordView.textFiled.text?.count ?? 0
            if pwCount >= 6 {
                isPasswordOk = true
            } else {
                isPasswordOk = false
            }
        }
        
        if isPhoneOk && isPasswordOk {
            loginBtn.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        } else {
            loginBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.24)?.cgColor
        }
    }

}

// MARK: - Api
extension XWHPasswordLoginVC {
    
    fileprivate func gotoLogin() {
        XWHProgressHUD.show(text: R.string.xwhDisplayText.加速登录中())
        
        let phone = phoneNumView.textFiled.text ?? ""
        let password = passwordView.textFiled.text ?? ""
        
        let vm = XWHLoginRegisterVM()
        vm.login(parameters: vm.getPasswordLoginParameters(phoneNum: phone, password: password)) { [weak self] error in
            XWHProgressHUD.hide()
            
            self?.view.makeInsetToast(error.message)
        } successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            if let cRes = response.data as? JSON {
                if let token = cRes["token"].string, !token.isEmpty {
                    XWHNetworkHelper.setToken(token: token)
                }
                
                let isNewer = cRes["newer"].boolValue
                
                if isNewer {
                    let vc = XWHGenderSelectVC()
                    self?.navigationController?.setViewControllers([vc], animated: true)
                } else {
                    self?.dismiss(animated: true)
                }
            }
        }
    }
    
}

