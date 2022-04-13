//
//  XWHDataWatchManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/13.
//

import Foundation
import GRDB


class XWHDataWatchManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createWatchTable(_ db: Database) throws {
        try db.create(table: XWHDevWatchModel.databaseTableName) { t in
//            t.autoIncrementedPrimaryKey("id")
            t.column(XWHDevWatchModel.Columns.identifier.name, .text).notNull().primaryKey()
            
            t.column(XWHDevWatchModel.Columns.name.name, .text).notNull()
            
            t.column(XWHDevWatchModel.Columns.category.name, .text).notNull()
            
            t.column(XWHDevWatchModel.Columns.type.name, .text).notNull()
            t.column(XWHDevWatchModel.Columns.mac.name, .text).notNull()
            t.column(XWHDevWatchModel.Columns.version.name, .text).notNull()
            t.column(XWHDevWatchModel.Columns.battery.name, .integer).notNull()
            
            t.column(XWHDevWatchModel.Columns.bindDate.name, .text).notNull()
            
            t.column(XWHDevWatchModel.Columns.isCurrent.name, .boolean).notNull()
            
//            t.primaryKey([XWHDevWatchModel.Columns.identifier.name])
        }
    }
    
    /// Saves (inserts or updates) a player. When the method returns, the
    /// player is present in the database, and its id is not nil.
    class func saveWatch(_ devWatch: XWHDevWatchModel) {
        appDB.write { db in
            try devWatch.save(db)
        }
    }
    
    class func deleteWatch(identifier: String) {
        appDB.write { db in
            try XWHDevWatchModel.deleteOne(db, key: identifier)
        }
    }
    
//    class func deleteWatch(_ devWatch: XWHDevWatchModel) {
//        appDB.write { db in
////            try XWHDevWatchModel.deleteOne(db, key: devWatch.identifier)
//            try devWatch.delete(db)
//        }
//    }
    
    class func deleteAllWatch() {
        appDB.write { db in
            try XWHDevWatchModel.deleteAll(db)
        }
    }
    
    class func getWatch(identifier: String) -> XWHDevWatchModel? {
        return appDB.read { db in
            try XWHDevWatchModel.fetchOne(db, key: identifier)
        }
    }
    
    class func getCurrentWatch() -> XWHDevWatchModel? {
        return appDB.read { db in
            //try XWHDevWatchModel.fetchOne(db, key: [XWHDevWatchModel.Columns.isCurrent.name: true])
//            try XWHDevWatchModel.filter(Column(XWHDevWatchModel.Columns.isCurrent.name) == true).fetchOne(db)
            
            try XWHDevWatchModel.filter(XWHDevWatchModel.Columns.isCurrent == true).fetchOne(db)
        }
    }
    
    class func getCurrentWatchIdentifier() -> String? {
        return getCurrentWatch()?.identifier
    }
    
}
