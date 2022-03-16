//
//  XWHHealthyMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHHealthyMainVC: XWHBaseVC {
    
    lazy var loginBtn: UIButton = UIButton()

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
    }
    
    override func relayoutSubViews() {
        loginBtn.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
    }
    

    @objc func clickLoginBtn() {
        let loginVC = XWHLoginVC()
        let loginNav = XWHBaseNavigationVC(rootViewController: loginVC)
        loginNav.modalPresentationStyle = .fullScreen
        present(loginNav, animated: true, completion: nil)
    }

}
