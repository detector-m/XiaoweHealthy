//
//  XWHChartDataBaseModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/13.
//

import Foundation

/// 不同数据基础模型
class XWHChartDataBaseModel {
    
    var max: Double = 0
    var min: Double = 0
    var granularity: Double = 0
    var xLabelCount: Int = 0
    
    var xAxisValues: [String] = []
    var yAxisValues: [String] = []
    
    /// 图表数据
    var yValues: [Any] = []
    /// 原始数据
    var rawValues: [Any?] = []
    
    /// 原始数据所在的标识
//    var rawDataXAxisIndexArray: [Int] = []
    
}
