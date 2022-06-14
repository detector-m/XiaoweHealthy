//
//  XWHActivitySetGoalTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/14.
//

import UIKit

class XWHActivitySetGoalTBCell: XWHCommonBaseTBCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        backgroundColor = contentBgColor
        layer.cornerRadius = 16
        layer.backgroundColor = contentBgColor.cgColor
        
        iconView.isHidden = true
        
        subTitleLb.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        subTitleLb.textColor = fontDarkColor.withAlphaComponent(0.3)
        subTitleLb.textAlignment = .right
        
        titleLb.textAlignment = .left
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        titleLb.textColor = fontDarkColor
        
        subIconView.image = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 18, color: fontDarkColor.withAlphaComponent(0.3))
    }
    
    override func relayoutSubViews() {
        titleLb.snp.remakeConstraints { make in
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(22)
            make.width.equalTo(126)
        }
        
        subIconView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        subTitleLb.snp.remakeConstraints { make in
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(subIconView.snp.left)
            make.left.equalTo(titleLb.snp.right).offset(4)
        }
    }
    
}
