//
//  XWHHeartChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/14.
//

import UIKit

class XWHHeartChartCTCell: XWHBarChartBaseCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        gradientColors = [UIColor(hex: 0xFFE0E2)!, UIColor(hex: 0xFFFFFF)!]
    }
    
    override func relayoutSubViews() {
        relayoutTitleValueView()
        
        chartView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview()
        }
    }
    
    func update(dateText: String, sDate: Date, dateType: XWHHealthyDateSegmentType) {
        textLb.text = R.string.xwhHealthyText.暂无数据()
        detailLb.text = ""
        
    }
    
}
