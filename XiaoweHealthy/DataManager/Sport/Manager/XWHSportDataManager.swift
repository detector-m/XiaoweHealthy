//
//  XWHSportDataManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/25.
//

import Foundation
import GRDB

class XWHSportDataManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createTables(_ db: Database) throws {
        try createSportSetTable(db)
    }
    
}

// MARK: - SportSet
extension XWHSportDataManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createSportSetTable(_ db: Database) throws {
        try db.create(table: XWHSportSetModel.databaseTableName, body: { t in
            t.column(XWHSportSetModel.Columns.identifier.name, .text).primaryKey()

            t.column(XWHSportSetModel.Columns.isOn.name, .boolean)
            
            t.column(XWHSportSetModel.Columns.isDistanceOn.name, .boolean)
            t.column(XWHSportSetModel.Columns.isDurationOn.name, .boolean)
            t.column(XWHSportSetModel.Columns.isPaceOn.name, .boolean)
            t.column(XWHSportSetModel.Columns.isHeartOn.name, .boolean)
            
            t.column(XWHSportSetModel.Columns.timeInterval.name, .integer)
        })
    }
    
    class func getCurrentSportSet() -> XWHSportSetModel? {
        guard let user = XWHUserDataManager.getCurrentUser() else {
            return nil
        }
        
        return getSportSet(identifier: user.mobile)
    }
    
    class func saveCurrentSportSet(_ sportSet: XWHSportSetModel) {
        if sportSet.identifier.isEmpty {
            guard let user = XWHUserDataManager.getCurrentUser() else {
                return
            }
            
            sportSet.identifier = user.mobile
        }
        
        saveSportSet(sportSet)
    }
    
    class func saveSportSet(_ sportSet: XWHSportSetModel) {
        appDB.write { db in
            try sportSet.save(db)
        }
    }
    
    class func getSportSet(identifier: String) -> XWHSportSetModel? {
        appDB.read { db in
            try XWHSportSetModel.fetchOne(db, key: identifier)
        }
    }
    
    class func deleteSportSet(identifier: String) {
        appDB.write { db in
            try XWHSportSetModel.deleteOne(db, key: identifier)
        }
    }
    
    class func deleteSportSet(_ sportSet: XWHSportSetModel) {
        appDB.write { db in
            try sportSet.delete(db)
        }
    }
    
    class func deleteAllSportSet() {
        appDB.write { db in
            try XWHSportSetModel.deleteAll(db)
        }
    }
    
}
