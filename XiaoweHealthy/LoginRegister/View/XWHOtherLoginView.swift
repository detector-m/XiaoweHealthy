//
//  XWHOtherLoginView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHOtherLoginView: XWHBaseView {

    lazy var leftLine = UIView()
    lazy var rightLine = UIView()
    lazy var titleLb = UILabel()
    
    lazy var loginBtn1 = UIButton()
    lazy var loginBtn2 = UIButton()
    lazy var loginBtn3 = UIButton()
    
//    @available(iOS 13.0, *)
    lazy var appleLoginBtn = UIButton()
    
    var clickCallback: ((XWHLoginType) -> Void)?
    
    override func addSubViews() {
        super.addSubViews()
        
        leftLine.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        rightLine.backgroundColor = leftLine.backgroundColor
        
        addSubview(leftLine)
        addSubview(rightLine)
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        titleLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        titleLb.textAlignment = .center
        titleLb.text = R.string.xwhDisplayText.其他登录方式()
        titleLb.alpha = 0.5
        addSubview(titleLb)
        
        loginBtn1.setImage(R.image.wechatIcon(), for: .normal)
        loginBtn1.addTarget(self, action: #selector(clickLoginBtn(sender:)), for: .touchUpInside)
        addSubview(loginBtn1)
        
        loginBtn2.setImage(R.image.qqIcon(), for: .normal)
        loginBtn2.addTarget(self, action: #selector(clickLoginBtn(sender:)), for: .touchUpInside)
        addSubview(loginBtn2)
        
        loginBtn3.setImage(R.image.keyIcon(), for: .normal)
        loginBtn3.setImage(R.image.phoneIcon(), for: .selected)
        loginBtn3.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 14)
        loginBtn3.setTitleColor(UIColor(hex: 0x000000, transparency: 0.9), for: .normal)
        loginBtn3.setTitle(R.string.xwhDisplayText.密码登录(), for: .normal)
        loginBtn3.layer.borderColor = UIColor(hex: 0x979797, transparency: 0.34)?.cgColor
        loginBtn3.layer.cornerRadius = 18
        loginBtn3.layer.borderWidth = 1
        loginBtn3.addTarget(self, action: #selector(clickLoginBtn(sender:)), for: .touchUpInside)
        addSubview(loginBtn3)
        
        if SignInWithApple.isSupport {
            appleLoginBtn.setImage(R.image.siwa_White()?.withRoundedCorners(radius: 19), for: .normal)
            appleLoginBtn.addTarget(self, action: #selector(clickAppleLoginBtn), for: .touchUpInside)
            addSubview(appleLoginBtn)
        }
    }
    
    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.lessThanOrEqualTo(100)
            make.height.equalTo(19)
            make.centerX.equalToSuperview()
        }
        
        leftLine.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.equalToSuperview()
            make.centerY.equalTo(titleLb)
            make.right.equalTo(titleLb.snp.left).offset(-4)
        }
        
        rightLine.snp.makeConstraints { make in
            make.height.equalTo(leftLine)
            make.left.equalTo(titleLb.snp.right).offset(4)
            make.centerY.equalTo(titleLb)
            make.right.equalToSuperview()
        }
        
        loginBtn3.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(27)
            make.right.equalToSuperview()
            make.width.equalTo(105)
            make.height.equalTo(36)
        }
        
        loginBtn1.isHidden = true
        loginBtn2.isHidden = true
        var padding = 0.cgFloat
        if SignInWithApple.isSupport {
            padding = ((UIScreen.main.bounds.width - 63 * 2) - 105 - 38 - 38 - 38) / 3
            
            appleLoginBtn.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.size.equalTo(38)
                make.top.equalTo(titleLb.snp.bottom).offset(26)
            }
            
            if XWHUMManager.isWeixinInstalled, XWHUMManager.isQQInstalled {
                loginBtn1.isHidden = false
                loginBtn2.isHidden = false
                
                loginBtn1.snp.makeConstraints { make in
                    make.left.equalTo(appleLoginBtn.snp.right).offset(padding)
                    make.size.equalTo(38)
                    make.centerY.equalTo(loginBtn3)
                }
                
                loginBtn2.snp.makeConstraints { make in
                    make.left.equalTo(loginBtn1.snp.right).offset(padding)
                    make.centerY.equalTo(loginBtn3)
                    make.size.equalTo(38)
                }
            } else if XWHUMManager.isWeixinInstalled {
                loginBtn1.isHidden = false
                
                padding = ((UIScreen.main.bounds.width - 63 * 2) - 105 - 38 - 38) / 2
                
                loginBtn1.snp.makeConstraints { make in
                    make.left.equalTo(appleLoginBtn.snp.right).offset(padding)
                    make.size.equalTo(38)
                    make.centerY.equalTo(loginBtn3)
                }
            } else if XWHUMManager.isQQInstalled {
                loginBtn2.isHidden = false
                
                padding = ((UIScreen.main.bounds.width - 63 * 2) - 105 - 38 - 38) / 2

                loginBtn2.snp.makeConstraints { make in
                    make.left.equalTo(appleLoginBtn.snp.right).offset(padding)
                    make.size.equalTo(38)
                    make.centerY.equalTo(loginBtn3)
                }
            }
        } else {
            padding = ((UIScreen.main.bounds.width - 63 * 2) - 105 - 38 - 38) / 2
            
            if XWHUMManager.isWeixinInstalled, XWHUMManager.isQQInstalled {
                loginBtn1.isHidden = false
                loginBtn2.isHidden = false
                
                loginBtn1.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.size.equalTo(38)
                    make.centerY.equalTo(loginBtn3)
                }
                
                loginBtn2.snp.makeConstraints { make in
                    make.left.equalTo(loginBtn1.snp.right).offset(padding)
                    make.centerY.equalTo(loginBtn3)
                    make.size.equalTo(38)
                }
            } else if XWHUMManager.isWeixinInstalled {
                loginBtn1.isHidden = false
                
                loginBtn1.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.size.equalTo(38)
                    make.centerY.equalTo(loginBtn3)
                }
            } else if XWHUMManager.isQQInstalled {
                loginBtn2.isHidden = false
                
                loginBtn2.snp.makeConstraints { make in
                    make.left.equalToSuperview()
                    make.centerY.equalTo(loginBtn3)
                    make.size.equalTo(38)
                }
            }
        }
        
        
    }
    
    @objc func clickLoginBtn(sender: UIButton) {
        guard let cCallback = clickCallback else {
            return
        }
        
        if sender == loginBtn1 {
            cCallback(.weixin)
        } else if sender == loginBtn2 {
            cCallback(.qq)
        } else {
            if loginBtn3.isSelected {
                cCallback(.phone)
            } else {
                cCallback(.password)
            }
        }
    }
    
    @objc func clickAppleLoginBtn() {
        guard let cCallback = clickCallback else {
            return
        }
        
        cCallback(.apple)
    }

}
