//
//  XWHColumnRangeBarChartBaseCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/14.
//

import UIKit
import Charts

class XWHColumnRangeBarChartBaseCTCell: XWHChartBaseCTCell {
    
    private(set) lazy var chartView = CandleStickChartView()
    private lazy var columnRangeBarChartRenderer = XWHColumnRangeBarChartRenderer(dataProvider: chartView, animator: chartView.chartAnimator, viewPortHandler: chartView.viewPortHandler)
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(chartView)
        
        configChartViewCommon()
        configXAxis()
        configYAxis()
        configMarkerView()
    }
    
    override func relayoutSubViews() {
        relayoutTitleValueView()
        
        chartView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview()
        }
    }
    
}

extension XWHColumnRangeBarChartBaseCTCell {
    
    @objc func configChartViewCommon() {
        chartView.backgroundColor = .clear
        
        chartView.renderer = columnRangeBarChartRenderer

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
        
        chartView.accessibilityElements
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
        markerView.frame = CGRect(x: 0, y: 0, width: 160, height: 120)
        markerView.backgroundColor = .clear
        markerView.chartView = chartView
        chartView.marker = markerView
    }
    
}

// MARK: - ChartViewDelegate
@objc extension XWHColumnRangeBarChartBaseCTCell: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let _ = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
        
        markerView.setShowOffset(chartView, entry: entry, highlight: highlight)
//        let entryIndex = dataSet.entryIndex(entry: entry)
        markerView.textLb.text = entry.x.int.string
        markerView.detailLb.text = entry.y.int.string
    }
    
}

