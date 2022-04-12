//
//  XWHHeartSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB


// MARK: - 心率设置模型
class XWHHeartSetModel: XWHDataBaseModel {
    
    enum HeartSetOptionType {
        case none
        case highWarn
    }
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn, isHighWarn, highWarnValue
    }
    
    class override var databaseTableName: String {
        "heart_set_model"
    }
    
    /// 总开关 (心率监测)
    var isOn = true
    
    /// 心率过高预警开关
    var isHighWarn = true
    
    /// 心率过高预警值
    var highWarnValue = 130
    
    /// 设置类型
    var optionType = HeartSetOptionType.none
    
    override init() {
        super.init()
    }
    
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[Columns.identifier]

        isOn = row[Columns.isOn]
        
        isHighWarn = row[Columns.isHighWarn]
        highWarnValue = row[Columns.highWarnValue]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier

        container[Columns.isOn] = isOn
        
        container[Columns.isHighWarn] = isHighWarn
        container[Columns.highWarnValue] = highWarnValue
    }

}
