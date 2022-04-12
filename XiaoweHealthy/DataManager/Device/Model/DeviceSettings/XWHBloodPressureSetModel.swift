//
//  XWHBloodPressureSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB


// MARK: - 血压设置模型
class XWHBloodPressureSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn
    }
    
    class override var databaseTableName: String {
        "blood_pressure_set_model"
    }
    
    /// 总开关
    var isOn = false
    
    override init() {
        super.init()
    }
    
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[Columns.identifier]

        isOn = row[Columns.isOn]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier

        container[Columns.isOn] = isOn
    }

}
