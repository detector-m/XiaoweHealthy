//
//  XWHHeartUIHeartModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import Foundation
import HandyJSON


/// 心率界面的心率模型
class XWHHeartUIHeartModel: HandyJSON {
    
    var rateRange = ""
    var restRate = 0
    var avgRate = 0
    
    var rateSection = XWHHeartUIHeartSectionModel()
    
    var items = [XWHHeartUIHeartChartModel]()
    
    required init() {
        
    }
    
}

/// 心率界面心率区间模型
class XWHHeartUIHeartSectionModel: HandyJSON {
    
    /// 燃脂心率
    var burnRate = ""
    /// 无氧心率
    var anaerobicRate = ""
    /// 心肺心率
    var lungRate = ""
    /// 减压心率
    var relaxRate = ""
    /// 极限心率
    var limitRate = ""
    
    required init() {
        
    }
    
}

/// 心率界面心率图表模型
class XWHHeartUIHeartChartModel: HandyJSON {
    
    var highest = 0
    var average = 0
    var lowest = 0
    var timeAxis = ""
    
    required init() {
        
    }
    
}