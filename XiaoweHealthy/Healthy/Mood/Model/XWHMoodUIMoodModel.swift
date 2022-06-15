//
//  XWHMoodUIMoodModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/7.
//

import UIKit
import HandyJSON


/// 情绪界面的 情绪 基础 模型
class XWHMoodUIMoodBaseModel: HandyJSON {
    
    /// 积极的次数
    var positiveTimes = 0
    
    /// 正常的次数
    var peaceTimes = 0
    
    /// 消极的次数
    var negativeTimes = 0

    
    /// 情绪值0消极1正常2积极
    var mood: Int {
        var times = positiveTimes - negativeTimes
        if times > 0 {
            return 2
        } else if times == 0 {
            return 1
        } else  {
            times += peaceTimes
            if times >= 0 {
                return 1
            }
            
            return 0
        }
    }
    
    required init() {
        
    }
    
}

/// 情绪界面的情绪模型
class XWHMoodUIMoodModel: XWHMoodUIMoodBaseModel {
    
    var items: [XWHMoodUIMoodItemModel] = []
    
}


/// 情绪界面的情绪 item 模型
class XWHMoodUIMoodItemModel: XWHMoodUIMoodBaseModel {
    
    /// 数据采集时间 仅在非按天查询时才会返回
    var timeAxis = ""
    
    /// 时间间隔内首次测量的时间
    var initialPoint = ""
    /// 时间间隔内末次测量的时间
    var finalPoint = ""
    
}
