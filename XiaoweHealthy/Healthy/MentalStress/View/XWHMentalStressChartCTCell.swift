//
//  XWHMentalStressChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/17.
//

import UIKit
import Charts

class XWHMentalStressChartCTCell: XWHColumnRangeBarChartBaseCTCell {
    
    private weak var uiModel: XWHMentalStressUIStressModel?

    override func addSubViews() {
        super.addSubViews()
        
        gradientColors = [UIColor(hex: 0xD2F6FF)!, UIColor(hex: 0xffffff)!]
    }
    
    func update(dateText: String, sDate: Date, dateType: XWHHealthyDateSegmentType, uiModel: XWHMentalStressUIStressModel?) {
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
        
//        textLb.text = cUIModel.averageVal.string + XWHUIDisplayHandler.getMentalStressRangeString(cUIModel.averageVal)

        let unit = XWHUIDisplayHandler.getMentalStressRangeString(cUIModel.averageVal)
        let cValue = cUIModel.averageVal.string
        let cText = cValue + unit
        textLb.attributedText = cText.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 38, weight: .bold)], toOccurrencesOf: cValue).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)], toOccurrencesOf: unit)
        
        detailLb.text = dateText
        
        let chartDataModel = XWHHealthyChartDataHandler.getMentalStressChartDataModel(date: sDate, dateType: dateType, rawItems: cUIModel.items)
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
                return value.int.string
            }
        })
        
        chartView.data = getChartData(chartDataModel: chartDataModel)
    }
    
    override func getChartData(chartDataModel: XWHChartDataBaseModel) -> ColumnRangeBarChartData {
        let chartDataSet = getChartDataSet(values: chartDataModel.yValues)
        chartDataSet.colors = [UIColor(hex: 0x76D4EA)!]
        chartDataSet.segmentLimits = [29, 59, 79]
        chartDataSet.segmentColors = [UIColor(hex: 0x49CE64)!, UIColor(hex: 0x76D4EA)!, UIColor(hex: 0xF0B36D)!, UIColor(hex: 0xED7135)!]
        
        let chartData = ColumnRangeBarChartData(dataSets: [chartDataSet])
        return chartData
    }
    
    override func showMarker(with rawValue: Any) {
        guard let iItem = rawValue as? XWHChartUIChartItemModel else {
            chartView.highlightValue(nil)
            return
        }
        
        if iItem.lowest < iItem.highest {
            markerView.textLb.text = "\(iItem.lowest) - \(iItem.highest)"
        } else {
            markerView.textLb.text = "\(iItem.highest)"
        }
        
        let iDate = iItem.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat) ?? Date()
        markerView.detailLb.text = getMarkerDateString(iDate: iDate, dateType: sDateType) + " " + R.string.xwhHealthyText.压力范围()
    }
    
}
