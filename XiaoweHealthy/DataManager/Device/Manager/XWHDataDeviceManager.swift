//
//  XWHDataDeviceManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/9.
//

import Foundation
import GRDB



class XWHDataDeviceManager {

    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createDeviceModelTable(_ db: Database) throws {
        try db.create(table: XWHDevWatchModel.databaseTableName) { t in
//                t.autoIncrementedPrimaryKey("id")
            t.column(XWHDevWatchModel.Columns.identifier.name, .text).notNull()
            t.column(XWHDevWatchModel.Columns.name.name, .text).notNull()
            t.column(XWHDevWatchModel.Columns.type.name, .text).notNull()
            t.column(XWHDevWatchModel.Columns.mac.name, .text).notNull()
            t.column(XWHDevWatchModel.Columns.version.name, .text).notNull()
            t.column(XWHDevWatchModel.Columns.battery.name, .integer).notNull()
            
            t.primaryKey([XWHDevWatchModel.Columns.identifier.name])
        }
    }
    
    /// Saves (inserts or updates) a player. When the method returns, the
    /// player is present in the database, and its id is not nil.
    func saveDeviceWatchModel(_ devWatch: inout XWHDevWatchModel) {
        appDB.write { db in
            try devWatch.save(db)
        }
    }
    
    func deleteDeviceWatchModel(_ devWatch: XWHDevWatchModel) {
        appDB.write { db in
//            try XWHDevWatchModel.deleteOne(db, key: devWatch.identifier)
            try devWatch.delete(db)
        }
    }
    
    func deleteAllDeviceWatchModel() {
        appDB.write { db in
            try XWHDevWatchModel.deleteAll(db)
        }
    }
    
    func getDeviceWatchModel(_ id: String) -> XWHDevWatchModel? {
        return appDB.read { db in
            try XWHDevWatchModel.fetchOne(db, key: id)
        }
    }
    
}

