//
//  XWHDataWeatherSetManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import GRDB


// MARK: - 天气设置数据管理
class XWHDataWeatherSetManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createWeatherSetTable(_ db: Database) throws {
        try db.create(table: XWHWeatherSetModel.databaseTableName, body: { t in
            t.column(XWHWeatherSetModel.Columns.identifier.name, .text).primaryKey()
            
            t.column(XWHWeatherSetModel.Columns.isOn.name, .boolean)
        })
    }
    
    class func saveWeatherSet(_ weatherSet: XWHWeatherSetModel) {
        appDB.write { db in
            try weatherSet.save(db)
        }
    }
    
    class func getWeatherSet(identifier: String) -> XWHWeatherSetModel? {
        appDB.read { db in
            try XWHWeatherSetModel.fetchOne(db, key: identifier)
        }
    }
    
    class func deleteWeatherSet(identifier: String) {
        appDB.write { db in
            try XWHWeatherSetModel.deleteOne(db, key: identifier)
        }
    }
    
    class func deleteWeatherSet(_ weatherSet: XWHWeatherSetModel) {
        appDB.write { db in
            try weatherSet.delete(db)
        }
    }
    
    class func deleteAllWeatherSet() {
        appDB.write { db in
            try XWHWeatherSetModel.deleteAll(db)
        }
    }
    
}
