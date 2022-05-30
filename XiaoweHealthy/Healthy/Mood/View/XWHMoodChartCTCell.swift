//
//  XWHMoodChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/20.
//

import UIKit

class XWHMoodChartCTCell: XWHColumnRangeBarChartBaseCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        gradientColors = [UIColor(hex: 0xFFE9B7)!, UIColor(hex: 0xffffff)!]
    }
    
    func update() {
        textLb.text = R.string.xwhHealthyText.暂无数据()
        detailLb.text = ""
    }
    
}
