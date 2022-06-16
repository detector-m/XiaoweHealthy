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
    
    override func configYAxis() {
        super.configYAxis()
        
        chartView.leftAxis.labelCount = 5
        chartView.rightAxis.labelCount = 5
        chartView.leftAxis.forceLabelsEnabled = true
        chartView.rightAxis.forceLabelsEnabled = true
    }
    
    func update(activityType: XWHActivityType, atSumUIModel: XWHActivitySumUIModel?) {
        atType = activityType
        
        let sDate = atSumUIModel?.collectDate.date(withFormat: XWHDate.standardYearMonthDayFormat) ?? Date()
        var valueString = ""
        var targetString = ""
        var text = ""
        
        if activityType == .step {
            let stepValue = atSumUIModel?.totalSteps ?? 0
            valueString = stepValue.string
            targetString = R.string.xwhHealthyText.步()
            text = valueString + targetString
            
            textLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: valueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: unitFont, .foregroundColor: fontDarkColor], toOccurrencesOf: targetString)
            
            detailLb.text = "目标步数\(atSumUIModel?.stepGoal ?? 8000)步"
            
            let chartDataModel = XWHHealthyChartDataHandler.getActivityChartDataModel(date: sDate, activityType: .step, rawItems: atSumUIModel?.steps ?? [])
            self.chartDataModel = chartDataModel
            
            chartView.rightAxis.axisMaximum = chartDataModel.max
            chartView.rightAxis.axisMinimum = chartDataModel.min
            chartView.rightAxis.granularity = chartDataModel.granularity
            
            chartView.leftAxis.axisMaximum = chartDataModel.max
            chartView.leftAxis.axisMinimum = chartDataModel.min
            chartView.leftAxis.granularity = chartDataModel.granularity

            chartView.data = getStepChartData(chartDataModel: chartDataModel)
        } else if activityType == .cal {
            let value = atSumUIModel?.totalCalories ?? 0
            valueString = value.string
            targetString = R.string.xwhHealthyText.千卡()
            text = valueString + targetString
            textLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: valueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: unitFont, .foregroundColor: fontDarkColor], toOccurrencesOf: targetString)
            
            detailLb.text = "目标消耗\(atSumUIModel?.caloriesGoal ?? 300)千卡"
            
            let chartDataModel = XWHHealthyChartDataHandler.getActivityChartDataModel(date: sDate, activityType: .cal, rawItems: atSumUIModel?.calories ?? [])
            self.chartDataModel = chartDataModel
            
            chartView.rightAxis.axisMaximum = chartDataModel.max
            chartView.rightAxis.axisMinimum = chartDataModel.min
            chartView.rightAxis.granularity = chartDataModel.granularity
            
            chartView.leftAxis.axisMaximum = chartDataModel.max
            chartView.leftAxis.axisMinimum = chartDataModel.min
            chartView.leftAxis.granularity = chartDataModel.granularity
            
            chartView.data = getCalChartData(chartDataModel: chartDataModel)
        } else {
            let value = atSumUIModel?.totalDistance ?? 0
            let kmValue = UnitHandler.getKm(m: value)

            valueString = kmValue.string
            targetString = R.string.xwhHealthyText.公里()
            text = valueString + targetString
            textLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: valueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: unitFont, .foregroundColor: fontDarkColor], toOccurrencesOf: targetString)
            
            let distanceGoal = (atSumUIModel?.distanceGoal ?? 3000) / 1000
            detailLb.text = "目标距离\(distanceGoal)公里"
            
            let chartDataModel = XWHHealthyChartDataHandler.getActivityChartDataModel(date: sDate, activityType: .distance, rawItems: atSumUIModel?.distance ?? [])
            self.chartDataModel = chartDataModel
            
            chartView.rightAxis.axisMaximum = chartDataModel.max
            chartView.rightAxis.axisMinimum = chartDataModel.min
            chartView.rightAxis.granularity = chartDataModel.granularity
            
            chartView.leftAxis.axisMaximum = chartDataModel.max
            chartView.leftAxis.axisMinimum = chartDataModel.min
            chartView.leftAxis.granularity = chartDataModel.granularity
            
            chartView.rightAxis.valueFormatter = DefaultAxisValueFormatter(block: { value, axis in
                let kmValue = UnitHandler.getKm(m: value.int)
                return kmValue.string
            })
            
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
        
        let yValues: [Double] = values as? [Double] ?? []
        
        for (i, iYValue) in yValues.enumerated() {
            let entry = BarChartDataEntry(x: i.double, y: iYValue)
            dataEntries.append(entry)
        }
        
        
        let chartDataSet = RoundedCornersBarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.roundedCorners = [.topLeft, .topRight]
        chartDataSet.colors = [UIColor(hex: 0xEB5763)!]
        chartDataSet.drawValuesEnabled = false
        
        return chartDataSet
    }
    
    override func showMarker(with rawValue: Any) {
        guard let iItem = rawValue as? XWHActivityItemUIModel else {
            chartView.highlightValue(nil)
            return
        }
        
        var valueString = ""
        var targetString = ""
        var text = ""
        
        if atType == .step {
            let stepValue = iItem.value
            valueString = stepValue.string
            targetString = R.string.xwhHealthyText.步()
            text = valueString + targetString
            
            markerView.textLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: markerValueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: markerUnitFont, .foregroundColor: fontDarkColor], toOccurrencesOf: targetString)
        } else if atType == .cal {
            valueString = iItem.value.string
            targetString = R.string.xwhHealthyText.千卡()
            text = valueString + targetString
            
            markerView.textLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: markerValueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: markerUnitFont, .foregroundColor: fontDarkColor], toOccurrencesOf: targetString)
        } else {
            let kmValue = UnitHandler.getKm(m: iItem.value)
            valueString = kmValue.string
            targetString = R.string.xwhHealthyText.公里()
            text = valueString + targetString
            
            markerView.textLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: markerValueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: markerUnitFont, .foregroundColor: fontDarkColor], toOccurrencesOf: targetString)
        }
        
        let iDate = iItem.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat) ?? Date()
        markerView.detailLb.text = getMarkerDateString(iDate: iDate, dateType: .day)
    }
    
    
}
