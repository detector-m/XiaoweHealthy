//
//  XWHDataDeviceManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/9.
//

import Foundation
import GRDB


let ddManager = XWHDataDeviceManager.self

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
        
        try createContactTable(db)
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

// MARK: - 设备（Device）
extension XWHDataDeviceManager {
    
    /// 设置当前设备
    /// - Parameters:
    ///     - device: 设备信息
    class func setCurrent(device: XWHDeviceBaseModel) {
        log.info("设置当前设备")
        
        switch device.category {
        case .none:
            log.error("未知设备")
            return
            
        case .watch:
            guard let watch = device as? XWHDevWatchModel else {
                log.error("该设备非手表设备 device = \(device)")
                return
            }
            
            setCurrentWatch(watch)
        }
    }
    
    private class func setCurrentWatch(_ watch: XWHDevWatchModel) {
        watch.bindDate = Date().string(withFormat: "yyyy-MM-dd HH:mm:ss")
        watch.isCurrent = true
        
        let oldWatch = getWatch(identifier: watch.identifier)
    
        saveWatch(watch)
        
        if oldWatch == nil {
            initDeviceSets(identifier: watch.identifier)
        }
    }
    
    /// 移除当前设备
    /// - Parameters:
    ///     - device: 设备信息
    class func remove(device: XWHDeviceBaseModel) {
        log.info("移除当前设备")
        
        switch device.category {
        case .none:
            log.error("未知设备")
            return
            
        case .watch:
            guard let watch = device as? XWHDevWatchModel else {
                log.error("该设备非手表设备 device = \(device)")
                return
            }
            
            removeWatch(watch)
        }
    }
    
    private class func removeWatch(_ watch: XWHDevWatchModel) {
        guard let _ = getWatch(identifier: watch.identifier) else {
            log.error("该手表不存在数据库中")
            return
        }
    
        deinitDeviceSets(identifier: watch.identifier)
        deleteContacts(identifier: watch.identifier)
        deleteWatch(identifier: watch.identifier)
    }
    
    class func getCurrentDevice() -> XWHDevWatchModel? {
        XWHDataWatchManager.getCurrentWatch()
    }
    
    class func getCurrentDeviceIdentifier() -> String? {
        return getCurrentWatch()?.identifier
    }
    
    // WristSet
    class func getCurrentRaiseWristSet() -> XWHRaiseWristSetModel? {
        guard let cId = getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")
            return nil
        }
        
       return getRaiseWristSet(identifier: cId)
    }
    
    // NoticeSet
    class func getCurrentNoticeSet() -> XWHNoticeSetModel? {
        guard let cId = getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")
            return nil
        }
        
        guard let noticeSet = getNoticeSet(identifier: cId) else {
            log.error("当前不存在 noticeSet")

            return nil
        }
        
       return noticeSet
    }
    
    // LongSitSet
    class func getCurrentLongSitSet() -> XWHLongSitSetModel? {
        guard let cId = getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")
            return nil
        }
        
        guard let longSitSet = getLongSitSet(identifier: cId) else {
            log.error("当前不存在 longSitSet")
            return nil
        }
        
       return longSitSet
    }
    
    // BloodPressureSet
    class func getCurrentBloodPressureSet() -> XWHBloodPressureSetModel? {
        guard let cId = getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")
            return nil
        }
        
        guard let bpSet = getBloodPressureSet(identifier: cId) else {
            log.error("当前不存在 bloodPressureSet")
            return nil
        }
        
       return bpSet
    }
    
    // BloodOxygenSet
    class func getCurrentBloodOxygenSet() -> XWHBloodOxygenSetModel? {
        guard let cId = getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")
            return nil
        }
        
        guard let boSet = getBloodOxygenSet(identifier: cId) else {
            log.error("当前不存在 bloodOxygenSet")

            return nil
        }
        
       return boSet
    }
    
    // HeartSet
    class func getCurrentHeartSet() -> XWHHeartSetModel? {
        guard let cId = getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")
            return nil
        }
        
        guard let heartSet = getHeartSet(identifier: cId) else {
            log.error("当前不存在 heartSet")

            return nil
        }
        
       return heartSet
    }
    
    // DisturbSet
    class func getCurrentDisturbSet() -> XWHDisturbSetModel? {
        guard let cId = getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")
            return nil
        }
        
        guard let disturbSet = getDisturbSet(identifier: cId) else {
            log.error("当前不存在 disturbSet")

            return nil
        }
        
        return disturbSet
    }
    
    // WeatherSet
    class func getCurrentWeatherSet() -> XWHWeatherSetModel? {
        guard let cId = getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")
            return nil
        }
        
        guard let weatherSet = getWeatherSet(identifier: cId) else {
            log.error("当前不存在 weatherSet")

            return nil
        }
        
        return weatherSet
    }
    
    // Contact
    class func getCurrentContacts() -> [XWHDevContactModel]? {
        guard let cId = getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")
            return nil
        }
        
        guard let contacts = getContacts(identifier: cId) else {
            log.error("当前不存在 contacts")

            return nil
        }
        
        return contacts
    }
    
    class func saveCurrentContacts(_ contacts: [XWHDevContactModel]) {
        guard let cId = getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")
            return
        }
        
        contacts.forEach({ $0.identifier = cId })
        
        saveContacts(contacts)
    }
    
    class func deleteCurrentContacts() {
        guard let cId = getCurrentDeviceIdentifier() else {
            log.error("当前不存在设备")
            return
        }
        
        deleteContacts(identifier: cId)
    }
    
}

// MARK: - 手表 （Watch）
extension XWHDataDeviceManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createWatchTable(_ db: Database) throws {
        try XWHDataWatchManager.createWatchTable(db)
    }
    
    class func saveWatch(_ watch: XWHDevWatchModel) {
        XWHDataWatchManager.saveWatch(watch)
    }
    
    class func getWatch(identifier: String) -> XWHDevWatchModel? {
        XWHDataWatchManager.getWatch(identifier: identifier)
    }
    
    private class func deleteWatch(identifier: String) {
        XWHDataWatchManager.deleteWatch(identifier: identifier)
    }
    
    class func getCurrentWatch() -> XWHDevWatchModel? {
        XWHDataWatchManager.getCurrentWatch()
    }
    
    class func getCurrentWatchIdentifier() -> String? {
        return getCurrentWatch()?.identifier
    }
    
}

// MARK: - Device Settings (Device Sets)
extension XWHDataDeviceManager {
    
    /// 初始化设备设置项
    /// - Parameters:
    ///     - identifier: 标识符
    class func initDeviceSets(identifier: String) {
        // RaiseWristSet
        let raiseWristSet = XWHRaiseWristSetModel(identifier)
        saveRaiseWristSet(raiseWristSet)

        // NoticeSet
        let noticeSet = XWHNoticeSetModel(identifier)
        saveNoticeSet(noticeSet)
        
        // LongSitSet
        let longSitSet = XWHLongSitSetModel(identifier)
        saveLongSitSet(longSitSet)
        
        // BloodPressureSet
        let bloodPressureSet = XWHBloodPressureSetModel(identifier)
        saveBloodPressureSet(bloodPressureSet)
        
        // BloodOxygenSet
        let bloodOxygenSet = XWHBloodOxygenSetModel(identifier)
        saveBloodOxygenSet(bloodOxygenSet)
        
        // HeartSet
        let heartSet = XWHHeartSetModel(identifier)
        saveHeartSet(heartSet)
        
        // DisturbSet
        let disturbSet = XWHDisturbSetModel(identifier)
        saveDisturbSet(disturbSet)
        
        // WeatherSet
        let weatherSet = XWHWeatherSetModel(identifier)
        saveWeatherSet(weatherSet)
    }
    
    /// 删除(析构)设备设置项
    /// - Parameters:
    ///     - identifier: 标识符
    class func deinitDeviceSets(identifier: String) {
        // RaiseWristSet
        deleteRaiseWristSet(identifier: identifier)

        // NoticeSet
        deleteNoticeSet(identifier: identifier)
        
        // LongSitSet
        deleteLongSitSet(identifier: identifier)
        
        // BloodPressureSet
        deleteBloodPressureSet(identifier: identifier)
        
        // BloodOxygenSet
        deleteBloodOxygenSet(identifier: identifier)
        
        // HeartSet
        deleteHeartSet(identifier: identifier)
        
        // DisturbSet
        deleteDisturbSet(identifier: identifier)
        
        // WeatherSet
        deleteWeatherSet(identifier: identifier)
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
    
    class func getBloodOxygenSet(identifier: String) -> XWHBloodOxygenSetModel? {
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


// MARK: - Contact
extension XWHDataDeviceManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createContactTable(_ db: Database) throws {
        try XWHDataContactManager.createContactTable(db)
    }
    
    class func saveContacts(_ contacts: [XWHDevContactModel]) {
        XWHDataContactManager.saveContacts(contacts)
    }

    class func getContacts(identifier: String) -> [XWHDevContactModel]? {
        XWHDataContactManager.getContacts(identifier: identifier)
    }
    
    class func deleteContacts(identifier: String) {
        XWHDataContactManager.deleteContacts(identifier: identifier)
    }
    
    class func saveContact(_ contact: XWHDevContactModel) {
        XWHDataContactManager.saveContact(contact)
    }
    
    class func deleteContact(_ contact: XWHDevContactModel) {
        XWHDataContactManager.deleteContact(contact)
    }
    
//    class func deleteAllContacts() {
//        XWHDataContactManager.deleteAllContacts()
//    }
    
}
