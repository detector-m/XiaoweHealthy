//
//  XWHBarChartBaseCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/13.
//

import UIKit
import Charts

class XWHBarChartBaseCTCell: XWHGradientBaseCTCell {
    
    private(set) lazy var chartView = BarChartView()
    private(set) lazy var markerView = XWHChartMarkerView()
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(chartView)
    
        isHorizontal = false
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 30, weight: .bold)
        textLb.textColor = fontDarkColor
        textLb.textAlignment = .left
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        detailLb.textAlignment = .left
        
        configChartViewCommon()
        configXAxis()
        configYAxis()
        configMarkerView()
    }
    
    final func relayoutTitleValueView() {
        textLb.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.left.right.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(16)
        }
        detailLb.snp.makeConstraints { make in
            make.left.right.equalTo(textLb)
            make.top.equalTo(textLb.snp.bottom).offset(2)
            make.height.equalTo(16)
        }
    }
    
}

extension XWHBarChartBaseCTCell {
    
    @objc func configChartViewCommon() {
        chartView.backgroundColor = .clear

        chartView.delegate = self
        chartView.noDataText = ""
        chartView.legend.enabled = false
        
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.doubleTapToZoomEnabled = false
        chartView.dragEnabled = false
        
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
        markerView.chartView = chartView
        chartView.marker = markerView
    }
    
}

// MARK: - ChartViewDelegate
@objc extension XWHBarChartBaseCTCell: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let _ = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
        
        markerView.setShowOffset(chartView, entry: entry, highlight: highlight)
//        let entryIndex = dataSet.entryIndex(entry: entry)
        markerView.textLb.text = entry.x.int.string
        markerView.detailLb.text = entry.y.int.string
    }
    
}
