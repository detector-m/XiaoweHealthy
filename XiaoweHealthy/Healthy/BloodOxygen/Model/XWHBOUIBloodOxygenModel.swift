//
//  XWHBOUIBloodOxygenModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import Foundation
import HandyJSON


class XWHBOUIBloodOxygenModel: HandyJSON {
    
    var avgBloodOxygen = 0
    var bloodOxygenRange = ""
    
    var items = [XWHChartUIChartItemModel]()
    
    required init() {
        
    }
    
}
