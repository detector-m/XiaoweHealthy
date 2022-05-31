//
//  XWHMoodChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/20.
//

import UIKit

class XWHMoodChartCTCell: XWHColumnRangeBarChartBaseCTCell {
    
    private(set) lazy var legendView = XWHChartLegendView()

    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(legendView)
        
        gradientColors = [UIColor(hex: 0xFFE9B7)!, UIColor(hex: 0xffffff)!]
    }
    
    override func relayoutSubViews() {
        relayoutTitleValueView()
        
        legendView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        chartView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.bottom.equalTo(legendView.snp.top)
        }
    }
    
    func update() {
        textLb.text = R.string.xwhHealthyText.暂无数据()
        detailLb.text = ""
        
        legendView.update(titles: XWHUIDisplayHandler.getMoodRangeStrings(), colors: XWHUIDisplayHandler.getMoodRangeColors())
    }
    
}
