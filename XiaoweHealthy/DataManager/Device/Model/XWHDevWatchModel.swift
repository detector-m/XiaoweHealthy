//
//  XWHDevWatchModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import UIKit
import GRDB

// MARK: - 手表模型
class XWHDevWatchModel: XWHDeviceBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, name, category, type, mac, version, battery, bindDate, isCurrent
    }
    
    class override var databaseTableName: String {
        "device_watch_model"
    }
    
    override init() {
        super.init()
    }
    
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[Columns.identifier]

        name = row[Columns.name]
        category = XWHDeviceCategory(rawValue: row[Columns.category]) ?? .none
        
        type = XWHDeviceType(rawValue: row[Columns.type]) ?? .none
        
        mac = row[Columns.mac]
        version = row[Columns.version]
        battery = row[Columns.battery]
        
        bindDate = row[Columns.bindDate]
        
        isCurrent = row[Columns.isCurrent]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier

        container[Columns.name] = name
        
        container[Columns.category] = category.rawValue
        
        container[Columns.type] = type.rawValue
        
        container[Columns.mac] = mac
        container[Columns.version] = version
        container[Columns.battery] = battery
        
        container[Columns.bindDate] = bindDate
        
        container[Columns.isCurrent] = isCurrent
    }
    
//    override func didInsert(with rowID: Int64, for column: String?) {
//        pid = rowID
//    }

}
