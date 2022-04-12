//
//  XWHDataDeviceManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/9.
//

import Foundation
import GRDB


// MARK: - 设备数据管理

class XWHDataDeviceManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createTables(_ db: Database) throws {
        try createWatchTable(db)
        
        try createRaiseWristSetTable(db)

        try createNoticeSetTable(db)
        try createLongSitSetTable(db)
        
        try createBloodPressureSetTable(db)
        try createBloodOxygenSetTable(db)
        
        try createHeartSetTable(db)
        
        try createDisturbSetTable(db)
                
        try createWeatherSetTable(db)
    }
    
    class func test() {
//        let watch = XWHDevWatchModel()
//        watch.identifier = "AAAAAA"
//        watch.name = "hello1"
//        saveWatch(watch)
//
//        let watch2 = XWHDevWatchModel()
//        watch2.identifier = "ababab"
//        watch2.name = "1234567890"
//        saveWatch(watch2)
    }
    
}

// MARK: - Watch
extension XWHDataDeviceManager {

    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createWatchTable(_ db: Database) throws {
        try db.create(table: XWHDevWatchModel.databaseTableName) { t in
//            t.autoIncrementedPrimaryKey("id")
            t.column(XWHDevWatchModel.Columns.identifier.name, .text).notNull().primaryKey()
            t.column(XWHDevWatchModel.Columns.name.name, .text).notNull()
            t.column(XWHDevWatchModel.Columns.type.name, .text).notNull()
            t.column(XWHDevWatchModel.Columns.mac.name, .text).notNull()
            t.column(XWHDevWatchModel.Columns.version.name, .text).notNull()
            t.column(XWHDevWatchModel.Columns.battery.name, .integer).notNull()
            
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

// MARK: - RaiseWristSet
extension XWHDataDeviceManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createRaiseWristSetTable(_ db: Database) throws {
        try XWHDataRaiseWristSetManager.createRaiseWristSetTable(db)
    }
    
    class func saveRaiseWristSet(_ raiseWristSet: XWHRaiseWristSetModel) {
        XWHDataRaiseWristSetManager.saveRaiseWristSet(raiseWristSet)
    }
    
    class func getRaiseWristSet(identifier: String) -> XWHRaiseWristSetModel? {
        XWHDataRaiseWristSetManager.getRaiseWristSet(identifier: identifier)
    }
    
    class func deleteRaiseWristSet(identifier: String) {
        XWHDataRaiseWristSetManager.deleteRaiseWristSet(identifier: identifier)
    }
    
}

// MARK: - NoticeSet
extension XWHDataDeviceManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createNoticeSetTable(_ db: Database) throws {
        try XWHDataNoticeSetManager.createNoticeSetTable(db)
    }
    
    class func saveNoticeSet(_ noticeSet: XWHNoticeSetModel) {
        XWHDataNoticeSetManager.saveNoticeSet(noticeSet)
    }
    
    class func getNoticeSet(identifier: String) -> XWHNoticeSetModel? {
        XWHDataNoticeSetManager.getNoticeSet(identifier: identifier)
    }
    
    class func deleteNoticeSet(identifier: String) {
        XWHDataNoticeSetManager.deleteNoticeSet(identifier: identifier)
    }
    
}

// MARK: - LongSitSet
extension XWHDataDeviceManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createLongSitSetTable(_ db: Database) throws {
        try XWHDataLongSitSetManager.createLongSitSetTable(db)
    }
    
    class func saveLongSitSet(_ longSitSet: XWHLongSitSetModel) {
        XWHDataLongSitSetManager.saveLongSitSet(longSitSet)
    }
    
    class func getLongSitSet(identifier: String) -> XWHLongSitSetModel? {
        XWHDataLongSitSetManager.getLongSitSet(identifier: identifier)
    }
    
    class func deleteLongSitSet(identifier: String) {
        XWHDataLongSitSetManager.deleteLongSitSet(identifier: identifier)
    }
    
}

// MARK: - BloodPressureSet
extension XWHDataDeviceManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createBloodPressureSetTable(_ db: Database) throws {
        try XWHDataBloodPressureSetManager.createBloodPressureSetTable(db)
    }
    
    class func saveBloodPressureSet(_ bloodPressureSet: XWHBloodPressureSetModel) {
        XWHDataBloodPressureSetManager.saveBloodPressureSet(bloodPressureSet)
    }
    
    class func getBloodPressureSet(identifier: String) -> XWHBloodPressureSetModel? {
        XWHDataBloodPressureSetManager.getBloodPressureSet(identifier: identifier)
    }
    
    class func deleteBloodPressureSet(identifier: String) {
        XWHDataBloodPressureSetManager.deleteBloodPressureSet(identifier: identifier)
    }
    
}

// MARK: - BloodOxygenSet
extension XWHDataDeviceManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createBloodOxygenSetTable(_ db: Database) throws {
        try XWHDataBloodOxygenSetManager.createBloodOxygenSetTable(db)
    }
    
    class func saveBloodOxygenSet(_ bloodOxygenSet: XWHBloodOxygenSetModel) {
        XWHDataBloodOxygenSetManager.saveBloodOxygenSet(bloodOxygenSet)
    }
    
    class func getBloodPressureSet(identifier: String) -> XWHBloodOxygenSetModel? {
        XWHDataBloodOxygenSetManager.getBloodOxygenSet(identifier: identifier)
    }
    
    class func deleteBloodOxygenSet(identifier: String) {
        XWHDataBloodOxygenSetManager.deleteBloodOxygenSet(identifier: identifier)
    }
    
}


// MARK: - HeartSet
extension XWHDataDeviceManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createHeartSetTable(_ db: Database) throws {
        try XWHDataHeartSetManager.createHeartSetTable(db)
    }
    
    class func saveHeartSet(_ heartSet: XWHHeartSetModel) {
        XWHDataHeartSetManager.saveHeartSet(heartSet)
    }
    
    class func getHeartSet(identifier: String) -> XWHHeartSetModel? {
        XWHDataHeartSetManager.getHeartSet(identifier: identifier)
    }
    
    class func deleteHeartSet(identifier: String) {
        XWHDataHeartSetManager.deleteHeartSet(identifier: identifier)
    }
    
}

// MARK: - DisturbSet
extension XWHDataDeviceManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createDisturbSetTable(_ db: Database) throws {
        try XWHDataDisturbSetManager.createDisturbSetTable(db)
    }
    
    class func saveDisturbSet(_ disturbSet: XWHDisturbSetModel) {
        XWHDataDisturbSetManager.saveDisturbSet(disturbSet)
    }
    
    class func getDisturbSet(identifier: String) -> XWHDisturbSetModel? {
        XWHDataDisturbSetManager.getDisturbSet(identifier: identifier)
    }
    
    class func deleteDisturbSet(identifier: String) {
        XWHDataDisturbSetManager.deleteDisturbSet(identifier: identifier)
    }
    
}


// MARK: - WeatherSet
extension XWHDataDeviceManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createWeatherSetTable(_ db: Database) throws {
        try XWHDataWeatherSetManager.createWeatherSetTable(db)
    }
    
    class func saveWeatherSet(_ weatherSet: XWHWeatherSetModel) {
        XWHDataWeatherSetManager.saveWeatherSet(weatherSet)
    }
    
    class func getWeatherSet(identifier: String) -> XWHWeatherSetModel? {
        XWHDataWeatherSetManager.getWeatherSet(identifier: identifier)
    }
    
    class func deleteWeatherSet(identifier: String) {
        XWHDataWeatherSetManager.deleteWeatherSet(identifier: identifier)
    }
    
}
