//
//  XWHLoginRegisterBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHLoginRegisterBaseVC: XWHBaseVC {
    
    lazy var bgView = UIImageView()
    lazy var otherLoginView = XWHOtherLoginView()
    
    lazy var titleLb = UILabel()
    
    lazy var checkProtocolView = XWHCheckProtocolView()
    
    lazy var loginBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTransparent()
    }
    
//    override func setupNavigationItems() {
//        super.setupNavigationItems()
//    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(bgView)
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)
        titleLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        view.addSubview(titleLb)
        
        view.addSubview(checkProtocolView)
        
        loginBtn.setTitle(R.string.xwhDisplayText.登录(), for: .normal)
        loginBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        loginBtn.layer.cornerRadius = 26
        loginBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.24)?.cgColor
        loginBtn.addTarget(self, action: #selector(clickLoginBtn), for: .touchUpInside)
        view.addSubview(loginBtn)
        
        view.addSubview(otherLoginView)
        
        checkProtocolView.clickUserPtl = {
            
        }
        
        checkProtocolView.clickPrivacyPtl = {
            
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

}

// MARK: - Api
extension XWHLoginRegisterBaseVC {
    
    // 获取第三方登录信息
    func getThirdPlatformUserInfo(loginType: XWHLoginType) {
        var pType = UMSocialPlatformType.unKnown
        
        if loginType == .weixin {
            pType = .wechatSession
        } else if loginType == .qq {
            pType = .QQ
        }
        
        if pType == .unKnown {
            return
        }
        
        XWHUMManager.getUserInfo(pType: pType, vc: self) { [unowned self] cError in
            self.view.makeInsetToast(cError.message)
        } successHandler: { [unowned self] cResponse in
            guard let info = cResponse.data as? UMSocialUserInfoResponse else {
                return
            }
            
            self.gotoBindPhone(loginType: loginType, nickname: info.name, avatar: info.iconurl, wxOpenid: info.usid, qqOpenid: info.usid)
        }
    }
    
}

// MARK: - UI Jump
extension XWHLoginRegisterBaseVC {
    
    func gotoBindPhone(loginType: XWHLoginType, nickname: String, avatar: String, wxOpenid: String, qqOpenid: String) {
        if loginType != .weixin, loginType != .qq {
            return
        }
        
        let vc = XWHBindPhoneVC()
        vc.loginType = loginType
        vc.nickname = nickname
        vc.avatar = avatar
        vc.wxOpenid = wxOpenid
        vc.qqOpenid = qqOpenid
        navigationController?.pushViewController(vc, completion: nil)
    }
    
}
