//
//  XWHLongSitSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB

// MARK: - 久坐提醒设置模型
class XWHLongSitSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn, beginTime, endTime, duration, isSiestaOn
    }
    
    class override var databaseTableName: String {
        "long_sit_set_model"
    }
    
    /// 总开关
    var isOn = false
    
    /// 开始结束时间
    var beginTime = "08:00"
    var endTime = "21:00"
    
    /// 间隔 分钟
    var duration = 60
    
    /// 午休免打扰
    var isSiestaOn = true
    
    override init() {
        super.init()
    }
    
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[Columns.identifier]

        isOn = row[Columns.isOn]
        
        beginTime = row[Columns.beginTime]
        
        endTime = row[Columns.endTime]
        
        duration = row[Columns.duration]
        
        isSiestaOn = row[Columns.isSiestaOn]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier

        container[Columns.isOn] = isOn
        
        container[Columns.beginTime] = beginTime
        container[Columns.endTime] = endTime
        container[Columns.duration] = duration
        
        container[Columns.isSiestaOn] = isSiestaOn
    }

}
