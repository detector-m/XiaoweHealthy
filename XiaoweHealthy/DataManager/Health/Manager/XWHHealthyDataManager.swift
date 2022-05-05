//
//  XWHHealthyDataManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/28.
//

import Foundation
import GRDB


class XWHHealthyDataManager {
    
    private static let dateFormat: String = "yyyy-MM-dd HH:mm:ss"
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createTables(_ db: Database) throws {
        try createHeartTable(db)
        try createBloodOxygenTable(db)
    }
    
    class func removeCurrent() {
        guard let cId = XWHDataDeviceManager.getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")
            
            return
        }
        
        remove(identifier: cId)
    }
    class func remove(identifier: String) {
        log.info("移除健康数据 identifier = \(identifier)")
        
        deleteHeart(identifier: identifier)
        deleteBloodOxygen(identifier: identifier)
    }
    
    class func getCurrentHeart() -> XWHHeartModel? {
//        guard let cId = XWHDataDeviceManager.getCurrentDeviceIdentifier() else {
//            log.error("当前不存在设备")
//
//            return nil
//        }
        
        let cId = XWHHealthyMainVC.testDeviceSn()
        
        return getLastHeart(identifier: cId)
    }
    
    class func getCurrentBloodOxygen() -> XWHHeartModel? {
//        guard let cId = XWHDataDeviceManager.getCurrentDeviceIdentifier() else {
//            log.error("当前不存在设备")
//
//            return nil
//        }
        
        let cId = XWHHealthyMainVC.testDeviceSn()
        
        return getLastBloodOxygen(identifier: cId)
    }
    
}


// MARK: - Heart
extension XWHHealthyDataManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createHeartTable(_ db: Database) throws {
        try db.create(table: XWHHeartModel.databaseTableName, body: { t in
            t.column(XWHHeartModel.Columns.identifier.name, .text)

            t.column(XWHHeartModel.Columns.time.name, .text)
            t.column(XWHHeartModel.Columns.value.name, .integer)
            
            t.primaryKey([XWHBloodOxygenModel.Columns.identifier.name, XWHBloodOxygenModel.Columns.time.name])
        })
    }
    
    class func saveHearts(_ hearts: [XWHHeartModel]) {
        appDB.write { db in
            try hearts.forEach({ try $0.save(db) })
        }
    }
   
    class func saveHeart(_ heart: XWHHeartModel) {
        saveHearts([heart])
    }
    
    class func getHearts(identifier: String, bDate: Date, eDate: Date) -> [XWHHeartModel]? {
        appDB.read { db in
            let sDateString = bDate.string(withFormat: dateFormat)
            let eDateString = eDate.string(withFormat: dateFormat)
            return try XWHHeartModel.filter(XWHBloodOxygenModel.Columns.identifier == identifier && XWHHeartModel.Columns.time >= sDateString && XWHHeartModel.Columns.time <= eDateString).fetchAll(db)
        }
    }
    
    class func getLastHeart(identifier: String) -> XWHHeartModel? {
        appDB.read { db in
            try XWHHeartModel.filter(XWHHeartModel.Columns.identifier == identifier).order(XWHHeartModel.Columns.time.desc).fetchOne(db)
        }
    }
    
    class func deleteHeart(identifier: String) {
        appDB.write { db in
            try XWHHeartModel.filter(XWHHeartModel.Columns.identifier == identifier).deleteAll(db)
        }
    }
    
    class func deleteHeart(_ heart: XWHHeartModel) {
        appDB.write { db in
            try heart.delete(db)
        }
    }
    
    class func deleteAllHeart() {
        appDB.write { db in
            try XWHHeartModel.deleteAll(db)
        }
    }
    
}


// MARK: - BloodOxygen
extension XWHHealthyDataManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createBloodOxygenTable(_ db: Database) throws {
        try db.create(table: XWHBloodOxygenModel.databaseTableName, body: { t in
            t.column(XWHBloodOxygenModel.Columns.identifier.name, .text)

            t.column(XWHBloodOxygenModel.Columns.time.name, .text)
            t.column(XWHBloodOxygenModel.Columns.value.name, .integer)
            
            t.primaryKey([XWHBloodOxygenModel.Columns.identifier.name, XWHBloodOxygenModel.Columns.time.name])
        })
    }
    
    class func saveBloodOxygens(_ bloodOxygens: [XWHBloodOxygenModel]) {
        appDB.write { db in
            try bloodOxygens.forEach({ try $0.save(db) })
        }
    }
   
    class func saveBloodOxygen(_ bloodOxygen: XWHBloodOxygenModel) {
        saveBloodOxygens([bloodOxygen])
    }
    
    class func getBloodOxygens(identifier: String, bDate: Date, eDate: Date) -> [XWHBloodOxygenModel]? {
        appDB.read { db in
            let sDateString = bDate.string(withFormat: dateFormat)
            let eDateString = eDate.string(withFormat: dateFormat)
            return try XWHBloodOxygenModel.filter(XWHBloodOxygenModel.Columns.identifier == identifier && XWHBloodOxygenModel.Columns.time >= sDateString && XWHBloodOxygenModel.Columns.time <= eDateString).fetchAll(db)
        }
    }
    
    class func getLastBloodOxygen(identifier: String) -> XWHBloodOxygenModel? {
        appDB.read { db in
            try XWHBloodOxygenModel.filter(XWHBloodOxygenModel.Columns.identifier == identifier).order(XWHBloodOxygenModel.Columns.time.desc).fetchOne(db)
        }
    }
    
    class func deleteBloodOxygen(identifier: String) {
        appDB.write { db in
            try XWHBloodOxygenModel.filter(XWHBloodOxygenModel.Columns.identifier == identifier).deleteAll(db)
        }
    }
    
    class func deleteBloodOxygen(_ bloodOxygen: XWHBloodOxygenModel) {
        appDB.write { db in
            try bloodOxygen.delete(db)
        }
    }
    
    class func deleteAllBloodOxygen() {
        appDB.write { db in
            try XWHBloodOxygenModel.deleteAll(db)
        }
    }
    
}
