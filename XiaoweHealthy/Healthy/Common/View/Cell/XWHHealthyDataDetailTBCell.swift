//
//  XWHHealthyDataDetailTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import UIKit

class XWHHealthyDataDetailTBCell: XWHComLineBaseTBCell {

    override func addSubViews() {
        super.addSubViews()
        
        titleLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 16)
        
        subTitleLb.textColor = fontDarkColor
        subTitleLb.font = XWHFont.harmonyOSSans(ofSize: 16)
        
        subIconView.isHidden = true
        iconView.isHidden = true
        
        bottomLine.backgroundColor = UIColor.black.withAlphaComponent(0.08)
        
        contentView.bringSubviewToFront(bottomLine)
    }
    
    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(2)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(126)
        }
        
        subTitleLb.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(titleLb.snp.right).offset(4)
            make.right.equalToSuperview().offset(-16)
            make.top.bottom.equalTo(titleLb)
        }
        
        bottomLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }

}
