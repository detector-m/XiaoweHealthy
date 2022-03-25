//
//  XWHBindPhoneVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHBindPhoneVC: XWHRegisterBaseVC {
    
    lazy var phoneNumView = XWHPhoneNumView()
    lazy var codeView = XWHCodeView()
    
    lazy var confirmBtn = UIButton()
    
    var isPhoneOk = false
    var isCodeOk = false
    
    lazy var loginType: XWHLoginType = .phone
    lazy var nickname: String = ""
    lazy var avatar: String = ""
    lazy var wxOpenid: String = ""
    lazy var qqOpenid: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumView.textFiled.addTarget(self, action: #selector(textFiledChanged(sender:)), for: .editingChanged)
        codeView.textFiled.addTarget(self, action: #selector(textFiledChanged(sender:)), for: .editingChanged)
    }

    override func addSubViews() {
        super.addSubViews()
        
        let cColor = UIColor(hex: 0x000000, transparency: 0.9)

        titleLb.textAlignment = .left
        titleLb.text = R.string.xwhDisplayText.您好亲爱的用户()
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 24, weight: .black)
        titleLb.textColor = cColor
        
        let cFont = XWHFont.harmonyOSSans(ofSize: 12)
        subLb.font = cFont
        subLb.textColor = cColor
        subLb.alpha = 0.5
        subLb.numberOfLines = 2
        subLb.text = R.string.xwhDisplayText.为确保您账户的安全及正常使用依网络安全法相关要求账号需绑定手机号()
        
        let bgColor = UIColor(hex: 0x000000, transparency: 0.03)
        phoneNumView.layer.cornerRadius = 16
        phoneNumView.layer.backgroundColor = bgColor?.cgColor
        view.addSubview(phoneNumView)
        
        codeView.layer.cornerRadius = 16
        codeView.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.03)?.cgColor
        view.addSubview(codeView)
        
        confirmBtn.setTitle(R.string.xwhDisplayText.确定(), for: .normal)
        confirmBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize:16, weight: .medium)
        confirmBtn.layer.cornerRadius = 26
        confirmBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.24)?.cgColor
        confirmBtn.addTarget(self, action: #selector(clickConfirmBtn), for: .touchUpInside)
        view.addSubview(confirmBtn)
        
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
            make.height.equalTo(28)
        }
        
        subLb.snp.makeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.height.equalTo(30)
            make.top.equalTo(titleLb.snp.bottom).offset(6)
        }
        
        phoneNumView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.top.equalTo(subLb.snp.bottom).offset(40)
            make.height.equalTo(52)
        }
        
        codeView.snp.makeConstraints { make in
            make.centerX.size.equalTo(phoneNumView)
            make.top.equalTo(phoneNumView.snp.bottom).offset(12)
        }
        
        confirmBtn.snp.makeConstraints { make in
            make.left.right.equalTo(codeView)
            make.top.equalTo(codeView.snp.bottom).offset(32)
            make.height.equalTo(codeView)
        }
    }
    
    @objc func clickConfirmBtn() {
        if !isCodeOk || !isPhoneOk {
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
            confirmBtn.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        } else {
            confirmBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.24)?.cgColor
        }
    }

}

extension XWHBindPhoneVC {
    
    fileprivate func gotoLogin() {
        if loginType != .weixin, loginType != .qq {
            return
        }
                
        let phone = phoneNumView.textFiled.text ?? ""
        let code = codeView.textFiled.text ?? ""
        
        let vm = XWHLoginRegisterVM()
        var param = [String: String]()
        if loginType == .weixin {
            if wxOpenid.isEmpty {
                view.makeInsetToast("wxOpenid 为空")
                return
            }
            
            param = vm.getWeixinLoginParameters(phoneNum: phone, code: code, nickname: nickname, avatar: avatar, wxOpenid: wxOpenid)
        } else if loginType == .qq {
            if qqOpenid.isEmpty {
                view.makeInsetToast("qqOpenid 为空")
                return
            }
            
            param = vm.getQQLoginParameters(phoneNum: phone, code: code, nickname: nickname, avatar: avatar, qqOpenid: qqOpenid)
        }
        
        XWHProgressHUD.show(text: R.string.xwhDisplayText.加速登录中())
        vm.login(parameters: param) { [weak self] error in
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
                }
            }
        }
    }
    
}
