//
//  XWHHealthyDataDetailCommonTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

class XWHHealthyDataDetailCommonTBCell: XWHHealthyDataDetailTBCell {

    override func addSubViews() {
        super.addSubViews()
        
        subIconView.isHidden = true
        let textColor = fontDarkColor.withAlphaComponent(0.5)
        titleLb.textColor = textColor
        subTitleLb.textColor = fontDarkColor
        subTitleLb.font = XWHFont.harmonyOSSans(ofSize: 16)
        
        subIconView.isHidden = true
        iconView.isHidden = false
        iconView.image = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 22, color: textColor)
    }
    
    override func relayoutSubViews() {
        iconView.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        subTitleLb.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.right.equalTo(iconView.snp.left)
            make.left.greaterThanOrEqualTo(titleLb.snp.right).offset(4)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
//            make.width.equalTo(126)
            make.width.lessThanOrEqualTo(126)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
        }
        
        bottomLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    

}
