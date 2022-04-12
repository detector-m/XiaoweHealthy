//
//  XWHDataBloodOxygenSetManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import GRDB

// MARK: - 血氧设置数据管理
class XWHDataBloodOxygenSetManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createBloodOxygenSetTable(_ db: Database) throws {
        try db.create(table: XWHBloodOxygenSetModel.databaseTableName, body: { t in
            t.column(XWHWeatherSetModel.Columns.identifier.name, .text).primaryKey()

            t.column(XWHBloodOxygenSetModel.Columns.isOn.name, .boolean)
            
            t.column(XWHBloodOxygenSetModel.Columns.duration.name, .integer)
        })
    }
    
    class func saveBloodOxygenSet(_ bloodOxygenSet: XWHBloodOxygenSetModel) {
        appDB.write { db in
            try bloodOxygenSet.save(db)
        }
    }
    
    class func getBloodOxygenSet(identifier: String) -> XWHBloodOxygenSetModel? {
        appDB.read { db in
            try XWHBloodOxygenSetModel.fetchOne(db, key: identifier)
        }
    }
    
    class func deleteBloodOxygenSet(identifier: String) {
        appDB.write { db in
            try XWHBloodOxygenSetModel.deleteOne(db, key: identifier)
        }
    }
    
    class func deleteBloodOxygenSet(_ bloodOxygenSet: XWHBloodOxygenSetModel) {
        appDB.write { db in
            try bloodOxygenSet.delete(db)
        }
    }
    
    class func deleteAllBloodOxygenSet() {
        appDB.write { db in
            try XWHBloodOxygenSetModel.deleteAll(db)
        }
    }
    
}
