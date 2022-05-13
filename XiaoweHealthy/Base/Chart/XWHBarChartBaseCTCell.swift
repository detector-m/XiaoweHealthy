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
    }
    
    @objc func configXAxis() {
        chartView.xAxis.labelPosition = .bottom
        
        chartView.xAxis.axisLineWidth = 0.5
        chartView.xAxis.axisLineColor = UIColor.black.withAlphaComponent(0.05)
        
//        chartView.xAxis.gridLineWidth = 0.5
//        chartView.xAxis.gridColor = UIColor.black.withAlphaComponent(0.05)
        chartView.xAxis.drawGridLinesEnabled = false
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
    }
    
}

@objc extension XWHBarChartBaseCTCell: ChartViewDelegate {
    
    
    
}
