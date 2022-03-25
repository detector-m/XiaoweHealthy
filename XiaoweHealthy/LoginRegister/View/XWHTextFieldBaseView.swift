//
//  XWHTextFieldBaseView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHTextFieldBaseView: XWHBaseView {
    
    lazy var titleLb = UILabel()
    lazy var textFiled = UITextField()
    lazy var button = UIButton()

    override func addSubViews() {
        super.addSubViews()
        
        let cFont = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        let cColor = UIColor(hex: 0x000000, transparency: 0.9)
        titleLb.font = cFont
        titleLb.textColor = cColor
        addSubview(titleLb)
        
        textFiled.textColor = cColor
        textFiled.font = cFont
        textFiled.tintColor = UIColor(hex: 0x2DC84D)
        addSubview(textFiled)
        
        addSubview(button)
        
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
    }
    
    override func relayoutSubViews() {
        
    }
    
    @objc func clickButton() {
        
    }

}
