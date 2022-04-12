//
//  XWHDataRaiseWristSetManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import GRDB

// MARK: - 抬腕亮屏设置数据管理
class XWHDataRaiseWristSetManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createRaiseWristSetTable(_ db: Database) throws {
        try db.create(table: XWHRaiseWristSetModel.databaseTableName, body: { t in
            t.column(XWHRaiseWristSetModel.Columns.identifier.name, .text).primaryKey()

            t.column(XWHRaiseWristSetModel.Columns.isOn.name, .boolean)
            
            t.column(XWHRaiseWristSetModel.Columns.duration.name, .integer)
        })
    }
    
    class func saveRaiseWristSet(_ raiseWristSet: XWHRaiseWristSetModel) {
        appDB.write { db in
            try raiseWristSet.save(db)
        }
    }
    
    class func getRaiseWristSet(identifier: String) -> XWHRaiseWristSetModel? {
        appDB.read { db in
            try XWHRaiseWristSetModel.fetchOne(db, key: identifier)
        }
    }
    
    class func deleteRaiseWristSet(identifier: String) {
        appDB.write { db in
            try XWHRaiseWristSetModel.deleteOne(db, key: identifier)
        }
    }
    
    class func deleteRaiseWristSet(_ raiseWristSet: XWHRaiseWristSetModel) {
        appDB.write { db in
            try raiseWristSet.delete(db)
        }
    }
    
    class func deleteAllRaiseWristSet() {
        appDB.write { db in
            try XWHRaiseWristSetModel.deleteAll(db)
        }
    }
    
}
