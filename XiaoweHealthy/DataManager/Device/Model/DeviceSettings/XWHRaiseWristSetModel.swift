//
//  XWHRaiseWristSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB



// MARK: - 抬腕亮屏设置模型
class XWHRaiseWristSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn, duration
    }
    
    class override var databaseTableName: String {
        "raise_wrist_set_model"
    }
    
    /// 总开关
    var isOn = true
    
    /// 抬腕亮屏的时间(默认 5s)
    var duration = 5
    
    override init() {
        super.init()
    }
    
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[Columns.identifier]

        isOn = row[Columns.isOn]
        
        duration = row[Columns.duration]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier

        container[Columns.isOn] = isOn
        
        container[Columns.duration] = duration
    }

}
