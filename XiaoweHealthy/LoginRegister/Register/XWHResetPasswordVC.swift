//
//  XWHResetPasswordVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHResetPasswordVC: XWHBindPhoneVC {
    
    lazy var passwordView = XWHPasswordView()
    
//    private var isPhoneOk = false
//    private var isCodeOk = false
    private var isPasswordOk = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        phoneNumView.textFiled.addTarget(self, action: #selector(textFiledChanged(sender:)), for: .editingChanged)
        passwordView.textFiled.addTarget(self, action: #selector(textFiledChanged(sender:)), for: .editingChanged)
//        codeView.textFiled.addTarget(self, action: #selector(textFiledChanged(sender:)), for: .editingChanged)
    }
    

    override func setupNavigationItems() {
        super.setupNavigationItems()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        let cColor = UIColor(hex: 0x000000, transparency: 0.9)

        titleLb.textAlignment = .left
        titleLb.text = R.string.xwhDisplayText.重置密码()
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .black)
        
        let cFont = XWHFont.harmonyOSSans(ofSize: 12)
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
            
//            XWHLoginRegisterVM().sendCode(phoneNum: phoneNum) { _ in
//                XWHAlert.show(message: R.string.xwhDisplayText.验证码获取失败(), cancelTitle: nil)
//            } successHandler: { _ in
//                
//            }
        }
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
        if !isPhoneOk || !isCodeOk || !isPasswordOk {
            return
        }
        
        let phoneNum = phoneNumView.textFiled.text ?? ""
        let code = codeView.textFiled.text ?? ""
        let pw = passwordView.textFiled.text ?? ""
        
        gotoResetPassword(phoneNum: phoneNum, code: code, pw: pw)
    }
    
    @objc override func textFiledChanged(sender: UITextField) {
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
        } else {
            let codeCount = codeView.textFiled.text?.count ?? 0
            if codeCount >= 4 {
                isCodeOk = true
            } else {
                isCodeOk = false
            }
        }
        
        if isPhoneOk && isCodeOk && isPasswordOk {
            confirmBtn.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        } else {
            confirmBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.24)?.cgColor
        }
    }

}

// MARK: - Api
extension XWHResetPasswordVC {
    
    fileprivate func gotoResetPassword(phoneNum: String, code: String, pw: String) {
        XWHProgressHUD.show(text: R.string.xwhDisplayText.重置密码中())
        XWHUserVM().setPassword(phoneNum: phoneNum, code: code, password: pw) { [weak self] error in
            XWHProgressHUD.hide()
            self?.view.makeInsetToast(error.message)
        } successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            self?.navigationController?.popToRootViewController(animated: true)
        }

    }
    
}
