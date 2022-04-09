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
    
    public enum Columns: String, ColumnExpression {
        case identifier, name, type, mac, version, battery
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
        type = XWHDeviceType(rawValue: row[Columns.type]) ?? .none
        mac = row[Columns.mac]
        version = row[Columns.version]
        battery = row[Columns.battery]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier

        container[Columns.name] = name
        container[Columns.type] = type.rawValue
        container[Columns.mac] = mac
        container[Columns.version] = version
        container[Columns.battery] = battery
    }

}
