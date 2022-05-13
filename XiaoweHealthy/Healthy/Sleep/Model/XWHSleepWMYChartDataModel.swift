//
//  XWHSleepWMYChartDataModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/13.
//

import Foundation


/// 睡眠周月年的图表数据模型
struct XWHSleepWMYChartDataModel {
    
    var max: Double = 0
    var min: Double = 0
    var granularity: Double = 0
    
    var xAxisValues: [String] = []
    var yValues: [[Double]] = []
    
    var yAxisValues: [String] = []
    
}
