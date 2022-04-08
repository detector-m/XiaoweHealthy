//
//  XWHDeviceBaseModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import Foundation

// MARK: - 设备基础类模型
class XWHDeviceBaseModel: CustomDebugStringConvertible {
    
    /// 设备名称
    var name = ""
    
    /// 设备类型
    private var _type = ""
    
    var type: XWHDeviceType {
        get {
            return XWHDeviceType(rawValue: _type) ?? .none
        }
        set {
            _type = newValue.rawValue
        }
    }
    
    /// 设备mac
    var mac = ""
    
    /// 信号
    var rssi = 0
    
    /// 设备ID
    var identifier = ""
    
    /// 固件版本
    var version = ""
    
    /// 电量
    var battery = 0
    
    var debugDescription: String {
        return "name = \(name), type = \(type), mac = \(mac), identifier = \(identifier), version = \(version)"
    }
    
}
