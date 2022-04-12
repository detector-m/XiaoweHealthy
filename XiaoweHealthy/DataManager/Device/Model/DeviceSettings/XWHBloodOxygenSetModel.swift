//
//  XWHBloodOxygenSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB


// MARK: - 血氧设置模型
class XWHBloodOxygenSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn, beginTime, endTime, duration
    }
    
    class override var databaseTableName: String {
        "blood_oxygen_set_model"
    }
    
    /// 总开关
    var isOn = true
    
    /// 开始结束时间
    var beginTime = "00:00"
    var endTime = "23:59"
    
    /// 间隔时间 分钟
    var duration = 60
    
    var isSetBeginEndTime = false
    
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
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier

        container[Columns.isOn] = isOn
        
        container[Columns.beginTime] = beginTime
        container[Columns.endTime] = endTime
        
        container[Columns.duration] = duration
    }

}
