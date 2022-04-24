//
//  XWHHeartUIAllDataItemModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import Foundation
import HandyJSON


/// 心率界面所有数据界面 item model
class XWHHeartUIAllDataItemModel: HandyJSON {
    
    var month = ""
    
    var items = [XWHHeartUIAllDataRateRangeModel]()
    
    required init() {
        
    }
    
}


class XWHHeartUIAllDataRateRangeModel: HandyJSON {
    
    var rateRange = ""
    var collectTime = ""
    
    required init() {
        
    }
    
}
