//
//  XWHPersonInfoTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/7.
//

import UIKit

class XWHPersonInfoTBCell: XWHComLineBaseTBCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        bringLineViewToFront()
        
        iconView.layer.cornerRadius = 14
        iconView.layer.backgroundColor = UIColor(hex: 0x49CE64)?.cgColor
        
        iconView.contentMode = .center
        
        iconView.isHidden = true
        
        bottomLine.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        subTitleLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        subIconView.image = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 18, color: UIColor.black.withAlphaComponent(0.08))
        
        subTitleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
    }

    override func relayoutSubViews() {
        subIconView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        
        subTitleLb.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(subIconView.snp.left)
        }
        
//        iconView.snp.makeConstraints { make in
//            make.size.equalTo(28)
//            make.centerY.equalToSuperview()
//            make.left.equalToSuperview().offset(16)
//        }
        
        titleLb.snp.makeConstraints { make in
//            make.left.equalTo(iconView.snp.right).offset(12)
            make.left.equalToSuperview().offset(12)
            make.right.equalTo(subTitleLb.snp.left).offset(-6)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
        
        bottomLine.snp.makeConstraints { make in
            make.left.equalTo(titleLb)
            make.right.equalTo(subIconView)
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
    }

}
