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
        try createSportVoiceSpeechSetTable(db)
    }
    
}

// MARK: - SportSet
extension XWHSportDataManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createSportVoiceSpeechSetTable(_ db: Database) throws {
        try db.create(table: XWHSportVoiceSpeechSetModel.databaseTableName, body: { t in
            t.column(XWHSportVoiceSpeechSetModel.Columns.identifier.name, .text).primaryKey()

            t.column(XWHSportVoiceSpeechSetModel.Columns.isOn.name, .boolean)
            
            t.column(XWHSportVoiceSpeechSetModel.Columns.isDistanceOn.name, .boolean)
            t.column(XWHSportVoiceSpeechSetModel.Columns.isDurationOn.name, .boolean)
            t.column(XWHSportVoiceSpeechSetModel.Columns.isPaceOn.name, .boolean)
            t.column(XWHSportVoiceSpeechSetModel.Columns.isHeartOn.name, .boolean)
            
            t.column(XWHSportVoiceSpeechSetModel.Columns.timeInterval.name, .integer)
        })
    }
    
    class func getCurrentSportVoiceSpeechSet() -> XWHSportVoiceSpeechSetModel? {
        guard let user = XWHUserDataManager.getCurrentUser() else {
            return nil
        }
        
        return getSportVoiceSpeechSet(identifier: user.mobile)
    }
    
    class func saveCurrentSportVoiceSpeechSet(_ sportSet: XWHSportVoiceSpeechSetModel) {
        if sportSet.identifier.isEmpty {
            guard let user = XWHUserDataManager.getCurrentUser() else {
                return
            }
            
            sportSet.identifier = user.mobile
        }
        
        saveSportVoiceSpeechSet(sportSet)
    }
    
    class func saveSportVoiceSpeechSet(_ sportSet: XWHSportVoiceSpeechSetModel) {
        appDB.write { db in
            try sportSet.save(db)
        }
    }
    
    class func getSportVoiceSpeechSet(identifier: String) -> XWHSportVoiceSpeechSetModel? {
        appDB.read { db in
            try XWHSportVoiceSpeechSetModel.fetchOne(db, key: identifier)
        }
    }
    
    class func deleteSportVoiceSpeechSet(identifier: String) {
        appDB.write { db in
            try XWHSportVoiceSpeechSetModel.deleteOne(db, key: identifier)
        }
    }
    
    class func deleteSportVoiceSpeechSet(_ sportSet: XWHSportVoiceSpeechSetModel) {
        appDB.write { db in
            try sportSet.delete(db)
        }
    }
    
    class func deleteAllSportVoiceSpeechSet() {
        appDB.write { db in
            try XWHSportVoiceSpeechSetModel.deleteAll(db)
        }
    }
    
}
