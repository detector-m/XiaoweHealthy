//
//  XWHHomeHeartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/15.
//

import UIKit

class XWHHomeHeartCTCell: XWHHomeColumnRangeBarChartCTCell {
    
    func update(heartUIModel: XWHHeartUIHeartModel?) {
        guard let heartUIModel = heartUIModel else {
            showEmptyView()
            return
        }
        
        hideEmptyView()
 
        let rawItems: [XWHChartUIChartItemModel] = heartUIModel.items

        let sDate = Date()
        
        detailLb.text = sDate.string(withFormat: XWHDate.monthDayFormat)
        
//        let sEDate = sDate.dayBegin
//        for i in 0 ..< 24 {
//            let item = XWHChartUIChartItemModel()
//
//            item.lowest = Int(arc4random() % 51) + 40
//            item.highest = item.lowest + Int(arc4random() % 51)
//
//            let iDate = sEDate.adding(.hour, value: i)
//            item.timeAxis = iDate.string(withFormat: XWHDate.standardTimeAllFormat)
//
//            rawItems.append(item)
//        }
        
        let chartDataModel = XWHHealthyChartDataHandler.getHeartChartDataModel(date: sDate, dateType: .day, rawItems: rawItems)
        self.chartDataModel = chartDataModel
        
        chartView.rightAxis.axisMaximum = chartDataModel.max
        chartView.rightAxis.axisMinimum = chartDataModel.min
        chartView.rightAxis.granularity = chartDataModel.granularity
        
        chartView.leftAxis.axisMaximum = chartDataModel.max
        chartView.leftAxis.axisMinimum = chartDataModel.min
        chartView.leftAxis.granularity = chartDataModel.granularity
        
        chartView.data = getHeartChartData(chartDataModel: chartDataModel)
    }
    
}
