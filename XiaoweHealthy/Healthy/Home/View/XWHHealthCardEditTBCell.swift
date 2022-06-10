//
//  XWHHealthCardEditTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/10.
//

import UIKit

class XWHHealthCardEditTBCell: XWHCommonBaseTBCell {
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        
        set {
            var newFrame = newValue
            newFrame.size.height -= 13
            
            super.frame = newFrame
        }
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        backgroundColor = .clear
        
        layer.cornerRadius = 16
        layer.backgroundColor = contentBgColor.cgColor
        
        iconView.layer.cornerRadius = 17
        iconView.layer.backgroundColor = UIColor(hex: 0x49CE64)?.cgColor
        
        iconView.contentMode = .center
    }

    override func relayoutSubViews() {
        subIconView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
        
        subTitleLb.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(subIconView.snp.left)
        }
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.right.equalTo(subTitleLb.snp.left).offset(-6)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
    }

}
