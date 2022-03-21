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
    }
    
//    override func setupNavigationItems() {
//        super.setupNavigationItems()
//    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(bgView)
        
        titleLb.font = R.font.harmonyOS_Sans_Black(size: 30)
        titleLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        view.addSubview(titleLb)
        
        view.addSubview(checkProtocolView)
        
        loginBtn.setTitle(R.string.xwhDisplayText.登录(), for: .normal)
        loginBtn.titleLabel?.font = R.font.harmonyOS_Sans_Medium(size: 16)
        loginBtn.layer.cornerRadius = 26
        loginBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.24)?.cgColor
        loginBtn.addTarget(self, action: #selector(clickLoginBtn), for: .touchUpInside)
        view.addSubview(loginBtn)
        
        view.addSubview(otherLoginView)
    }
    
    @objc override func clickNavGlobalBackBtn() {
        dismiss(animated: true, completion: nil)
    }
    
    func getNavRightItem() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setTitle(R.string.xwhDisplayText.忘记密码(), for: .normal)
        button.titleLabel?.font = R.font.harmonyOS_Sans(size: 14)
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
