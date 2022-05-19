//
//  XWHLoginVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit
import SwiftyJSON

class XWHLoginVC: XWHLoginRegisterBaseVC {
    
    lazy var logoImageView = UIImageView()
    
    lazy var phoneNumView = XWHPhoneNumView()
    lazy var codeView = XWHCodeView()
    
    private var isPhoneOk = false
    private var isCodeOk = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        otherLoginView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        
        phoneNumView.textFiled.addTarget(self, action: #selector(textFiledChanged(sender:)), for: .editingChanged)
        codeView.textFiled.addTarget(self, action: #selector(textFiledChanged(sender:)), for: .editingChanged)
    }
    
    override func setupNavigationItems() {
        navigationItem.leftBarButtonItem = getNavItem(text: nil, image: R.image.closeO(), target: self, action: #selector(clickNavGlobalBackBtn))
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        bgView.image = R.image.loginBg()
        
        titleLb.textAlignment = .center
        titleLb.text = R.string.xwhDisplayText.欢迎使用小维健康()
        
        logoImageView.image = R.image.logoS()
        view.addSubview(logoImageView)
        
        phoneNumView.layer.cornerRadius = 16
        phoneNumView.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.03)?.cgColor
        view.addSubview(phoneNumView)
        
        codeView.layer.cornerRadius = 16
        codeView.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.03)?.cgColor
        view.addSubview(codeView)
        
        codeView.clickBtnCallback = { [weak self] in
            guard let self = self else {
                return
            }
            
            let phoneNum = self.phoneNumView.textFiled.text ?? ""
            if phoneNum.count != 11 {
                self.view.makeInsetToast(R.string.xwhDisplayText.请输入正确的手机号())
                return
            }
            
            self.codeView.start()
            
            XWHLoginRegisterVM().sendCode(phoneNum: phoneNum) { _ in
                XWHAlert.show(message: R.string.xwhDisplayText.验证码获取失败(), cancelTitle: nil)
            } successHandler: { _ in
                
            }
        }
        
        otherLoginView.clickCallback = { [weak self] cType in
            if cType == .password {
                let vc = XWHPasswordLoginVC()
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
        
        logoImageView.snp.makeConstraints { make in
            make.size.equalTo(66)
            make.top.equalTo(100)
            make.centerX.equalToSuperview()
        }
        
        titleLb.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(40)
        }
        
        phoneNumView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.top.equalTo(titleLb.snp.bottom).offset(40)
            make.height.equalTo(52)
        }
        
        codeView.snp.makeConstraints { make in
            make.centerX.size.equalTo(phoneNumView)
            make.top.equalTo(phoneNumView.snp.bottom).offset(12)
        }
        
        checkProtocolView.snp.makeConstraints { make in
            make.left.right.equalTo(codeView)
            make.top.equalTo(codeView.snp.bottom).offset(20)
            make.height.equalTo(36)
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
    
    @objc override func clickLoginBtn() {
        if gotoUpdateUserInfo() {
            return
        }
        
        if !isCodeOk || !isPhoneOk {
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
        } else {
            let codeCount = codeView.textFiled.text?.count ?? 0
            if codeCount >= 4 {
                isCodeOk = true
            } else {
                isCodeOk = false
            }
        }
        
        if isPhoneOk && isCodeOk {
            loginBtn.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        } else {
            loginBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.24)?.cgColor
        }
    }

}

// MARK: - Api
extension XWHLoginVC {
    
    fileprivate func gotoLogin() {
        XWHProgressHUD.showLogin(text: R.string.xwhDisplayText.加速登录中())
        
        let phone = phoneNumView.textFiled.text ?? ""
        let code = codeView.textFiled.text ?? ""
        
        let vm = XWHLoginRegisterVM()
        vm.login(parameters: vm.getCodeLoginParameters(phoneNum: phone, code: code)) { [weak self] error in
            XWHProgressHUD.hideLogin()
            
            self?.view.makeInsetToast(error.message)
        } successHandler: { [unowned self] response in
            XWHProgressHUD.hideLogin()
            
            if let cRes = response.data as? JSON {
                if let token = cRes["token"].string, !token.isEmpty {
                    XWHUser.setToken(token: token)
                }
                
                let isNewer = cRes["newer"].boolValue
                
//                if isNewer {
//                    let vc = XWHGenderSelectVC()
//                    self?.navigationController?.setViewControllers([vc], animated: true)
//                } else {
//                    self?.dismiss(animated: true, completion: nil)
//                }
                XWHUser.gotoSetUserInfo(at: self, isNewer: isNewer)
            }
        }
    }
    
}

// MARK: - Test
extension XWHLoginVC {
    
    func gotoUpdateUserInfo() -> Bool {
//        let token = XWHUser.getToken() ?? ""
        if XWHUser.isHasToken {
            let vc = XWHGenderSelectVC()
            navigationController?.setViewControllers([vc], animated: true)
            
            return true
        }
            
        return false
    }
    
}
