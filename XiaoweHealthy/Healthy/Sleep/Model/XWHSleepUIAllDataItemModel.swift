//
//  XWHSleepUIAllDataItemModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/9.
//

import UIKit



/// 睡眠界面所有数据界面 item model
class XWHSleepUIAllDataItemModel: HandyJSON {
    
    var month = ""
    
    var items = [XWHSleepUIAllDataItemSleepModel]()
    
    required init() {
        
    }
    
}

class XWHSleepUIAllDataItemSleepModel: XWHHealthySleepUISleepBaseModel {

    /// 数据采集日期
    var collectTime = ""
    /// 入睡时间
    var bedTime = ""
    /// 起床时间
    var riseTime = ""
    
    /// 设备名称
    var deviceName = ""
    
}
