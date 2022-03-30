//
//  XWHSearchDeviceTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/29.
//

import UIKit

class XWHSearchDeviceTBCell: XWHBaseTBCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        selectionStyle = .none
    }

    override func relayoutSubViews() {
        iconView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-28)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(28)
            make.right.equalTo(iconView.snp.left).offset(-6)
            make.centerY.equalToSuperview()
            make.height.equalTo(24)
        }
    }

}
