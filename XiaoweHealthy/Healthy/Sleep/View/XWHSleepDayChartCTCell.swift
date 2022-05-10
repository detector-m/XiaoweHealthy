//
//  XWHSleepDayChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/10.
//

import UIKit

class XWHSleepDayChartCTCell: XWHHealthyChartBaseCTCell {
    
    lazy var legendView = XWHChartLegendView()
    
    override func addSubViews() {
        super.addSubViews()
        
        isHorizontal = false
        gradientColors = [UIColor(hex: 0xE5E6FF)!, UIColor(hex: 0xffffff)!]
        
        contentView.addSubview(legendView)
    }
    
    override func relayoutSubViews() {
        legendView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func update(legendTitles: [String], legendColors: [UIColor]) {
        legendView.update(titles: legendTitles, colors: legendColors)
    }
    
}
