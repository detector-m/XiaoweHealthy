//
//  XWHLoginVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHLoginVC: XWHLoginRegisterBaseVC {
    
    lazy var logoImageView = UIImageView()

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
        
        otherLoginView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(69)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-44)
            make.height.equalTo(110)
        }
    }

}
