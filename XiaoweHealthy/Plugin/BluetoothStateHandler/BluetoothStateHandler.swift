//
//  BluetoothStateHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/1.
//


import Foundation
import CoreBluetooth


/// 蓝牙状态处理器
class BluetoothStateHandler: NSObject, CBCentralManagerDelegate {
    
    typealias BLEStateHandler = (_ state: CBManagerState) -> Void
    
    static let shared: BluetoothStateHandler = .init()
    
    // MARK: - Manager
    private var manager: CBCentralManager?
    private var stateHandler: BLEStateHandler?
    
    private override init() {
        super.init()
    }
    
    func reqeustState(_ handler: BLEStateHandler?) {
        stateHandler = handler
        
        if manager == nil {
            manager = CBCentralManager(delegate: self, queue: nil, options: [:])
        } else {
            log.info("蓝牙开关状态 state = \(manager!.state.string)")

            stateHandler?(manager!.state)
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        log.info("蓝牙开关状态 state = \(central.state.string)")
        
        stateHandler?(central.state)
    }
    
}

extension BluetoothStateHandler {
    
    static func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}


// MARK: - CBManagerState extension
extension CBManagerState {
    
    // 是否开启
    var isOpen: Bool {
        return self == .poweredOn
    }
    
    /// 是否授权
    var isAuthorized: Bool {
        return self != .unauthorized
    }
    
    var string: String {
        switch self {
        case .unknown:
            return "未知"
            
        case .resetting:
            return "重置"
            
        case .unsupported:
            return "不支持"
            
        case .unauthorized:
            return "未授权"
            
        case .poweredOn:
            return "打开"
            
        case .poweredOff:
            return "关闭"
            
        @unknown default:
            return "未知的默认状态"
        }
    }
    
}
