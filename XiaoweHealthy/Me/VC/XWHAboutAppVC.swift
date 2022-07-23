//
//  XWHAboutAppVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/18.
//

import UIKit

class XWHAboutAppVC: XWHBaseVC {
    
    private lazy var bgImageView = UIImageView()
    private lazy var logoImageView = UIImageView()
    private lazy var versionLb = UILabel()
    
    private lazy var webTitleLb = UILabel()
    private lazy var mobileTitleLb = UILabel()
    private lazy var webBtn = UIButton()
    private lazy var mobileBtn = UIButton()
    
    private lazy var userBtn = UIButton()
    private lazy var privacyBtn = UIButton()
    
    private var webSite = "www.xiaowe.cc"
    private var mobile = "0755-26902895"

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(bgImageView)
        view.addSubview(logoImageView)
        view.addSubview(versionLb)
        
        view.addSubview(webTitleLb)
        view.addSubview(mobileTitleLb)
        view.addSubview(webBtn)
        view.addSubview(mobileBtn)
        
        view.addSubview(userBtn)
        view.addSubview(privacyBtn)
        
        bgImageView.contentMode = .scaleAspectFit
        logoImageView.contentMode = .scaleAspectFit
        
        let lbfont = XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)
        versionLb.font = lbfont
        versionLb.textColor = fontDarkColor
        versionLb.textAlignment = .center
        
        webTitleLb.font = lbfont
        webTitleLb.textColor = fontDarkColor
        webTitleLb.textAlignment = .right
        
        mobileTitleLb.font = lbfont
        mobileTitleLb.textColor = fontDarkColor
        mobileTitleLb.textAlignment = .right
        
        let btnColor = UIColor(hex: 0x409CFC)
        webBtn.titleLabel?.font = lbfont
        webBtn.setTitleColor(btnColor, for: .normal)
        
        mobileBtn.titleLabel?.font = lbfont
        mobileBtn.setTitleColor(btnColor, for: .normal)
        
        userBtn.titleLabel?.font = lbfont
        userBtn.setTitleColor(fontDarkColor, for: .normal)
        
        privacyBtn.titleLabel?.font = lbfont
        privacyBtn.setTitleColor(fontDarkColor, for: .normal)
        
        bgImageView.image = R.image.about_app_bg()
        logoImageView.image = R.image.about_logo()
        versionLb.text = "V" + Bundle.main.versionNumber
        webTitleLb.text = "访问官网："
        mobileTitleLb.text = "联系我们："
        webBtn.setTitle(webSite, for: .normal)
        mobileBtn.setTitle(mobile, for: .normal)
        userBtn.setTitle("用户协议", for: .normal)
        privacyBtn.setTitle("隐私政策", for: .normal)
        
        webBtn.addTarget(self, action: #selector(clickWebBtn), for: .touchUpInside)
        mobileBtn.addTarget(self, action: #selector(clickMobileBtn), for: .touchUpInside)
        userBtn.addTarget(self, action: #selector(clickUserBtn), for: .touchUpInside)
        privacyBtn.addTarget(self, action: #selector(clickPrivacyBtn), for: .touchUpInside)
    }
    
    override func relayoutSubViews() {
        bgImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(view.snp.width).multipliedBy(482.0 / 375)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.width.equalTo(159)
            make.height.equalTo(107.5)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalToSuperview()
        }
        
        versionLb.snp.makeConstraints { make in
            make.left.right.centerX.equalToSuperview()
            make.top.equalTo(logoImageView.snp.bottom).offset(10)
        }
        
        webTitleLb.snp.makeConstraints { make in
            make.right.equalTo(view.snp.centerX).offset(-16)
            make.left.equalToSuperview()
            make.top.equalTo(versionLb.snp.bottom).offset(40)
            make.height.equalTo(20)
        }
        
        mobileTitleLb.snp.makeConstraints { make in
            make.left.right.height.equalTo(webTitleLb)
            make.top.equalTo(webTitleLb.snp.bottom).offset(12)
        }
        
        webBtn.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX).offset(-16)
            make.right.lessThanOrEqualToSuperview()
            make.height.equalTo(20)
            make.centerY.equalTo(webTitleLb)
        }
        
        mobileBtn.snp.makeConstraints { make in
            make.left.right.height.equalTo(webBtn)
            make.centerY.equalTo(mobileTitleLb)
        }
        
        privacyBtn.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-6)
        }
        
        userBtn.snp.makeConstraints { make in
            make.width.height.bottom.equalTo(privacyBtn)
            make.right.equalTo(privacyBtn.snp.left).offset(-18)
        }
    }
    
    @objc private func clickWebBtn() {
        XWHSafari.present(at: self, urlStr: kRedirectURL)
    }
    
    @objc private func clickMobileBtn() {
        guard let telUrl = URL(string: "tel://\(mobile)") else {
            return
        }
        
        UIApplication.shared.open(telUrl)
    }
    
    @objc private func clickUserBtn() {
        XWHSafari.gotoUserProtocol(at: self)
    }
    
    @objc private func clickPrivacyBtn() {
        XWHSafari.gotoPrivacyProtocol(at: self)
    }

}


extension Bundle {

    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }

    var bundleId: String {
        return bundleIdentifier!
    }

    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }

    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }

}
