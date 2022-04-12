//
//  XWHDataHeartSetManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import GRDB


// MARK: - 心率设置数据管理
class XWHDataHeartSetManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createHeartSetTable(_ db: Database) throws {
        try db.create(table: XWHHeartSetModel.databaseTableName, body: { t in
            t.column(XWHHeartSetModel.Columns.identifier.name, .text).primaryKey()
            
            t.column(XWHHeartSetModel.Columns.isOn.name, .boolean)
            
            t.column(XWHHeartSetModel.Columns.isHighWarn.name, .boolean)
            t.column(XWHHeartSetModel.Columns.highWarnValue.name, .integer)
        })
    }
    
    class func saveHeartSet(_ heartSet: XWHHeartSetModel) {
        appDB.write { db in
            try heartSet.save(db)
        }
    }
    
    class func getHeartSet(identifier: String) -> XWHHeartSetModel? {
        appDB.read { db in
            try XWHHeartSetModel.fetchOne(db, key: identifier)
        }
    }
    
    class func deleteHeartSet(identifier: String) {
        appDB.write { db in
            try XWHHeartSetModel.deleteOne(db, key: identifier)
        }
    }
    
    class func deleteHeartSet(_ heartSet: XWHHeartSetModel) {
        appDB.write { db in
            try heartSet.delete(db)
        }
    }
    
    class func deleteAllHeartSet() {
        appDB.write { db in
            try XWHHeartSetModel.deleteAll(db)
        }
    }
    
}
