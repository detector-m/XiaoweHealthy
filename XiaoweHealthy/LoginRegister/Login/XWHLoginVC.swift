//
//  XWHLoginVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHLoginVC: XWHLoginRegisterBaseVC {
    
    lazy var logoImageView = UIImageView()
    
    lazy var phoneNumView = XWHPhoneNumView()
    lazy var codeView = XWHCodeView()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        otherLoginView.clickCallback = { [weak self] cType in
            if cType == .password {
                let vc = XWHPasswordLoginVC()
                self?.navigationController?.setViewControllers([vc], animated: true)
                
                return
            }
            
            if cType == .wechat {
                let vc = XWHBindPhoneVC()
                self?.navigationController?.pushViewController(vc, completion: nil)
                return
            }
            
            if cType == .qq {
                return
            }
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
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-44)
            make.height.equalTo(110)
        }
    }

}
