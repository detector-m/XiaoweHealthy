//
//  XWHMentalStressUIAllDataItemModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/9.
//

import UIKit
import HandyJSON


/// 精神压力界面所有数据界面 item model
class XWHMentalStressUIAllDataItemModel: HandyJSON {

    var month = ""
    
    var items = [XWHMentalStressUIAllDataItemStressModel]()
    
    required init() {
        
    }
    
}


class XWHMentalStressUIAllDataItemStressModel: HandyJSON {

    /// 数据采集日期
    var collectTime = ""
    /// 平均值
    var avgPressureVal = 0
    
    required init() {
        
    }
    
}
