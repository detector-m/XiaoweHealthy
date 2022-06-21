//
//  XWHLoginRegisterBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit
import IQKeyboardManagerSwift

class XWHLoginRegisterBaseVC: XWHBaseVC {
    
    lazy var bgView = UIImageView()
    lazy var otherLoginView = XWHOtherLoginView()
    
    lazy var titleLb = UILabel()
    
    lazy var checkProtocolView = XWHCheckProtocolView()
    
    lazy var loginBtn = UIButton()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTransparent()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
//    override func setupNavigationItems() {
//        super.setupNavigationItems()
//    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(bgView)
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)
        titleLb.textColor = fontDarkColor
        view.addSubview(titleLb)
        
        view.addSubview(checkProtocolView)
        
        loginBtn.setTitle(R.string.xwhDisplayText.登录(), for: .normal)
        loginBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        loginBtn.layer.cornerRadius = 26
        loginBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.24)?.cgColor
        loginBtn.addTarget(self, action: #selector(clickLoginBtn), for: .touchUpInside)
        view.addSubview(loginBtn)
        
        view.addSubview(otherLoginView)
        
        checkProtocolView.clickUserPtl = { [unowned self] in
            XWHSafari.gotoUserProtocol(at: self)
        }
        
        checkProtocolView.clickPrivacyPtl = { [unowned self] in
            XWHSafari.gotoPrivacyProtocol(at: self)
        }
    }
    
    @objc override func clickNavGlobalBackBtn() {
        dismiss(animated: true, completion: nil)
    }
    
    func getNavRightItem() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setTitle(R.string.xwhDisplayText.忘记密码(), for: .normal)
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 14)
        button.setTitleColor(UIColor.black, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(clickNavRightBtn), for: .touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    @objc func clickNavRightBtn() {
        
    }
    
    @objc func clickLoginBtn() {
        
    }
    
    @objc func keyboardWillShow() {
        if UIScreen.main.bounds.height >= 812 {
            return
        }
        
        UIView.animate(withDuration: 0.25) {
            self.view.y = -60
        }
    }
    
    @objc func keyboardDidHide() {
        UIView.animate(withDuration: 0.25) {
            self.view.y = 0
        }
    }
    
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        IQKeyboardManager.shared.enable = true
    }

}

// MARK: - Api
extension XWHLoginRegisterBaseVC {
    
    // 获取第三方登录信息
    func getThirdPlatformUserInfo(loginType: XWHLoginType) {
        if loginType == .apple {
            getApplePlatformUserInfo()
        } else {
            getUMThirdPlatformUserInfo(loginType: loginType)
        }
    }
    
    func getApplePlatformUserInfo() {
        SignInWithApple.shared.getUserInfo(at: self) { [weak self] cError in
            guard let self = self else {
                return
            }
            self.view.makeInsetToast(cError.message)
        } successHandler: { [weak self] cResponse in
            guard let self = self else {
                return
            }
            
            guard let info = cResponse.data as? SignInWithAppleUserModel else {
                self.view.makeInsetToast(R.string.xwhDisplayText.授权失败())

                return
            }
            
            self.gotoThirdLogin(loginType: .apple, thirdOpenId: info.userid, nickname: info.nickname, avatar: info.avatar)
        }
    }
    
    func getUMThirdPlatformUserInfo(loginType: XWHLoginType) {
        var pType = UMSocialPlatformType.unKnown
        
        if loginType == .weixin {
            pType = .wechatSession
        } else if loginType == .qq {
            pType = .QQ
        }
        
        if pType == .unKnown {
            return
        }
        
        XWHUMManager.getUserInfo(pType: pType, vc: self) { [weak self] cError in
            guard let self = self else {
                return
            }
            
            self.view.makeInsetToast(cError.message)
        } successHandler: { [weak self] cResponse in
            guard let self = self else {
                return
            }
            
            guard let info = cResponse.data as? UMSocialUserInfoResponse else {
                self.view.makeInsetToast(R.string.xwhDisplayText.授权失败())

                return
            }
            
//            self.gotoBindPhone(loginType: loginType, nickname: info.name, avatar: info.iconurl, wxOpenid: info.usid, qqOpenid: info.usid)
//            self.gotoThirdLogin(loginType, info)
            self.gotoThirdLogin(loginType: loginType, thirdOpenId: info.usid ?? "", nickname: info.name, avatar: info.iconurl)
        }
    }
    
    // 第三方登录
    fileprivate func gotoThirdLogin(loginType: XWHLoginType, thirdOpenId: String, nickname: String, avatar: String) {
        if loginType != .weixin, loginType != .qq, loginType != .apple {
            return
        }
        
        let vm = XWHLoginRegisterVM()
        
        var param = [String: String]()
        
        if thirdOpenId.isEmpty {
            log.error("loginType = \(loginType), openid 为空")

            view.makeInsetToast(R.string.xwhDisplayText.授权失败())
            return
        }
        
        if loginType == .weixin {
            param = vm.getWeixinLoginParameters(wxOpenid: thirdOpenId)
        } else if loginType == .qq {
            param = vm.getQQLoginParameters(qqOpenid: thirdOpenId)
        } else if loginType == .apple {
            param = vm.getAppleLoginParameters(appleOpenid: thirdOpenId)
        }
        
        XWHProgressHUD.showLogin(text: R.string.xwhDisplayText.加速登录中())
        vm.login(parameters: param) { [weak self] error in
            XWHProgressHUD.hideLogin()
            
            if error.code.int != 10404 { // 用户不存在
                self?.view.makeInsetToast(error.message)
                return
            }
            
//            self?.gotoBindPhone(loginType: loginType, nickname: nickname, avatar: avatar, wxOpenid: thirdOpenId, qqOpenid: thirdOpenId)
            self?.gotoBindPhone(loginType: loginType, nickname: nickname, avatar: avatar, thirdOpenId: thirdOpenId)
        } successHandler: { [weak self] response in
            XWHProgressHUD.hideLogin()
            guard let self = self else {
                return
            }
            if let cRes = response.data as? JSON {
                if let token = cRes["token"].string, !token.isEmpty {
                    XWHUser.setToken(token: token)
                }
                
                let isNewer = cRes["newer"].boolValue
                
                XWHUser.gotoSetUserInfo(at: self, isNewer: isNewer)
            }
        }
    }
    
}

// MARK: - UI Jump
extension XWHLoginRegisterBaseVC {
    
    func gotoBindPhone(loginType: XWHLoginType, nickname: String, avatar: String, thirdOpenId: String) {
        if loginType != .weixin, loginType != .qq, loginType != .apple {
            return
        }
        
        let vc = XWHBindPhoneVC()
        vc.loginType = loginType
        vc.nickname = nickname
        vc.avatar = avatar
        vc.thirdOpenId = thirdOpenId
        navigationController?.pushViewController(vc, completion: nil)
    }
    
}
