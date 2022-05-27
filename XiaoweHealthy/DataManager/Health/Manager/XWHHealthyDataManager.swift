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
        
        try createMentalStateTable(db)
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
        guard let cId = XWHDataDeviceManager.getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")

            return nil
        }
        
        return getLastHeart(identifier: cId)
    }
    
    class func getCurrentBloodOxygen() -> XWHHeartModel? {
        guard let cId = XWHDataDeviceManager.getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")

            return nil
        }
        
        return getLastBloodOxygen(identifier: cId)
    }
    
    class func getCurrentMentalState() -> XWHMentalStateModel? {
        guard let cId = XWHDataDeviceManager.getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")

            return nil
        }
        
        return getLastMentalState(identifier: cId)
    }
    
}


// MARK: - Heart
extension XWHHealthyDataManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createHeartTable(_ db: Database) throws {
        try db.create(table: XWHHeartModel.databaseTableName, body: { t in
            t.column(XWHHeartModel.Columns.identifier.name, .text)

            t.column(XWHHeartModel.Columns.mac.name, .text)

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

            t.column(XWHHeartModel.Columns.mac.name, .text)

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

// MARK: - MentalState(精神状态 - 压力、情绪、疲劳度数据)
extension XWHHealthyDataManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createMentalStateTable(_ db: Database) throws {
        try db.create(table: XWHMentalStateModel.databaseTableName, body: { t in
            t.column(XWHMentalStateModel.Columns.identifier.name, .text)
            
            t.column(XWHMentalStateModel.Columns.mac.name, .text)

            t.column(XWHMentalStateModel.Columns.time.name, .text)
            t.column(XWHMentalStateModel.Columns.mood.name, .integer)
            t.column(XWHMentalStateModel.Columns.fatigue.name, .integer)
            t.column(XWHMentalStateModel.Columns.stress.name, .integer)
            
            t.primaryKey([XWHMentalStateModel.Columns.identifier.name, XWHMentalStateModel.Columns.time.name])
        })
    }
    
    class func saveMentalStates(_ mentalStates: [XWHMentalStateModel]) {
        appDB.write { db in
            try mentalStates.forEach({ try $0.save(db) })
        }
    }
   
    class func saveMentalState(_ mentalState: XWHMentalStateModel) {
        saveMentalStates([mentalState])
    }
    
    class func getMentalStates(identifier: String, bDate: Date, eDate: Date) -> [XWHMentalStateModel]? {
        appDB.read { db in
            let sDateString = bDate.string(withFormat: dateFormat)
            let eDateString = eDate.string(withFormat: dateFormat)
            return try XWHMentalStateModel.filter(XWHMentalStateModel.Columns.identifier == identifier && XWHMentalStateModel.Columns.time >= sDateString && XWHMentalStateModel.Columns.time <= eDateString).fetchAll(db)
        }
    }
    
    class func getLastMentalState(identifier: String) -> XWHMentalStateModel? {
        appDB.read { db in
            try XWHMentalStateModel.filter(XWHMentalStateModel.Columns.identifier == identifier).order(XWHMentalStateModel.Columns.time.desc).fetchOne(db)
        }
    }
    
    class func deleteMentalState(identifier: String) {
        appDB.write { db in
            try XWHMentalStateModel.filter(XWHMentalStateModel.Columns.identifier == identifier).deleteAll(db)
        }
    }
    
    class func deleteMentalState(_ mentalState: XWHMentalStateModel) {
        appDB.write { db in
            try mentalState.delete(db)
        }
    }
    
    class func deleteAllMentalState() {
        appDB.write { db in
            try XWHMentalStateModel.deleteAll(db)
        }
    }
    
}
