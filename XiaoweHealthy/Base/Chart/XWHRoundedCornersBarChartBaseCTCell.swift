//
//  XWHRoundedCornersBarChartBaseCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/14.
//

import UIKit
import Charts

class XWHRoundedCornersBarChartBaseCTCell: XWHChartBaseCTCell {
    
    private(set) lazy var chartView = RoundedCornersBarChartView()
    
    override func addSubViews() {
        super.addSubViews()
        
        gradientLayer.isHidden = true
        
        contentView.addSubview(chartView)
        
        configChartViewCommon()
        configXAxis()
        configYAxis()
        configMarkerView()
    }
    
    override func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.height.equalTo(51)
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(12)
        }
        detailLb.snp.makeConstraints { make in
            make.left.right.equalTo(textLb)
            make.top.equalTo(textLb.snp.bottom).offset(0)
            make.height.equalTo(16)
        }
        
        chartView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func getMarkerDateString(iDate: Date, dateType: XWHHealthyDateSegmentType) -> String {
        var retStr = ""
        if dateType == .day {
//            retStr = iDate.localizedString(withFormat: XWHDate.monthDayHourMinute)
            let bDate = iDate.hourBegin
            let eDate = bDate.adding(.hour, value: 1)
            retStr = bDate.string(withFormat: XWHDate.hourMinuteFormat) + "-" + eDate.string(withFormat: XWHDate.hourMinuteFormat)
        } else if dateType == .week || dateType == .month {
            retStr = iDate.localizedString(withFormat: XWHDate.yearMonthDayFormat)
        } else if dateType == .year {
            let ybDate = iDate.monthBegin
            retStr = ybDate.localizedString(withFormat: XWHDate.monthFormat)
        }
        
        return retStr
    }
    
    func showMarker(with rawValue: Any) {
        guard let iItem = rawValue as? XWHChartUIChartItemModel else {
            chartView.highlightValue(nil)
            return
        }
        
        if iItem.lowest < iItem.highest {
            markerView.textLb.text = "\(iItem.lowest) - \(iItem.highest) \(R.string.xwhDeviceText.次分钟())"
        } else {
            markerView.textLb.text = "\(iItem.highest) \(R.string.xwhDeviceText.次分钟())"
        }
        
        let iDate = iItem.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat) ?? Date()
        markerView.detailLb.text = getMarkerDateString(iDate: iDate.hourBegin, dateType: sDateType)
    }
    
}

extension XWHRoundedCornersBarChartBaseCTCell {
    
    @objc func configChartViewCommon() {
        chartView.backgroundColor = .clear

        chartView.delegate = self
        chartView.noDataText = ""
        chartView.legend.enabled = false
        
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.doubleTapToZoomEnabled = false
        
        // 拖动效果高亮
        chartView.dragEnabled = true
        
        chartView.gridBackgroundColor = .clear
        
        chartView.minOffset = 12
        chartView.extraTopOffset = 91
    }
    
    @objc func configXAxis() {
        chartView.xAxis.labelPosition = .bottom
        
        chartView.xAxis.axisMaxLabels = 32
        
//        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.granularity = 1
//        chartView.xAxis.axisMaximum = 7
        
//        chartView.xAxis.labelCount = 7
//        chartView.xAxis.forceLabelsEnabled = true
//        chartView.xAxis.granularityEnabled = true
        
        chartView.xAxis.axisLineWidth = 0.5
        chartView.xAxis.axisLineColor = UIColor.black.withAlphaComponent(0.05)
        
//        chartView.xAxis.gridLineWidth = 0.5
//        chartView.xAxis.gridColor = UIColor.black.withAlphaComponent(0.05)
        chartView.xAxis.drawGridLinesEnabled = false
        
        chartView.xAxis.labelFont = XWHFont.harmonyOSSans(ofSize: 10)
        chartView.xAxis.labelTextColor = fontDarkColor.withAlphaComponent(0.35)
    }
    
    @objc func configYAxis() {
//        chartView.leftAxis.enabled = false
        
        chartView.leftAxis.axisMinimum = 0

        chartView.leftAxis.axisLineColor = UIColor.black.withAlphaComponent(0.05)
        chartView.leftAxis.axisLineWidth = 0.5
        
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        
        chartView.rightAxis.axisMinimum = 0
        
        chartView.rightAxis.axisLineColor = UIColor.black.withAlphaComponent(0.05)
        chartView.rightAxis.axisLineWidth = 0.5
        
        chartView.rightAxis.gridLineWidth = 0.5
        chartView.rightAxis.gridColor = UIColor.black.withAlphaComponent(0.05)
        
        chartView.rightAxis.labelFont = XWHFont.harmonyOSSans(ofSize: 10)
        chartView.rightAxis.labelTextColor = fontDarkColor.withAlphaComponent(0.35)
    }
    
    @objc func configMarkerView() {
        chartView.highlightFullBarEnabled = true
        markerView.frame = CGRect(x: 0, y: 0, width: 160, height: 120)
        markerView.backgroundColor = .clear
        markerView.lineView.backgroundColor = collectionBgColor
        markerView.contentView.layer.backgroundColor = collectionBgColor.cgColor
        markerView.chartView = chartView
        chartView.marker = markerView
    }
    
}

// MARK: - ChartViewDelegate
@objc extension XWHRoundedCornersBarChartBaseCTCell: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard entry.y != 0 else {
            chartView.highlightValue(nil)

            return
        }
        
        guard let cChartDataModel = chartDataModel else {
            chartView.highlightValue(nil)
            
            return
        }
        
        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else {
            chartView.highlightValue(nil)

            return
        }
        
        let entryIndex = dataSet.entryIndex(entry: entry)
        
        guard let rawValue = cChartDataModel.rawValues[entryIndex] else {
            chartView.highlightValue(nil)

            return
        }
        
        markerView.setShowOffset(chartView, entry: entry, highlight: highlight)
        showMarker(with: rawValue)
    }
    
}

