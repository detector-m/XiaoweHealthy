//
//  XWHPasswordView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHPasswordView: XWHTextFieldBaseView {

    override func addSubViews() {
        super.addSubViews()
        
        titleLb.isEnabled = true
        button.setImage(R.image.eyeOff(), for: .normal)
        
        textFiled.placeholder = R.string.xwhDisplayText.请输入密码()
        textFiled.clearButtonMode = .never
        textFiled.isSecureTextEntry = true
    }
    
    override func relayoutSubViews() {
        button.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.size.equalTo(22)
            make.centerY.equalToSuperview()
        }
        
        textFiled.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(button.snp.left).offset(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
    }

}
