//
//  XWHSleepWeekMonthYearChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/12.
//

import UIKit

class XWHSleepWeekMonthYearChartCTCell: XWHBarChartBaseCTCell {
    
    private(set) lazy var legendView = XWHChartLegendView()

    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(legendView)

        gradientColors = [UIColor(hex: 0xE5E6FF)!, UIColor(hex: 0xffffff)!]
//        textLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)
//        textLb.textColor = fontDarkColor
//        textLb.textAlignment = .left
//        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12)
//        detailLb.textColor = fontDarkColor.withAlphaComponent(0.5)
//        detailLb.textAlignment = .left
    }
    
    override func relayoutSubViews() {
        relayoutLegendAndTitleValueView()
    }
    
    final func relayoutLegendAndTitleValueView() {
        relayoutTitleValueView()
        
        legendView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
    }
    
    func update(legendTitles: [String], legendColors: [UIColor], dateText: String, sleepUIModel: XWHHealthySleepUISleepModel?) {
        textLb.text = R.string.xwhHealthyText.暂无数据()
        detailLb.text = ""
        legendView.isHidden = true
        
        guard let sleepUIModel = sleepUIModel else {
//            markerView.isHidden = true
            return
        }
        legendView.isHidden = false
        legendView.update(titles: legendTitles, colors: legendColors)
        
        textLb.text = XWHUIDisplayHandler.getSleepDurationString(sleepUIModel.totalSleepDuration)
        detailLb.text = dateText
    }
    
}
