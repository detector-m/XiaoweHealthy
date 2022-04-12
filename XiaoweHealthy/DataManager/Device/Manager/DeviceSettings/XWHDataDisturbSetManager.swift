//
//  XWHDataDisturbSetManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import GRDB


// MARK: - 勿扰模式设置数据管理
class XWHDataDisturbSetManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createDisturbSetTable(_ db: Database) throws {
        try db.create(table: XWHDisturbSetModel.databaseTableName, body: { t in
            t.column(XWHDisturbSetModel.Columns.identifier.name, .text).primaryKey()
            t.column(XWHDisturbSetModel.Columns.isOn.name, .boolean)
            
            t.column(XWHDisturbSetModel.Columns.beginTime.name, .text)
            t.column(XWHDisturbSetModel.Columns.endTime.name, .text)
            
            t.column(XWHDisturbSetModel.Columns.isVibrationOn.name, .boolean)
            t.column(XWHDisturbSetModel.Columns.isMessageOn.name, .boolean)
        })
    }
    
    class func saveDisturbSet(_ disturbSet: XWHDisturbSetModel) {
        appDB.write { db in
            try disturbSet.save(db)
        }
    }
    
    class func getDisturbSet(identifier: String) -> XWHDisturbSetModel? {
        appDB.read { db in
            try XWHDisturbSetModel.fetchOne(db, key: identifier)
        }
    }
    
    class func deleteDisturbSet(identifier: String) {
        appDB.write { db in
            try XWHDisturbSetModel.deleteOne(db, key: identifier)
        }
    }
    
    class func deleteDisturbSet(_ disturbSet: XWHDisturbSetModel) {
        appDB.write { db in
            try disturbSet.delete(db)
        }
    }
    
    class func deleteAllDisturbSet() {
        appDB.write { db in
            try XWHDisturbSetModel.deleteAll(db)
        }
    }
    
}
