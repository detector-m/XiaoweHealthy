//
//  XWHHealthyMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHHealthyMainVC: XWHBaseVC {
    
    lazy var loginBtn: UIButton = UIButton()
    lazy var loginBtn2: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationItems() {
        
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.addTarget(self, action: #selector(clickLoginBtn), for: .touchUpInside)
        loginBtn.backgroundColor = UIColor.red
        view.addSubview(loginBtn)
        
        
        loginBtn2.setTitle("密码登录", for: .normal)
        loginBtn2.addTarget(self, action: #selector(clickLoginBtn2), for: .touchUpInside)
        loginBtn2.backgroundColor = UIColor.red
        view.addSubview(loginBtn2)
    }
    
    override func relayoutSubViews() {
        loginBtn.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
        
        loginBtn2.snp.makeConstraints { make in
            make.centerX.size.equalTo(loginBtn)
            make.top.equalTo(loginBtn.snp.bottom).offset(20)
        }
    }
    

    @objc func clickLoginBtn() {
        XWHLogin.present(at: self)
        
//        testBridge()
    }
    
    @objc func clickLoginBtn2() {
        XWHLogin.presentPasswordLogin(at: self)
        
//        XWHCryptoAES.test()
        
//        testUserProfile()
    }

}


// MARK: - Test
extension XWHHealthyMainVC {
    
    fileprivate func testBridge() {
        let vc = XWHTestWebViewBridgeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func testUserProfile() {
        XWHUserVM().profile { error in
            self.view.makeInsetToast(error.message)
        } successHandler: { response in
            self.view.makeInsetToast(response.data.debugDescription)
        }

    }
    
}
