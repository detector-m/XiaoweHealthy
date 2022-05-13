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
            make.left.right.equalToSuperview()
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
    
    func update(legendTitles: [String], legendColors: [UIColor], dateText: String, sDate: Date, dateType: XWHHealthyDateSegmentType, sleepUIModel: XWHHealthySleepUISleepModel?) {
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
        
        let chartDataModel = XWHHealthyChartDataHandler.getSleepWeekMonthYearChartDataModel(date: sDate, dateType: dateType, sItems: sleepUIModel.items)
        
        chartView.xAxis.setLabelCount(chartDataModel.xLabelCount, force: false)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: chartDataModel.xAxisValues)
        
        
        chartView.rightAxis.axisMaximum = chartDataModel.max
        chartView.rightAxis.axisMinimum = chartDataModel.min
        chartView.rightAxis.granularity = chartDataModel.granularity
//        chartView.rightAxis.labelCount = 6
//        chartView.rightAxis.forceLabelsEnabled = true
        
        chartView.rightAxis.valueFormatter = DefaultAxisValueFormatter(block: { value, axis in
            let h = (value / 60).int
            if h == 0 {
                return ""
            }
            return h.string + "h"
        })
        
        chartView.data = getChartData(chartDataModel: chartDataModel)
    }
    
    private func getChartData(chartDataModel: XWHSleepWMYChartDataModel) -> BarChartData {
        var dataEntries: [BarChartDataEntry] = []
        for (i, iYValue) in chartDataModel.yValues.enumerated() {
            let entry = BarChartDataEntry(x: i.double, yValues: iYValue)

            dataEntries.append(entry)
        }
        
        let dataSet = BarChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = XWHUIDisplayHandler.getSleepStateColors()
        dataSet.axisDependency = .right
        dataSet.drawValuesEnabled = false
        
        let chartData = BarChartData(dataSet: dataSet)
//        chartData.barWidth = 0.8
//        chartData.groupBars(fromX: -0.5, groupSpace: 0.1, barSpace: 0.1)
        
        return chartData
    }
    
}
