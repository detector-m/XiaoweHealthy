//
//  XWHMoodChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/20.
//

import UIKit
import Charts

class XWHMoodChartCTCell: XWHColumnRangeBarChartBaseCTCell {
    
    private(set) lazy var legendView = XWHChartLegendView()
    
    private weak var uiModel: XWHMentalStressUIStressModel?

    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(legendView)
        
        gradientColors = [UIColor(hex: 0xFFE9B7)!, UIColor(hex: 0xffffff)!]
    }
    
    override func relayoutSubViews() {
        relayoutTitleValueView()
        
        legendView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(11)
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        }
        
        chartView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.bottom.equalTo(legendView.snp.top)
        }
    }
    
    func update(dateText: String, sDate: Date, dateType: XWHHealthyDateSegmentType, uiModel: XWHMentalStressUIStressModel?) {
        textLb.text = R.string.xwhHealthyText.暂无数据()
        detailLb.text = ""
        
        sDateType = dateType
        
        legendView.isHidden = false
        
        chartView.highlightValue(nil)
        guard let cUIModel = uiModel else {
            legendView.isHidden = true

            self.chartDataModel = nil
            self.uiModel = nil
            chartView.data = nil
            
            return
        }
        
        legendView.update(titles: XWHUIDisplayHandler.getMoodRangeStrings(), colors: XWHUIDisplayHandler.getMoodRangeColors())

        self.uiModel = cUIModel
        
//        textLb.text = cUIModel.averageVal.string + XWHUIDisplayHandler.getMentalStressRangeString(cUIModel.averageVal)

        let unit = ""
        let cValue = XWHUIDisplayHandler.getMoodString(0)
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
            return ""
        })
        
        chartView.data = getChartData(chartDataModel: chartDataModel)
    }
    
    override func getChartData(chartDataModel: XWHChartDataBaseModel) -> ColumnRangeBarChartData {
        let chartDataSet = getChartDataSet(chartDataModel: chartDataModel)
        chartDataSet.colors = [UIColor(hex: 0xFFD978)!]
        let chartData = ColumnRangeBarChartData(dataSets: [chartDataSet])
        return chartData
    }
    
    private func getChartDataSet(chartDataModel: XWHChartDataBaseModel) -> ColumnRangeBarChartDataSet {
        var segmentLimits: [Double] = []
        let segmentColors = [UIColor](XWHUIDisplayHandler.getMoodRangeColors().reversed())
        
        var dataEntries: [ColumnRangeBarChartDataEntry] = []
        let yValues: [[Double]] = chartDataModel.yValues as? [[Double]] ?? []

        for (i, iYValue) in yValues.enumerated() {
            let tLimit = 50
            
//            let high = iYValue[1]
//            let low = iYValue[0]
            
            let high = (tLimit + (Int(arc4random()) % 50) + 1).double
            let low = (tLimit - (Int(arc4random()) % 50) + 1).double
            
            let entry = ColumnRangeBarChartDataEntry(x: i.double, low: low, high: high)
            dataEntries.append(entry)
            
            if let iRawValue = chartDataModel.rawValues[i] {
                var result = ((high - low) / 2).int - 1
                if result <= 0 {
                    result = 1
                }
                let l1 = low + ((Int(arc4random())) % result).double
                let l2 = high - ((Int(arc4random())) % result).double
                
                segmentLimits = [l1, l2]
                entry.segmentLimits = segmentLimits
                entry.segmentColors = segmentColors
            } else {
                
            }
        }
        
        let chartDataSet = ColumnRangeBarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.roundedCorners = .allCorners
        chartDataSet.increasingFilled = true
        chartDataSet.colors = [UIColor(hex: 0xFFD978)!]
        chartDataSet.shadowWidth = 0
        chartDataSet.drawValuesEnabled = false
        chartDataSet.setDrawHighlightIndicators(false)
        
        chartDataSet.segmentLimits = []
        chartDataSet.segmentColors = []
        
        return chartDataSet
    }
    
    override func configMarkerView() {
        super.configMarkerView()
        
        markerView.frame = CGRect(x: 0, y: 0, width: 200, height: 120)
    }
    
    override func showMarker(with rawValue: Any) {
        guard let iItem = rawValue as? XWHChartUIChartItemModel else {
            chartView.highlightValue(nil)
            return
        }
        
//        if iItem.lowest < iItem.highest {
//            markerView.textLb.text = "\(iItem.lowest) - \(iItem.highest) \(R.string.xwhDeviceText.次分钟())"
//        } else {
//            markerView.textLb.text = "\(iItem.highest) \(R.string.xwhDeviceText.次分钟())"
//        }
        
        let iDate = iItem.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat) ?? Date()
        markerView.textLb.text = getMarkerDateString(iDate: iDate.hourBegin, dateType: sDateType)
        
//        markerView.detailLb.text = getMarkerDateString(iDate: iDate.hourBegin, dateType: sDateType)
        let moodStrings = XWHUIDisplayHandler.getMoodRangeStrings()
        markerView.detailLb.text = "\(moodStrings[0])\(2)%, \(moodStrings[1])\(2)%, \(moodStrings[2])\(2)%"
    }
    
}
