//
//  XWHDisturbSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB


// MARK: - 勿扰设置模型
class XWHDisturbSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn, beginTime, endTime, isVibrationOn, isMessageOn
    }
    
    class override var databaseTableName: String {
        "disturb_set_model"
    }
    
    /// 总开关
    var isOn = false
    
    /// 开始结束时间
    var beginTime = "23:00"
    var endTime = "08:00"
    
    /// 是否设备震动
    var isVibrationOn = true
    
    /// 是否消息推送
    var isMessageOn = true
    
    override init() {
        super.init()
    }
    
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[Columns.identifier]

        isOn = row[Columns.isOn]
        
        beginTime = row[Columns.beginTime]
        endTime = row[Columns.endTime]
        
        isVibrationOn = row[Columns.isVibrationOn]
        
        isMessageOn = row[Columns.isMessageOn]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier

        container[Columns.isOn] = isOn
        
        container[Columns.beginTime] = beginTime
        container[Columns.endTime] = endTime
        
        container[Columns.isVibrationOn] = isVibrationOn
        
        container[Columns.isMessageOn] = isMessageOn
    }
    
}
