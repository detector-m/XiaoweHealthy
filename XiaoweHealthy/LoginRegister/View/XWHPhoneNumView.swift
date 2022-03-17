//
//  XWHPhoneNumView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHPhoneNumView: XWHTextFieldBaseView {

    lazy var lineView = UIView()
    
    override func addSubViews() {
        super.addSubViews()
        
        lineView.backgroundColor = UIColor(hex: 0x000000)
        lineView.alpha = 0.08
        addSubview(lineView)
        
        titleLb.text = "+86"
        button.setImage(R.image.closeGray(), for: .normal)
        
        textFiled.placeholder = R.string.xwhDisplayText.请输入手机号码()
        textFiled.clearButtonMode = .whileEditing
        
        if let clearBtn = textFiled.value(forKey: "_clearButton") as? UIButton {
            clearBtn.setImage(R.image.closeGray(), for: .normal)
        }
    }
    
    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(24)
        }
        
        lineView.snp.makeConstraints { make in
            make.left.equalTo(titleLb.snp.right)
            make.centerY.equalTo(titleLb)
            make.width.equalTo(1)
            make.height.equalTo(18)
        }
        
        textFiled.snp.makeConstraints { make in
            make.left.equalTo(lineView.snp.right).offset(13)
            make.right.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
    }


}
