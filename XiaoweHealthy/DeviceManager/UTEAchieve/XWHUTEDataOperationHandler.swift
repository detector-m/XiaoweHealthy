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
            let itemMax: CGFloat = 2

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
        guard let rawDic = rawData as? [AnyHashable: Any] else {
            return nil
        }
        
        log.info("心率原始数据: \(rawDic)")

        guard let heartArray = rawDic[kUTEQuery24HRMData] as? [UTEModelHRMData] else {
            return nil
        }
        log.debug(heartArray)
       return heartArray
    }
    
    /// 处理血氧数据
    func handleBloodOxygenData(_ rawData: Any?) -> Any? {
       
        guard let rawDic = rawData as? [AnyHashable: Any] else {
            return nil
        }
        
        log.info("血氧原始数据: \(rawDic)")
        guard let boArray = rawDic[kUTEQueryBloodOxygenData] as? [UTEModelBloodOxygenData] else {
            return nil
        }
        
        log.debug(boArray)
       return boArray
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
            let cTime = Date().string(withFormat: "yyyy-MM-dd-HH-mm")
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
        
        manager.setUTEOption(.syncAllBloodOxygenData)
        
        return true
    }
    
    ///
    
    
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
