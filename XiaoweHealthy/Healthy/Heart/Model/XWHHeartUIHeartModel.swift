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
    
    /// 心率范围
    var rateRange = ""
    /// 静息心率
    var restRate = 0
    /// 平均心率
    var avgRate = 0
    
    /// 心率区间
    var rateSection = XWHHeartUIHeartSectionModel()
    
    var items = [XWHChartUIChartItemModel]()
    
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
//class XWHHeartUIHeartChartModel: XWHChartUIChartItemModel {
//
//}
