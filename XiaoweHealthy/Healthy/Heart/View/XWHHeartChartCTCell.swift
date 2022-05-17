//
//  XWHHeartChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/14.
//

import UIKit
import Charts

class XWHHeartChartCTCell: XWHColumnRangeBarChartBaseCTCell {
    
    private weak var uiModel: XWHHeartUIHeartModel?

    override func addSubViews() {
        super.addSubViews()
        
        gradientColors = [UIColor(hex: 0xFFE0E2)!, UIColor(hex: 0xFFFFFF)!]
    }
    
    func update(dateText: String, sDate: Date, dateType: XWHHealthyDateSegmentType, uiModel: XWHHeartUIHeartModel?) {
        textLb.text = R.string.xwhHealthyText.暂无数据()
        detailLb.text = ""
        
        sDateType = dateType
        
        chartView.highlightValue(nil)
        guard let cUIModel = uiModel else {
            self.chartDataModel = nil
            self.uiModel = nil
            chartView.data = nil
            
            return
        }
        
        self.uiModel = cUIModel
        
        textLb.text = cUIModel.avgRate.string
        detailLb.text = dateText
        
        let chartDataModel = XWHHealthyChartDataHandler.getHeartChartDataModel(date: sDate, dateType: dateType, rawItems: cUIModel.items)
        self.chartDataModel = chartDataModel
        
        chartView.xAxis.setLabelCount(chartDataModel.xLabelCount, force: false)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: chartDataModel.xAxisValues)
        
        chartView.rightAxis.axisMaximum = chartDataModel.max
        chartView.rightAxis.axisMinimum = chartDataModel.min
        chartView.rightAxis.granularity = chartDataModel.granularity
        
        chartView.data = getChartData(chartDataModel: chartDataModel)
    }
    
    override func getChartData(chartDataModel: XWHChartDataBaseModel) -> ColumnRangeBarChartData {
        let chartDataSet = getChartDataSet(values: chartDataModel.yValues)
        chartDataSet.colors = [UIColor(hex: 0xEB5763)!]
        
        let chartData = ColumnRangeBarChartData(dataSets: [chartDataSet])
        return chartData
    }
    
//    override func showMarker(with rawValue: Any) {
//        guard let iItem = rawValue as? XWHChartUIChartItemModel else {
//            chartView.highlightValue(nil)
//            return
//        }
//
//        markerView.textLb.text = "\(iItem.lowest) - \(iItem.highest) \(R.string.xwhDeviceText.次分钟())"
//
//        let iDate = iItem.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat) ?? Date()
//        markerView.detailLb.text = getMarkerDateString(iDate: iDate, dateType: sDateType)
//    }
    
}
