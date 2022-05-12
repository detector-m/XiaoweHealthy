//
//  XWHHealthySleepUISleepModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/9.
//

import UIKit
import HandyJSON


/// 睡眠界面的睡眠 基础 模型
class XWHHealthySleepUISleepBaseModel: HandyJSON {
    
    /// 睡眠评分
    var sleepScore = 0
    /// 睡眠总时长
    var totalSleepDuration = 0
    /// 深睡时长
    var deepSleepDuration = 0
    /// 浅睡时长
    var lightSleepDuration = 0
    /// 清醒时长
    var awakeDuration = 0
    
    required init() {
        
    }
    
}

/// 睡眠界面的睡眠模型
class XWHHealthySleepUISleepModel: XWHHealthySleepUISleepBaseModel {
    
    /// 入睡时间
    var bedTime = ""
    /// 起床时间
    var riseTime = ""
    
    /// 醒来次数
    var awakeCount = 0

    /// 详细数据
    var items: [XWHHealthySleepUISleepItemModel] = []
    
}

/// 睡眠界面的睡眠 item 模型
class XWHHealthySleepUISleepItemModel: XWHHealthySleepUISleepBaseModel {

    // MARK: - 仅对按天查询有效
    /// 单次睡眠开始时间，仅对按天查询有效
    var startTime = ""
    /// 单次睡眠结束时间，仅对按天查询有效
    var endTime = ""
    /// 单次睡眠持续时间，仅对按天查询有效
    var duration = 0
    /// 睡眠状态0深睡1浅睡2清醒，仅对按天查询有效
    var sleepStatus = 0
    
    // MARK: - 仅在非按天查询时才会返回
    /// 数据采集时间 仅在非按天查询时才会返回
    var timeAxis = ""
    
    /// 睡眠总时长 仅在非按天查询时才会返回
//    var totalSleepDuration = 0
    /// 深睡时长 仅在非按天查询时才会返回
//    var deepSleepDuration = 0
    /// 浅睡时长 仅在非按天查询时才会返回
//    var lightSleepDuration = 0
    /// 清醒时长 仅在非按天查询时才会返回
//    var awakeDuration = 0
    
    ///
    /// 睡眠偏移
    var sleepOffset = 0
    
}
