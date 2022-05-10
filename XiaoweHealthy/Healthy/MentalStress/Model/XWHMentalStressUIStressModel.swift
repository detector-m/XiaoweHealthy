//
//  XWHMentalStressUIStressModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/10.
//

import UIKit
import HandyJSON

/// 精神压力界面的压力模型
class XWHMentalStressUIStressModel: HandyJSON {
    
    /// 压力范围（最大值和最小值）
    var range: [Int] = [0, 0]
    /// 平均值
    var averageVal = 0
    /// 放松状态频次
    var relaxNumber = 0
    /// 正常状态频次
    var normalNumber = 0
    /// 中等状态频次
    var mediumNumber = 0
    /// 高等状态频次
    var highNumber = 0
    /// 所有状态频次
    var totalNumber = 0

    var items = [XWHChartUIChartItemModel]()
    
    required init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            range <-- "pressureRange"
    }
    
}
