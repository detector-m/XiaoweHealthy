//
//  XWHDevice.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import Foundation


/// 业务层设备模块
class XWHDevice {
    
    private static var _shared = XWHDevice.init()
    static var shared: XWHDevice {
        return _shared
    }
    
    private var observers: [XWHDeviceObserverProtocol] = []
    
    private init() {
        
    }
    
    func addObserver(observer: XWHDeviceObserverProtocol) {
            observers.append(observer)
        }
        
    func removeObserver(observer: XWHDeviceObserverProtocol) {
        observers.removeFirst(where: { $0 === observer })
    }
    
    func notifyAllObserverUpdateConnectBindState() {
        for observer in observers {
            observer.updateDeviceConnectBind()
        }
    }

    func notifyAllObserverUpdateSyncState(_ state: XWHDevDataTransferState) {
        for observer in observers {
            observer.updateSyncState(state)
        }
    }
    
//    func notifyAllObservers() {
//        for observer in observers {
//            observer.updateDeviceConnectBind()
//        }
//    }
    
}

// MARK: - 设备
extension XWHDevice {
    
    var isConnectBind: Bool {
        return XWHDDMShared.connectBindState == .paired
    }
    
    func config() {
        XWHDDMShared.bleStateHandler = { [weak self] state in
//            log.info("蓝牙状态 state = \(state.string)")
            if state.isOpen {
                self?.connect()
            }
        }
        
        XWHDDMShared.setMonitorHandler(device: nil) { [weak self] _, _ in
            self?.notifyAllObserverUpdateConnectBindState()
        }
        if let connWatch = XWHDeviceDataManager.getCurrentWatch() {
            XWHDDMShared.config(device: connWatch)
        }
    }

    func connect() {
        guard XWHDDMShared.connectBindState == .disconnected else {
            return
        }
        
        reconnect()
    }

    private func reconnect() {
        guard let connWatch = XWHDeviceDataManager.getCurrentWatch() else {
            return
        }
        
        XWHDDMShared.config(device: connWatch)
        XWHDDMShared.reconnect(device: connWatch) { [weak self] (result: Result<XWHDeviceConnectBindState, XWHBLEError>) in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let connBindState):
                if connBindState == .paired {
                    self.updateDeviceInfo {
                        self.syncData()
                    }
                } else {
                    log.error("重连设备失败")
                }

            case .failure(_):
                log.error("重连设备失败")
            }
        }
    }

    func updateDeviceInfo(completion: (() -> Void)?) {
        XWHDDMShared.getDeviceInfo { result in
            switch result {
            case .success(let cModel):
                if let connModel = cModel?.data as? XWHDevWatchModel, let curModel = XWHDeviceDataManager.getCurrentWatch() {
                    connModel.isCurrent = curModel.isCurrent
                    connModel.type = curModel.type
                    connModel.category = curModel.category
                    XWHDeviceDataManager.setCurrent(device: connModel)
                }
                
                completion?()
//                self?.syncData()

            case .failure(let error):
                log.error(error)
            }
        }
    }
    
    var isSyncing: Bool {
        return XWHDDMShared.state == .inTransit
    }
    
    func syncData() {
        if !isConnectBind {
            return
        }
        
        guard let devModel = XWHDeviceDataManager.getCurrentWatch() else {
            return
        }
        
        XWHDDMShared.config(device: devModel)
        
        XWHDDMShared.setDataOperation { cp in
            log.debug("同步进度 = \(cp)")
        } resultHandler: { [weak self] (syncType, syncState, result: Result<XWHResponse?, XWHError>) in
            
            if syncState == .succeed {
                log.debug("数据同步成功")
            } else if syncState == .failed {
                switch result {
                case .success(_):
                    return
                    
                case .failure(let error):
                    log.error("数据同步失败 error = \(error)")
//                    self?.view.makeInsetToast(error.message)
                }
            }
            
            self?.notifyAllObserverUpdateSyncState(syncState)
        }

        XWHDDMShared.syncData()
        notifyAllObserverUpdateSyncState(.inTransit)
    }

}


// MARK: - UI
extension XWHDevice {
    
    class func gotoHelp(at targetVC: UIViewController) {
//        XWHSafari.present(at: targetVC, urlStr: kRedirectURL)
        
        let vc = XWHDeviceConnectBindHelpTBVC()
        targetVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    class func getRootVC() -> UIViewController {
        if XWHUser.isLogined, let _ = XWHDeviceDataManager.getCurrentWatch() {
            return XWHDeviceMainVC()
        }
        
        return XWHAddDeviceEntryVC()
    }
    
    static var isDevConnectBind: Bool {
        Self.shared.isConnectBind
    }
    
    // 心率设置
    class func gotoDevSetHeart(at targetVC: UIViewController) {
        if !isDevConnectBind {
            targetVC.view.makeInsetToast(R.string.xwhDeviceText.设备未连接())
            return
        }
        let vc = XWHDevSetHeartVC()
        targetVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 血氧饱和度设置
    class func gotoDevSetBloodOxygen(at targetVC: UIViewController) {
        if !isDevConnectBind {
            targetVC.view.makeInsetToast(R.string.xwhDeviceText.设备未连接())
            return
        }
        
        let vc = XWHDevSetBloodOxygenVC()
        targetVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 久坐提醒
    class func gotoDevSetStand(at targetVC: UIViewController) {
        if !isDevConnectBind {
            targetVC.view.makeInsetToast(R.string.xwhDeviceText.设备未连接())
            return
        }
        
        let vc = XWHDevSetStandVC()
        targetVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 血压设置
    class func gotoDevSetBloodPressure(at targetVC: UIViewController) {
        if !isDevConnectBind {
            targetVC.view.makeInsetToast(R.string.xwhDeviceText.设备未连接())
            return
        }
        
        let vc = XWHDevSetBloodPressureVC()
        targetVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 精神压力设置
    class func gotoDevSetMentalStress(at targetVC: UIViewController) {
        if !isDevConnectBind {
            targetVC.view.makeInsetToast(R.string.xwhDeviceText.设备未连接())
            return
        }
        
        let vc = XWHDevSetMentalStressVC()
        targetVC.navigationController?.pushViewController(vc, animated: true)
    }
    
}
