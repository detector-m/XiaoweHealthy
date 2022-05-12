//
//  XWHSleepChartBaseCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/12.
//

import UIKit

class XWHSleepChartBaseCTCell: XWHHealthyChartBaseCTCell {
    
    lazy var legendView = XWHChartLegendView()

    override func addSubViews() {
        super.addSubViews()
        
        isHorizontal = false
        gradientColors = [UIColor(hex: 0xE5E6FF)!, UIColor(hex: 0xffffff)!]
        
        contentView.addSubview(legendView)
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)
        textLb.textColor = fontDarkColor
        textLb.textAlignment = .left
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        detailLb.textAlignment = .left
    }

    final func relayoutLegendAndTitleValueView() {
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
        
        legendView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
    }
    
}
