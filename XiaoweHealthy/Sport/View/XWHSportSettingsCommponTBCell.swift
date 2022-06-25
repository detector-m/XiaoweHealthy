//
//  XWHSportSettingsCommponTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/25.
//

import UIKit

class XWHSportSettingsCommponTBCell: XWHDevSetCommonTBCell {

    override func addSubViews() {
        super.addSubViews()
        
        iconView.isHidden = true
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)
        subTitleLb.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        
        titleLb.textColor = fontDarkColor.withAlphaComponent(0.6)
        subTitleLb.textColor = fontDarkColor.withAlphaComponent(0.29)
    }
    
    override func relayoutSubViews() {
        relayoutTopBottomLine()
        
        subIconView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        subTitleLb.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(1)
            make.right.equalTo(subIconView.snp.left)
        }
        
        titleLb.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(1)
            make.left.equalToSuperview().offset(22)
            make.right.lessThanOrEqualTo(subTitleLb.snp.left).offset(-6)
        }
    }

}
