//
//  XWHSleepWeekMonthYearChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/12.
//

import UIKit

class XWHSleepWeekMonthYearChartCTCell: XWHSleepChartBaseCTCell {
    
    override func addSubViews() {
        super.addSubViews()
    }
    
    override func relayoutSubViews() {
        relayoutLegendAndTitleValueView()
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
