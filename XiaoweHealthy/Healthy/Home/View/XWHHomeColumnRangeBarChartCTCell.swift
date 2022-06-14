//
//  XWHHomeColumnRangeBarChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/13.
//

import UIKit
import Charts

class XWHHomeColumnRangeBarChartCTCell: XWHColumnRangeBarChartBaseCTCell {
    
    lazy var emptyChartView = UIView()
    
    lazy var bLb = UILabel()
    lazy var eLb = UILabel()
    
    override func addSubViews() {
        super.addSubViews()
        
        gradientLayer.isHidden = true
        gradientColors = [UIColor.white, UIColor.white]
        
        contentView.addSubview(imageView)
        
        contentView.addSubview(emptyChartView)
        contentView.addSubview(bLb)
        contentView.addSubview(eLb)

        layer.cornerRadius = 16
        layer.backgroundColor = contentBgColor.cgColor
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        
        imageView.layer.cornerRadius = 16
        imageView.layer.backgroundColor = fontDarkColor.withAlphaComponent(0.4).cgColor
        imageView.contentMode = .center
//        imageView.image = R.image.moodIcon()
        
        emptyChartView.layer.cornerRadius = 8

        bLb.font = XWHFont.harmonyOSSans(ofSize: 10, weight: .regular)
        bLb.textColor = fontDarkColor.withAlphaComponent(0.25)
        bLb.textAlignment = .left
        
        eLb.font = bLb.font
        eLb.textColor = bLb.textColor
        eLb.textAlignment = .right
        
        bLb.text = "00:00"
        eLb.text = "24:00"
        
//        showEmptyView()
        hideEmptyView()
    }
    
    override func relayoutSubViews() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.left.top.equalTo(16)
        }
        
        textLb.snp.makeConstraints { make in
            make.left.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.height.equalTo(22)
        }
        
        detailLb.snp.makeConstraints { make in
            make.left.right.equalTo(textLb)
            make.height.equalTo(16)
            make.top.equalTo(textLb.snp.bottom).offset(4)
        }
        
        emptyChartView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.top.equalTo(detailLb.snp.bottom).offset(24)
        }
        
        bLb.snp.makeConstraints { make in
            make.left.equalTo(emptyChartView)
            make.right.equalTo(contentView.snp.centerX).offset(-1)
            make.height.equalTo(14)
            make.top.equalTo(emptyChartView.snp.bottom).offset(4)
        }
        
        eLb.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).offset(2)
            make.right.equalTo(emptyChartView)
            make.height.top.equalTo(bLb)
        }
        
        chartView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(detailLb.snp.bottom).offset(24)
//            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
    }
    
    
    func showEmptyView() {
        detailLb.text = R.string.xwhHealthyText.暂无数据()
        
        emptyChartView.isHidden = false
        chartView.isHidden = true
    }
    
    func hideEmptyView() {
        emptyChartView.isHidden = true
        chartView.isHidden = false
    }
    
    func update(healthType: XWHHealthyType) {
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
        
        if healthType == .heart {
            chartView.data = getHeartChartData(chartDataModel: chartDataModel)
        } else if healthType == .bloodOxygen {
            chartView.data = getBOChartData(chartDataModel: chartDataModel)
        } else {
            chartView.data = getStressChartData(chartDataModel: chartDataModel)
        }
    }
    
    
    private func getHeartChartData(chartDataModel: XWHChartDataBaseModel) -> ColumnRangeBarChartData {
        let chartDataSet = getChartDataSet(values: chartDataModel.yValues)
        chartDataSet.colors = [UIColor(hex: 0xEB5763)!]
        
        let bgChartDataSet = getBgChartSet(chartDataModel: chartDataModel, color: UIColor(hex: 0xEB5763)!.withAlphaComponent(0.08))
        let chartData = ColumnRangeBarChartData(dataSets: [bgChartDataSet, chartDataSet])
        
        return chartData
    }
    
    private func getBOChartData(chartDataModel: XWHChartDataBaseModel) -> ColumnRangeBarChartData {
        let chartDataSet = getChartDataSet(values: chartDataModel.yValues)
        chartDataSet.colors = [UIColor(hex: 0x6CD267)!]
        chartDataSet.segmentLimits = [90]
        chartDataSet.segmentColors = [UIColor(hex: 0xF0B36D)!, UIColor(hex: 0x6CD267)!]
        
        let bgChartDataSet = getBgChartSet(chartDataModel: chartDataModel, color: UIColor(hex: 0x6CD267)!.withAlphaComponent(0.1))

        let chartData = ColumnRangeBarChartData(dataSets: [bgChartDataSet, chartDataSet])
        return chartData
    }
    
    private func getStressChartData(chartDataModel: XWHChartDataBaseModel) -> ColumnRangeBarChartData {
        let chartDataSet = getChartDataSet(values: chartDataModel.yValues)
        chartDataSet.colors = [UIColor(hex: 0x76D4EA)!]
        chartDataSet.segmentLimits = [29, 59, 79]
        chartDataSet.segmentColors = [UIColor(hex: 0x49CE64)!, UIColor(hex: 0x76D4EA)!, UIColor(hex: 0xF0B36D)!, UIColor(hex: 0xED7135)!]
        
        let bgChartDataSet = getBgChartSet(chartDataModel: chartDataModel, color: UIColor(hex: 0x76D4EA)!.withAlphaComponent(0.1))
        
        let chartData = ColumnRangeBarChartData(dataSets: [bgChartDataSet, chartDataSet])
        
        return chartData
    }
    
    private func getBgChartSet(chartDataModel: XWHChartDataBaseModel, color: UIColor) -> ColumnRangeBarChartDataSet {
        var bgChartDataYValues: [[Double]] = []
        for _ in 0 ..< chartDataModel.yValues.count {
            let yValue = [0, chartDataModel.max]
            bgChartDataYValues.append(yValue)
        }
        let bgChartDataSet = getChartDataSet(values: bgChartDataYValues)
        bgChartDataSet.colors = [color]
        
        return bgChartDataSet
    }
    
}

extension XWHHomeColumnRangeBarChartCTCell {
    
    override func configChartViewCommon() {
        super.configChartViewCommon()
        
        chartView.drawMarkers = false
        chartView.isUserInteractionEnabled = false
        chartView.extraTopOffset = 0
        chartView.minOffset = 0
    }
    
    override func configXAxis() {
        super.configXAxis()
        
        chartView.xAxis.drawLabelsEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
    }
    
    override func configYAxis() {
        super.configYAxis()
        
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
    }
    
    override func configMarkerView() {
        
    }
    
}
