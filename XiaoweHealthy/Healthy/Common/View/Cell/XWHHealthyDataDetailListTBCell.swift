//
//  XWHHealthyDataDetailListTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

class XWHHealthyDataDetailListTBCell: XWHCommonBaseTBCell {

    override func addSubViews() {
        super.addSubViews()
        
        titleLb.textColor = fontDarkColor
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        
        subTitleLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        
        subIconView.isHidden = true
        iconView.isHidden = false
        iconView.image = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 22, color: fontDarkColor.withAlphaComponent(0.5))
    }
    
    override func relayoutSubViews() {
        iconView.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
        }
        
        titleLb.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(126)
        }
        
        subTitleLb.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(titleLb.snp.right).offset(4)
            make.right.equalTo(iconView.snp.left)
            make.top.bottom.equalTo(titleLb)
        }
    }
    
}
