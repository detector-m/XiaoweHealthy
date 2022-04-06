//
//  RLBLEPermissions.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/6.
//

import Foundation
import CoreBluetooth

typealias RLBLEStateHandler = (RLBLEState) -> Void

enum RLBLEState {
    
    case unauthorized
    case poweredOff
    case poweredOn
    
}

class RLBLEPermissions: NSObject {
    
    static let shared = RLBLEPermissions()
    
    lazy var state = RLBLEState.unauthorized
    
    lazy var central: CBCentralManager = CBCentralManager(delegate: self, queue: nil)
    
    var stateHandler: RLBLEStateHandler?
    
    fileprivate func checkState(handler: RLBLEStateHandler?) {
        switch central.state {
        case .poweredOff:
            state = .poweredOff
            
        case .unauthorized:
            state = .unauthorized
            
        default:
            state = .poweredOn
        }
        
        stateHandler = handler
    }
    
    
    func getState(handler: RLBLEStateHandler? = nil) {
//        let tipsView = R.nib.hbTipsView(owner: nil)
        checkState { state in
            switch state {
            case .poweredOn:
                handler?(.poweredOn)
                
            case .unauthorized:
//                tipsView?.show(title: R.string.tips.需打开蓝牙权限才可连接设备().attributed, okClosure: {
//                    HBBLEPermissions.shared.openAppSettings()
//                })
                handler?(.unauthorized)
                
            case .poweredOff:
                guard #available(iOS 13.0, *) else {
//                    tipsView?.show(title: R.string.tips.请先打开蓝牙开关().attributed)
                    handler?(.poweredOff)
                    
                    return
                }
                
                handler?(.poweredOff)
            }
        }
        
    }
    
}

// MARK: - CBCentralManagerDelegate
extension RLBLEPermissions: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOff:
//            HBAnalytics.logDeviceEvent(HBAnalyticsEvent.Device.device_scan_8000)
            state = .poweredOff
            
        case .unauthorized:
//            HBAnalytics.logDeviceEvent(HBAnalyticsEvent.Device.device_scan_8001)
            state = .unauthorized
            
        default:
            state = .poweredOn
        }
        
        stateHandler?(state)
        
        stateHandler = nil
    }
}



// MARK: - Method
extension RLBLEPermissions {
    
    func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

