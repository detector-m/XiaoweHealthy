//
//  XWHDataBloodPressureSetManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import GRDB

// MARK: - 血压设置数据管理
class XWHDataBloodPressureSetManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createBloodPressureSetTable(_ db: Database) throws {
//        try db.create(table: XWHBloodPressureSetModel.databaseTableName, body: { t in
//            t.column(XWHWeatherSetModel.Columns.identifier.name, .text).primaryKey()
//
//            t.column(XWHBloodPressureSetModel.Columns.isOn.name, .boolean)
//            t.column(XWHBloodPressureSetModel.Columns.isOnCall.name, .boolean)
//            t.column(XWHBloodPressureSetModel.Columns.isOnSms.name, .boolean)
//            t.column(XWHBloodPressureSetModel.Columns.isOnWeChat.name, .boolean)
//            t.column(XWHBloodPressureSetModel.Columns.isOnQQ.name, .boolean)
//        })
    }
    
    class func saveBloodPressureSet(_ bloodPressureSet: XWHBloodPressureSetModel) {
        appDB.write { db in
            try bloodPressureSet.save(db)
        }
    }
    
    class func getBloodPressureSet(identifier: String) -> XWHBloodPressureSetModel? {
        appDB.read { db in
//            try XWHBloodPressureSetModel.filter(XWHBloodPressureSetModel.Columns.identifier == identifier).fetchOne(db)
            try XWHBloodPressureSetModel.fetchOne(db, key: identifier)
        }
    }
    
    class func deleteBloodPressureSet(identifier: String) {
        appDB.write { db in
            try XWHBloodPressureSetModel.deleteOne(db, key: identifier)
        }
    }
    
    class func deleteBloodPressureSet(_ bloodPressureSet: XWHBloodPressureSetModel) {
        appDB.write { db in
//            try XWHDevWatchModel.deleteOne(db, key: devWatch.identifier)
            try bloodPressureSet.delete(db)
        }
    }
    
    class func deleteAllBloodPressureSet() {
        appDB.write { db in
            try XWHBloodPressureSetModel.deleteAll(db)
        }
    }
    
}

