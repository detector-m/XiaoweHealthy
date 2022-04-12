//
//  XWHWeatherSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB


// MARK: - 天气设置模型
class XWHWeatherSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn
    }
    
    class override var databaseTableName: String {
        "weather_set_model"
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
