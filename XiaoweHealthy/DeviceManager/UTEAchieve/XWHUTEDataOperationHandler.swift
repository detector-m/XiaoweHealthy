//
//  XWHUTEDataOperationHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/29.
//

import UIKit
import UTESmartBandApi


/// UTE 同步数据处理
class XWHUTEDataOperationHandler: XWHDevDataOperationProtocol, XWHInnerDataHandlerProtocol {
    
    let uteTimeFormat = "yyyy-MM-dd-HH-mm"
    
    private var progressHandler: DevSyncDataProgressHandler?
    private var resultHandler: XWHDevDataOperationHandler?
    
    /// 信号量同步处理
    private lazy var semaphore = DispatchSemaphore(value: 0)
    
    private var manager: UTESmartBandClient {
        return UTESmartBandClient.sharedInstance()
    }
    
    lazy var dataType: XWHDevSyncDataType = .none
    
    private var _state: XWHDevDataTransferState = .failed
    var state: XWHDevDataTransferState {
        return _state
    }
    
    func setDataOperation(progressHandler: DevSyncDataProgressHandler?, resultHandler: XWHDevDataOperationHandler?) {
        self.progressHandler = progressHandler
        self.resultHandler = resultHandler
    }
    
    func resetDataOperation() {
        progressHandler = nil
        resultHandler = nil
    }
    
    func syncData() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else {
                log.error("UTE - 该类被释放")
                return
            }
            
            if !self.isUTEConnectBind() {
                self.handleUTENotConnectBindError(type: .none)
                return
            }
            
            if self._state == .inTransit {
                return
            }
            
            self._state = .inTransit
            
            var cp = 0
            let itemMax: CGFloat = 3

            // 1
            if !self.syncHeart() {
                return
            }
            if self.semaphoreWait() {
                self.handleTimeoutError()
                return
            }
            cp = ((1 / itemMax) * 100).int
            self.handleProgress(cp)
            
            // 2
            if !self.syncBloodOxygen() {
                return
            }
            if self.semaphoreWait() {
                self.handleTimeoutError()
                return
            }
            cp = ((2 / itemMax) * 100).int
            self.handleProgress(cp)
            
            // 3
            if !self.syncSleep() {
                return
            }
            if self.semaphoreWait() {
                self.handleTimeoutError()
                return
            }
            cp = ((3 / itemMax) * 100).int
            self.handleProgress(cp)
            
            self._state = .succeed
        }
    }
    
    // MARK: - 数据处理
    @discardableResult
    func handleRawData(_ rawData: Any?, type: XWHDevSyncDataType) -> Any? {
        switch type {
        case .heart:
            return handleHeartData(rawData)
            
        case .bloodOxygen:
            return handleBloodOxygenData(rawData)
            
        case .sleep:
            return handleSleepData(rawData)
            
        case .none:
            return nil
        }
    }
    
    func handleError(_ error: Error?) {
        guard let nsError = error as NSError? else {
            return
        }
        
        if nsError.code == UTEErrorCode.disconnect, nsError.code == UTEErrorCode.syncTimeout {
            semaphoreSignal()
        }
    }
    
    /// UTE 处理数据方法
    func handleRawData(_ rawData: Any?, uteSyncState: UTEDevicesSate) {
        switch uteSyncState {
        case .syncSuccess:
            handleRawData(rawData, type: dataType)
            
        default:
            break
        }
        
        semaphoreSignal()
    }
    
    /// 处理心率数据
    func handleHeartData(_ rawData: Any?) -> Any? {
        guard let deviceSn = manager.connectedDevicesModel?.identifier else {
            log.error("未获取到设备标识符")
            return nil
        }
        guard let rawDic = rawData as? [AnyHashable: Any] else {
            return nil
        }

        guard let heartArray = rawDic[kUTEQuery24HRMData] as? [UTEModelHRMData] else {
            return nil
        }
        
        let parsedHeartArray: [XWHHeartModel] = heartArray.compactMap { cModel in
            guard let cTime = cModel.heartTime, let cValue = cModel.heartCount?.int, let cDate = cTime.date(withFormat: uteTimeFormat) else {
                return nil
            }
            
            let rModel = XWHHeartModel()
            rModel.time = cDate.string(withFormat: XWHDeviceHelper.standardTimeFormat)
            rModel.value = cValue
            rModel.identifier = deviceSn
            
            return rModel
        }
        log.info("同步心率的原始数据 \(parsedHeartArray)")
        if !parsedHeartArray.isEmpty {
            if let last = parsedHeartArray.last?.clone() {
                XWHHealthyDataManager.saveHeart(last)
            }
            
            XWHServerDataManager.postHeart(deviceSn: deviceSn, data: parsedHeartArray, failureHandler: nil, successHandler: nil)
        }
       return parsedHeartArray
    }
    
    /// 处理血氧数据
    func handleBloodOxygenData(_ rawData: Any?) -> Any? {
        guard let deviceSn = manager.connectedDevicesModel?.identifier else {
            log.error("未获取到设备标识符")
            return nil
        }
        
        guard let rawDic = rawData as? [AnyHashable: Any] else {
            return nil
        }
        
        guard let boArray = rawDic[kUTEQueryBloodOxygenData] as? [UTEModelBloodOxygenData] else {
            return nil
        }
        
        let parsedboArray: [XWHBloodOxygenModel] = boArray.compactMap { cModel in
            guard let cTime = cModel.time, let cDate = cTime.date(withFormat: uteTimeFormat) else {
                return nil
            }
            
            let rModel = XWHBloodOxygenModel()
            rModel.time = cDate.string(withFormat: XWHDeviceHelper.standardTimeFormat)
            rModel.value = cModel.value
            rModel.identifier = deviceSn
            
            return rModel
        }
        
        log.info("同步血氧的原始数据 \(parsedboArray)")
        if !parsedboArray.isEmpty {
            if let last = parsedboArray.last?.clone() {
                XWHHealthyDataManager.saveBloodOxygen(last)
            }
            
            XWHServerDataManager.postBloodOxygen(deviceSn: deviceSn, data: parsedboArray, failureHandler: nil, successHandler: nil)
        }
        
       return parsedboArray
    }
    
    /// 处理睡眠数据
    func handleSleepData(_ rawData: Any?) -> Any? {
        guard let deviceSn = manager.connectedDevicesModel?.identifier else {
            log.error("未获取到设备标识符")
            return nil
        }
        
        guard let rawDic = rawData as? [AnyHashable: Any] else {
            return nil
        }
        
        guard let sleepArray = rawDic[kUTEQuerySleepDataDayByDay] as? [[UTEModelSleepData]] else {
            return nil
        }
        
//        guard let sleepArray = rawDic[kUTEQuerySleepData] as? [UTEModelSleepData] else {
//            return nil
//        }
        
        var parsedSleepArray: [XWHSleepModel] = []
        for iArray in sleepArray {
            if iArray.isEmpty {
                continue
            }
            
            guard let uteETime = iArray.last?.endTime, let eDate = uteETime.date(withFormat: uteTimeFormat) else {
                log.error("解析睡眠数据错误 uteETime")
                continue
            }
            guard let uteBTime = iArray.first?.startTime, let bDate = uteBTime.date(withFormat: uteTimeFormat) else {
                log.error("解析睡眠数据错误 uteBTime")

                continue
            }
            
            let items: [XWHSleepItemModel] = iArray.compactMap { cModel in
                guard let rETime = cModel.endTime, let rEDate = rETime.date(withFormat: uteTimeFormat) else {
                    log.error("解析睡眠数据错误 rETime")
                    return nil
                }
                guard let rBTime = cModel.startTime, let rBDate = rBTime.date(withFormat: uteTimeFormat) else {
                    log.error("解析睡眠数据错误 rBTime")
                    return nil
                }
                
                let cDuration = rEDate.minutesSince(rBDate).int
//                if cDuration == 0 {
//                    log.error("解析睡眠数据错误 cDuration")
//                }
                
                let rModel = XWHSleepItemModel()
                
                rModel.duration = cDuration
                rModel.bTime = rBDate.string(withFormat: XWHDeviceHelper.standardTimeFormat)
                rModel.eTime = rEDate.string(withFormat: XWHDeviceHelper.standardTimeFormat)
                rModel.identifier = deviceSn
                if cModel.sleepType == .awake {
                    rModel.type = 2
                } else if cModel.sleepType == .lightSleep {
                    rModel.type = 1
                } else {
                    rModel.type = 0
                }
                return rModel
            }
            
            if items.isEmpty {
                continue
            }
            
            let eTime = eDate.string(withFormat: XWHDeviceHelper.standardTimeFormat)
            let bTime = bDate.string(withFormat: XWHDeviceHelper.standardTimeFormat)
            
            let sModel = XWHSleepModel()

            sModel.time = eDate.string(withFormat: XWHDeviceHelper.sleepCollectionTimeFormat)
            sModel.bTime = bTime
            sModel.eTime = eTime
            sModel.identifier = deviceSn
            
            sModel.duration = items.sum(for: \.duration)
            sModel.deepSleepDuration = items.filter({ $0.type == 0 }).sum(for: \.duration)
            sModel.lightSleepDuration = items.filter({ $0.type == 1 }).sum(for: \.duration)
            
            let cAwakeItems = items.filter({ $0.type == 2 })
            sModel.awakeTimes = cAwakeItems.count
            sModel.awakeDuration = cAwakeItems.sum(for: \.duration)
            
            sModel.items = items
            
            // 晚睡
            sModel.type = 1
            
            parsedSleepArray.append(sModel)
        }
        
        log.info("同步睡眠的原始数据 \(parsedSleepArray)")
        if !parsedSleepArray.isEmpty {
//            if let last = parsedSleepArray.last?.clone() {
//                XWHHealthyDataManager.saveBloodOxygen(last)
//            }

            XWHServerDataManager.postSleep(deviceSn: deviceSn, data: parsedSleepArray, failureHandler: nil, successHandler: nil)
        }
        
       return parsedSleepArray
    }
    
    private func handleProgress(_ cp: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.progressHandler?(cp)
        }
    }
    
    private func handleResult(_ syncType: XWHDevSyncDataType, _ syncState: XWHDevDataTransferState, _ result: Result<XWHResponse?, XWHError>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {
                return
            }
            
            self.resultHandler?(syncType, syncState, result)
        }
    }
    
    private func handleTimeoutError() {
        var msg = ""
        switch dataType {
        case .none:
            break
            
        case .heart:
            msg = "同步心率超时"
            
        case .bloodOxygen:
            msg = "同步血氧超时"
            
        case .sleep:
            msg = "同步睡眠超时"
        }
        
        let error = XWHError(message: msg)
        log.error(error)
        
        handleResult(dataType, .failed, .failure(error))
    }

}

// MARK: - 信号量处理
extension XWHUTEDataOperationHandler {
    
    /// 返回是否超时
    private func semaphoreWait() -> Bool {
        let to: DispatchTime = .now() + 60
        
        let semaResult = semaphore.wait(timeout: to)
        if semaResult == .timedOut {
            return true
        }
        
        return false
    }
    
    /// 发送信号
    private func semaphoreSignal() {
        semaphore.signal()
    }
}

// MARK: - UTE 同步数据
extension XWHUTEDataOperationHandler {
    
    /// 同步心率数据
    private func syncHeart() -> Bool {
        dataType = .heart
        guard let conDev = manager.connectedDevicesModel else {
            handleUTENotConnectBindError(type: dataType)
            
            dataType = .none
            return false
        }
        
        if conDev.isHasDataStatus {
//            let cTime = Date().string(withFormat: "yyyy-MM-dd-HH-mm")
            let cTime = "2020-06-06-06-06"
            manager.syncDataCustomTime(cTime, type: .HRM24)
        } else {
            manager.setUTEOption(.syncAllHRMData)
        }
        
        return true
    }
    
    /// 同步血氧数据
    private func syncBloodOxygen() -> Bool {
        dataType = .bloodOxygen
        guard let conDev = manager.connectedDevicesModel else {
            handleUTENotConnectBindError(type: dataType)
            
            dataType = .none
            return false
        }
        
        if !conDev.isHasBloodOxygen {
            log.error("UTE - 该设备不支持血氧功能")
            resultHandler?(dataType, .failed, .failure(XWHError(message: "该设备不支持血氧功能")))
            
            dataType = .none
            return false
        }
        
        if conDev.isHasDataStatus {
            let cTime = "2020-06-06-06-06"
            manager.syncDataCustomTime(cTime, type: .bloodOxygen)
        } else {
            manager.setUTEOption(.syncAllBloodOxygenData)
        }
        
        return true
    }
    
    /// 同步睡眠
    private func syncSleep() -> Bool {
        dataType = .sleep
        guard let conDev = manager.connectedDevicesModel else {
            handleUTENotConnectBindError(type: dataType)
            
            dataType = .none
            return false
        }
        
        if conDev.isHasDataStatus {
            let cTime = "2020-06-06-06-06"
            manager.syncDataCustomTime(cTime, type: .sleep)
        } else {
            manager.setUTEOption(.syncAllSleepData)
        }
                
        return true
    }
    
    /// 同步精神状态数据 （压力、情绪、疲劳度数据）
//    private func syncMentalState() -> Bool {
//        dataType = .sleep
//        guard let conDev = manager.connectedDevicesModel else {
//            handleUTENotConnectBindError(type: dataType)
//
//            dataType = .none
//            return false
//        }
//
//        if conDev.isHasDataStatus {
//            let cTime = "2020-06-06-06-06"
//            manager.syncDataCustomTime(cTime, type: .sleep)
//        } else {
//            manager.setUTEOption(.syncAllSleepData)
//        }
//
//        return true
//    }
    
    
    private func isUTEConnectBind() -> Bool {
        if let _ = manager.connectedDevicesModel {
            return true
        }
        
        return false
    }
    
    private func checkUTEConnectBind(type: XWHDevSyncDataType) -> Bool {
        if isUTEConnectBind() {
            return true
        }
        
        handleUTENotConnectBindError(type: type)
        
        return false
    }
    
    private func handleUTENotConnectBindError(type: XWHDevSyncDataType) {
        let error = XWHError(message: "未连接绑定")
        log.error(error)
        handleResult(type, .failed, .failure(error))
    }
    
}
