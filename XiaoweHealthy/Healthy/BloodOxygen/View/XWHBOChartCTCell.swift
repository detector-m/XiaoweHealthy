//
//  XWHBOChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/17.
//

import UIKit
import Charts

class XWHBOChartCTCell: XWHColumnRangeBarChartBaseCTCell {
    
    private weak var uiModel: XWHBOUIBloodOxygenModel?

    override func addSubViews() {
        super.addSubViews()
        
        gradientColors = [UIColor(hex: 0xDCFDD9)!, UIColor(hex: 0xffffff)!]
    }
    
    func update(dateText: String, sDate: Date, dateType: XWHHealthyDateSegmentType, uiModel: XWHBOUIBloodOxygenModel?) {
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
        
        textLb.text = cUIModel.avgBloodOxygen.string
        detailLb.text = dateText
        
        let chartDataModel = XWHHealthyChartDataHandler.getBOChartDataModel(date: sDate, dateType: dateType, rawItems: cUIModel.items)
        self.chartDataModel = chartDataModel
        
        chartView.xAxis.setLabelCount(chartDataModel.xLabelCount, force: false)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: chartDataModel.xAxisValues)
        
        chartView.rightAxis.axisMaximum = chartDataModel.max
        chartView.rightAxis.axisMinimum = chartDataModel.min
        chartView.rightAxis.granularity = chartDataModel.granularity
        
        chartView.leftAxis.axisMaximum = chartDataModel.max
        chartView.leftAxis.axisMinimum = chartDataModel.min
        chartView.leftAxis.granularity = chartDataModel.granularity
        
        chartView.rightAxis.valueFormatter = DefaultAxisValueFormatter(block: { value, axis in
            if value == chartDataModel.min {
                return ""
            } else {
                return value.int.string + "%"
            }
        })
        
        chartView.data = getChartData(chartDataModel: chartDataModel)
    }
    
    override func getChartData(chartDataModel: XWHChartDataBaseModel) -> ColumnRangeBarChartData {
        let chartDataSet = getChartDataSet(values: chartDataModel.yValues)
        chartDataSet.colors = [UIColor(hex: 0x6CD267)!]
        chartDataSet.segmentLimits = [90]
        chartDataSet.segmentColors = [UIColor(hex: 0xF0B36D)!, UIColor(hex: 0x6CD267)!]
        
        let chartData = ColumnRangeBarChartData(dataSets: [chartDataSet])
        return chartData
    }
    
    override func showMarker(with rawValue: Any) {
        guard let iItem = rawValue as? XWHChartUIChartItemModel else {
            chartView.highlightValue(nil)
            return
        }
        
        if iItem.lowest < iItem.highest {
            markerView.textLb.text = "\(iItem.lowest) - \(iItem.highest)%"
        } else {
            markerView.textLb.text = "\(iItem.highest)%"
        }
        
        let iDate = iItem.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat) ?? Date()
        markerView.detailLb.text = getMarkerDateString(iDate: iDate, dateType: sDateType)
    }
    
}
