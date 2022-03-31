//
//  XWHHealthyMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit
import CryptoSwift
import CryptoKit

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
        
//        let vc = XWHLoginVC()
//        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickLoginBtn2() {
        XWHLogin.presentPasswordLogin(at: self)
        
//        testAES()
    }

}


// MARK: - Test
extension XWHHealthyMainVC {
    
    fileprivate func testAES() {
        do {
            let str = "VHn5WXeXswWKN3wRs9bG3w=="
            let keyStr = "EUaIBFQcCS0rEUUs8YAEww=="
            let key = Data(base64Encoded: keyStr)!
            let keyBytes = [UInt8](key)
            
            let aes = try AES(key: keyBytes, blockMode: ECB(), padding: .pkcs5)
            
            let aStr = try str.decryptBase64ToString(cipher: aes)
            
            log.error(aStr)
        } catch let e {
            log.error(e)
        }
    }
    
}
