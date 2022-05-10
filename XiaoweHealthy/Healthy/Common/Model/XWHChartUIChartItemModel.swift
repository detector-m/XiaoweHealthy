//
//  XWHChartUIChartItemModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/10.
//

import UIKit
import HandyJSON


/// 图表Item 模型
class XWHChartUIChartItemModel: HandyJSON {

    var highest = 0
    var average = 0
    var lowest = 0
    
    /// 2022-04-28 21:05:15
    var timeAxis = ""
    
    required init() {
        
    }
    
}
