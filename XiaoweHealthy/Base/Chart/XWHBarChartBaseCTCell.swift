//
//  XWHBarChartBaseCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/13.
//

import UIKit

class XWHBarChartBaseCTCell: XWHGradientBaseCTCell {
    
    override func addSubViews() {
        super.addSubViews()
    
        isHorizontal = false
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)
        textLb.textColor = fontDarkColor
        textLb.textAlignment = .left
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        detailLb.textAlignment = .left
    }
    
    final func relayoutTitleValueView() {
        textLb.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(16)
        }
        detailLb.snp.makeConstraints { make in
            make.left.right.equalTo(textLb)
            make.top.equalTo(textLb.snp.bottom).offset(2)
            make.height.equalTo(16)
        }
    }
    
}
