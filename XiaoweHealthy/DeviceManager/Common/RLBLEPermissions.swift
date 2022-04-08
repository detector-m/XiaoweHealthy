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
    
    var central: CBCentralManager?
    
    var stateHandler: RLBLEStateHandler?
    
    private override init() {
        
    }
    
    func getState(handler: RLBLEStateHandler? = nil) {
        central = CBCentralManager(delegate: self, queue: nil)
        stateHandler = handler
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
        
        self.central?.delegate = nil
        self.central = nil
    }
}



// MARK: - Method
extension RLBLEPermissions {
    
    static func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

