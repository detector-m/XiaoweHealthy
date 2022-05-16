//
//  XWHHeartChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/14.
//

import UIKit
import Charts

class XWHHeartChartCTCell: XWHColumnRangeBarChartBaseCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        gradientColors = [UIColor(hex: 0xFFE0E2)!, UIColor(hex: 0xFFFFFF)!]
    }
    
    func update(dateText: String, sDate: Date, dateType: XWHHealthyDateSegmentType) {
        textLb.text = R.string.xwhHealthyText.暂无数据()
        detailLb.text = ""
        
        chartView.data = getChartData(chartDataModel: XWHChartDataBaseModel())
    }
    
}

extension XWHHeartChartCTCell {
    
    private func getChartData(chartDataModel: XWHChartDataBaseModel) -> ColumnRangeBarChartData {
        //第一组烛形图的10条随机数据
        let dataEntries1 = (0..<10).map { (i) -> ColumnRangeBarChartDataEntry in
            let val = Double(arc4random_uniform(40) + 10)
            let high = Double(arc4random_uniform(9) + 8)
            let low = Double(arc4random_uniform(9) + 8)
//            let open = Double(arc4random_uniform(6) + 1)
//            let close = Double(arc4random_uniform(6) + 1)
//            let even = arc4random_uniform(2) % 2 == 0 //true表示开盘价高于收盘价
            return ColumnRangeBarChartDataEntry(x: Double(i), shadowH: val + high, shadowL: val - low, open: val - low, close: val + high)
        }
        let chartDataSet1 = ColumnRangeBarChartDataSet(entries: dataEntries1, label: "图例1")
        chartDataSet1.roundedCorners = .allCorners
        chartDataSet1.increasingFilled = true
        
        //目前烛形图包括1组数据
        let chartData = ColumnRangeBarChartData(dataSets: [chartDataSet1])
        
        return chartData
    }
    
}
