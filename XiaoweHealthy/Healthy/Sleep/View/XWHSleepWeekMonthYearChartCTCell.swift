//
//  XWHSleepWeekMonthYearChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/12.
//

import UIKit
import Charts

class XWHSleepWeekMonthYearChartCTCell: XWHBarChartBaseCTCell {
    
    private(set) lazy var legendView = XWHChartLegendView()

    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(legendView)

        gradientColors = [UIColor(hex: 0xE5E6FF)!, UIColor(hex: 0xffffff)!]
    }
    
    override func relayoutSubViews() {
        relayoutLegendAndTitleValueView()
        
        chartView.snp.makeConstraints { make in
            make.left.right.equalTo(legendView)
            make.top.equalTo(detailLb.snp.bottom)
            make.bottom.equalTo(legendView.snp.top)
        }
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
        
        chartView.data = getChartData(sleepUIModel: sleepUIModel)
    }
    
    private func getChartData(sleepUIModel: XWHHealthySleepUISleepModel) -> BarChartData {
        var dataEntries: [BarChartDataEntry] = []
        for (i, iItem) in sleepUIModel.items.enumerated() {
            let entry = BarChartDataEntry(x: i.double, yValues: [iItem.deepSleepDuration.double, iItem.lightSleepDuration.double, iItem.awakeDuration.double,])
            dataEntries.append(entry)
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = XWHUIDisplayHandler.getSleepStateColors()
        dataSet.axisDependency = .right
        dataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: dataSet)
//        chartData.barWidth = 0.8
        
        return chartData
    }
    
}
