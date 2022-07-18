//
//  AppPrivacyVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/18.
//

import UIKit

class AppPrivacyVC: UIViewController {
    
    private lazy var contentView = UIView()
    private lazy var titleLb = UILabel()
    private lazy var textView = UITextView()
    
    private lazy var leftBtn = UIButton()
    private lazy var rightBtn = UIButton()
    
    class func getPrivacyNavVC() -> UINavigationController {
        let vc = AppPrivacyVC()
        let nav = UINavigationController(rootViewController: vc)
        
        return nav
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "隐私政策"
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        addSubViews()
        
        contentView.layer.cornerRadius = 16
        contentView.layer.backgroundColor = UIColor.white.cgColor
    }
    
    private func addSubViews() {
        view.addSubview(contentView)
        
        contentView.addSubview(titleLb)
        contentView.addSubview(textView)
        contentView.addSubview(leftBtn)
        contentView.addSubview(rightBtn)
    }
    
    private func relayoutSubViews() {
        
    }
    
    private func configViews() {
        titleLb.text = "欢迎使用小维健康APP"
        
    }

}
