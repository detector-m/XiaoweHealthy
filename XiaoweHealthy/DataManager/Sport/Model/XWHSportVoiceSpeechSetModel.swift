//
//  XWHSportVoiceSpeechSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/25.
//

import UIKit
import GRDB

/// 运动语音播报设置
class XWHSportVoiceSpeechSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn, isDistanceOn, isDurationOn, isPaceOn, isHeartOn, timeInterval
    }
    
    class override var databaseTableName: String {
        "sport_set_model"
    }
    
    /// 语音播报总开关
    var isOn = true
    
    /// 距离
    var isDistanceOn = true
    
    /// 时长
    var isDurationOn = true
    
    /// 配速
    var isPaceOn = true
    
    /// 心率
    var isHeartOn = true
    
    /// 播报频率 （分钟）
    var timeInterval = 10
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[Columns.identifier]

        isOn = row[Columns.isOn]
        
        isDistanceOn = row[Columns.isDistanceOn]
        isDurationOn = row[Columns.isDurationOn]
        isPaceOn = row[Columns.isPaceOn]
        isHeartOn = row[Columns.isHeartOn]
        timeInterval = row[Columns.timeInterval]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier

        container[Columns.isOn] = isOn
        
        container[Columns.isDistanceOn] = isDistanceOn
        container[Columns.isDurationOn] = isDurationOn
        container[Columns.isPaceOn] = isPaceOn
        container[Columns.isHeartOn] = isHeartOn
        container[Columns.timeInterval] = timeInterval
    }

}
