//
//  XWHMeProfileTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/7.
//

import UIKit

class XWHMeProfileTBCell: XWHCommonBaseTBCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        iconView.layer.cornerRadius = 25
        iconView.contentMode = .scaleAspectFit
        iconView.layer.masksToBounds = true
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 18, weight: .medium)
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
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(52)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.right.equalTo(subTitleLb.snp.left).offset(-6)
            make.centerY.equalToSuperview()
            make.height.equalTo(22)
        }
    }

}
