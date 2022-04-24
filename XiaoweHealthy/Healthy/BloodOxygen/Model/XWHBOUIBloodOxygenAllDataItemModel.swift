//
//  XWHBOUIBloodOxygenAllDataItemModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import Foundation
import HandyJSON


/// 血氧界面所有数据界面 item model
class XWHBOUIBloodOxygenAllDataItemModel: HandyJSON {
 
    var month = ""
    
    var items = [XWHBOUIAllDataBORangeModel]()
    
    required init() {
        
    }
    
}


class XWHBOUIAllDataBORangeModel: HandyJSON {
    
    var oxygenRange = ""
    var collectTime = ""
    
    required init() {
        
    }
    
}
