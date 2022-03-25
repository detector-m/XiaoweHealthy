//
//  XWHRegisterBaseVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHRegisterBaseVC: XWHBaseVC {
    
    lazy var titleLb = UILabel()
    lazy var subLb = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTransparent()
    }

    override func addSubViews() {
        super.addSubViews()
        
        let cColor = UIColor(hex: 0x000000, transparency: 0.9)

        titleLb.textAlignment = .left
        titleLb.text = ""
        titleLb.font = R.font.harmonyOS_Sans_Black(size: 30)
        titleLb.textColor = cColor
        view.addSubview(titleLb)
        
        let cFont = R.font.harmonyOS_Sans(size: 14)
        subLb.font = cFont
        subLb.textColor = cColor
        subLb.alpha = 0.5
        subLb.text = ""
        view.addSubview(subLb)
    }
    
    func layoutTitleSubTitle() {
        titleLb.snp.makeConstraints { make in
            make.top.equalTo(108)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(40)
        }
        
        subLb.snp.makeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(6)
            make.height.equalTo(16)
        }
    }
    

}
