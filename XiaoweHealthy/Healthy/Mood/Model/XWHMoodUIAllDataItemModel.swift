//
//  XWHMoodUIAllDataItemModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/8.
//

import UIKit
import HandyJSON


/// 情绪界面所有数据界面 item model
class XWHMoodUIAllDataItemModel: HandyJSON {
    
    var month = ""
    
    var items = [XWHMoodUIAllDataItemMoodModel]()
    
    required init() {
        
    }
    
}

///  情绪所有数据界面的压力模型
class XWHMoodUIAllDataItemMoodModel: HandyJSON {

    /// 数据采集日期
    var collectTime = ""
    /// 0消极1正常2积极
    var moodStatus = 0
    
    /// 来源
    var deviceName = ""
    
    /// 记录id
    var srId = 0
    
    /// 标准的时间格式    
    var standardTimeFormat: String {
        return "yyyy-MM-dd HH:mm:ss"
    }
    
    required init() {
        
    }
    
    // MARK: - HandyJSON
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            srId <-- "id"
    }
    
    // MARK: - Methods
    func formatDate() -> Date? {
        collectTime.date(withFormat: standardTimeFormat)
    }
    
}
