//
//  XWHSportSettingsSwitchTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/25.
//

import UIKit

class XWHSportSettingsSwitchTBCell: XWHDevSetSwitchTBCell {

    override func addSubViews() {
        super.addSubViews()
        
        iconView.image = nil
        subIconView.image = nil
        
        subTitleLb.isHidden = true
    }
    
    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(22)
            make.height.equalTo(22)
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualTo(button.snp.left)
        }
        
        button.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }

}
