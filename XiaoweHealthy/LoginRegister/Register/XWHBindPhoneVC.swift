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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func addSubViews() {
        super.addSubViews()
        
        let cColor = UIColor(hex: 0x000000, transparency: 0.9)

        titleLb.textAlignment = .left
        titleLb.text = R.string.xwhDisplayText.您好亲爱的用户()
        titleLb.font = R.font.harmonyOS_Sans_Black(size: 24)
        titleLb.textColor = cColor
        
        let cFont = R.font.harmonyOS_Sans(size: 12)
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
        confirmBtn.titleLabel?.font = R.font.harmonyOS_Sans_Medium(size: 16)
        confirmBtn.layer.cornerRadius = 26
        confirmBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.24)?.cgColor
        confirmBtn.addTarget(self, action: #selector(clickConfirmBtn), for: .touchUpInside)
        view.addSubview(confirmBtn)
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
        let vc = XWHGenderSelectVC()
        navigationController?.pushViewController(vc, animated: true)
    }

}
