//
//  XWHDevSetCommonTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import UIKit

class XWHDevSetCommonTBCell: XWHComLineBaseTBCell {

    override func addSubViews() {
        super.addSubViews()
        
        iconView.isHidden = true
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
            make.left.equalToSuperview().offset(28)
            make.right.lessThanOrEqualTo(subTitleLb.snp.left).offset(-6)
        }
    }

}
