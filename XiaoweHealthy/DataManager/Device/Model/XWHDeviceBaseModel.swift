//
//  XWHDeviceBaseModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import Foundation
import GRDB

// MARK: - 设备基础类模型
class XWHDeviceBaseModel: Record, CustomDebugStringConvertible {
    
    /// 设备ID（标识）
    var identifier = ""
    
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
    
    /// 固件版本
    var version = ""
    
    /// 电量
    var battery = 0
    
    /// 是否是当前
    var isCurrent = false
    
    class override var databaseTableName: String {
        "deviceBaseModel"
    }
    
    override init() {
        super.init()
    }
    
    required init(row: Row) {
        super.init(row: row)
    }
    
    var debugDescription: String {
        return "name = \(name), type = \(type), mac = \(mac), identifier = \(identifier), version = \(version)"
    }
    
}
