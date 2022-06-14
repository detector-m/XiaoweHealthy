//
//  XWHActivityChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/14.
//

import UIKit
import Charts

class XWHActivityChartCTCell: XWHRoundedCornersBarChartBaseCTCell {
    
    private var titleColor: UIColor {
        return fontDarkColor.withAlphaComponent(0.4)
    }
    private var titleFont: UIFont {
        XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
    }
    private var unitFont: UIFont {
        XWHFont.harmonyOSSans(ofSize: 16, weight: .regular)
    }
    private var valueFont: UIFont {
        XWHFont.harmonyOSSans(ofSize: 38, weight: .bold)
    }
    
    private var markerValueFont: UIFont {
        XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)
    }
    private var markerUnitFont: UIFont {
        XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
    }
    
    private var stepColor: UIColor {
        UIColor(hex: 0x3EDE69)!
    }

    private var calColor: UIColor {
        UIColor(hex: 0xFFCA4F)!
    }
    
    private var distanceColor: UIColor {
        UIColor(hex: 0x6FA9FF)!
    }

    private lazy var atType: XWHActivityType = .step
    
    override func addSubViews() {
        super.addSubViews()
        
        layer.cornerRadius = 16
        layer.backgroundColor = UIColor.white.cgColor
    }
    
    func update(activityType: XWHActivityType) {
        atType = activityType
        
        var rawItems: [XWHChartUIChartItemModel] = []

        let sDate = Date()
        
        detailLb.text = sDate.string(withFormat: XWHDate.monthDayFormat)
        
        let sEDate = sDate.dayBegin
        for i in 0 ..< 24 {
            let item = XWHChartUIChartItemModel()
            
            item.lowest = Int(arc4random() % 51) + 40
            item.highest = item.lowest + Int(arc4random() % 51)
            
            let iDate = sEDate.adding(.hour, value: i)
            item.timeAxis = iDate.string(withFormat: XWHDate.standardTimeAllFormat)
            
            rawItems.append(item)
        }
        
        let chartDataModel = XWHHealthyChartDataHandler.getHeartChartDataModel(date: sDate, dateType: .day, rawItems: rawItems)
        self.chartDataModel = chartDataModel
        
        chartView.rightAxis.axisMaximum = chartDataModel.max
        chartView.rightAxis.axisMinimum = chartDataModel.min
        chartView.rightAxis.granularity = chartDataModel.granularity
        
        chartView.leftAxis.axisMaximum = chartDataModel.max
        chartView.leftAxis.axisMinimum = chartDataModel.min
        chartView.leftAxis.granularity = chartDataModel.granularity
        
        var valueString = ""
        var targetString = ""
        var text = ""
        
        if activityType == .step {
            let stepValue = 1000
            valueString = stepValue.string
            targetString = R.string.xwhHealthyText.步()
            text = valueString + targetString
            
            textLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: valueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: unitFont, .foregroundColor: fontDarkColor], toOccurrencesOf: targetString)
            
            detailLb.text = "目标步数8000步"

            chartView.data = getStepChartData(chartDataModel: chartDataModel)
        } else if activityType == .cal {
            valueString = 100.string
            targetString = R.string.xwhHealthyText.千卡()
            text = valueString + targetString
            textLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: valueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: unitFont, .foregroundColor: fontDarkColor], toOccurrencesOf: targetString)
            
            detailLb.text = "目标消耗100千卡"
            
            chartView.data = getCalChartData(chartDataModel: chartDataModel)
        } else {
            valueString = 3.33.string
            targetString = R.string.xwhHealthyText.公里()
            text = valueString + targetString
            textLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: valueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: unitFont, .foregroundColor: fontDarkColor], toOccurrencesOf: targetString)
            
            detailLb.text = "目标距离5公里"
            
            chartView.data = getDistanceChartData(chartDataModel: chartDataModel)
        }
    }
    
    func getStepChartData(chartDataModel: XWHChartDataBaseModel) -> BarChartData {
        let chartDataSet = getChartDataSet(values: chartDataModel.yValues)
        chartDataSet.colors = [UIColor(hex: 0x6CD267)!]
        let chartData = BarChartData(dataSets: [chartDataSet])
        return chartData
    }
    
    func getCalChartData(chartDataModel: XWHChartDataBaseModel) -> BarChartData {
        let chartDataSet = getChartDataSet(values: chartDataModel.yValues)
        chartDataSet.colors = [UIColor(hex: 0xFFB25A)!]
        let chartData = BarChartData(dataSets: [chartDataSet])
        return chartData
    }
    
    func getDistanceChartData(chartDataModel: XWHChartDataBaseModel) -> BarChartData {
        let chartDataSet = getChartDataSet(values: chartDataModel.yValues)
        chartDataSet.colors = [UIColor(hex: 0x5A94EB)!]
        let chartData = BarChartData(dataSets: [chartDataSet])
        return chartData
    }
    
    func getChartDataSet(values: [Any]) -> RoundedCornersBarChartDataSet {
        var dataEntries: [BarChartDataEntry] = []
//        let yValues: [Double] = values as? [Double] ?? []
//        
//        for (i, iYValue) in yValues.enumerated() {
//            let entry = BarChartDataEntry(x: i.double, y: iYValue)
//            dataEntries.append(entry)
//        }
        
        let yValues: [[Double]] = values as? [[Double]] ?? []
        
        for (i, iYValue) in yValues.enumerated() {
            let high = iYValue[1]
//            let low = iYValue[0]
            let entry = BarChartDataEntry(x: i.double, y: high)
            dataEntries.append(entry)
        }
        
        
        let chartDataSet = RoundedCornersBarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.roundedCorners = [.topLeft, .topRight]
        chartDataSet.colors = [UIColor(hex: 0xEB5763)!]
        chartDataSet.drawValuesEnabled = false
        
        return chartDataSet
    }
    
    override func showMarker(with rawValue: Any) {
        guard let iItem = rawValue as? XWHChartUIChartItemModel else {
            chartView.highlightValue(nil)
            return
        }
        
        var valueString = ""
        var targetString = ""
        var text = ""
        
        if atType == .step {
            let stepValue = iItem.highest
            valueString = stepValue.string
            targetString = R.string.xwhHealthyText.步()
            text = valueString + targetString
            
            markerView.textLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: markerValueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: markerUnitFont, .foregroundColor: fontDarkColor], toOccurrencesOf: targetString)
        } else if atType == .cal {
            valueString = iItem.highest.string
            targetString = R.string.xwhHealthyText.千卡()
            text = valueString + targetString
            
            markerView.textLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: markerValueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: markerUnitFont, .foregroundColor: fontDarkColor], toOccurrencesOf: targetString)
        } else {
            valueString = iItem.highest.string
            targetString = R.string.xwhHealthyText.公里()
            text = valueString + targetString
            
            markerView.textLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: markerValueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: markerUnitFont, .foregroundColor: fontDarkColor], toOccurrencesOf: targetString)
        }
        
        let iDate = iItem.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat) ?? Date()
        markerView.detailLb.text = getMarkerDateString(iDate: iDate, dateType: .day)
    }
    
    
}
