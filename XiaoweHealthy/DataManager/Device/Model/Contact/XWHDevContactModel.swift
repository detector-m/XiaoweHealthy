//
//  XWHDevContactModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/13.
//

import Foundation
import GRDB


class XWHDevContactModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case pid, identifier, name, number
    }
    
    class override var databaseTableName: String {
        "device_contact_model"
    }

    // 主键
    var pid: Int64?

    /// 属于那个设备 （非主键）
//    var identifier = ""
    
    var name = ""
    var number = ""
    
    // 用于UI设置
    var isSelected = false
    
    override var debugDescription: String {
        return "{ identifier = \(identifier), name = \(name), number = \(number) }"
    }
    
    override init() {
        super.init()
    }
    
    required init(row: Row) {
        super.init(row: row)
        
        pid = row[Columns.pid]
        
        identifier = row[Columns.identifier]
        name = row[Columns.name]
        number = row[Columns.number]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.pid] = pid
        
        container[Columns.identifier] = identifier
        container[Columns.name] = name
        container[Columns.number] = number
    }
    
    override func didInsert(with rowID: Int64, for column: String?) {
        pid = rowID
    }
    
}
