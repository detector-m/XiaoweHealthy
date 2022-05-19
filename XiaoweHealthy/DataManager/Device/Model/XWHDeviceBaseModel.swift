//
//  XWHDeviceBaseModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/7.
//

import Foundation
import GRDB

// MARK: - 设备基础类模型
class XWHDeviceBaseModel: XWHDataBaseModel {
    
    /// 设备ID（标识）
//    var identifier = ""
    
    /// 设备名称
    var name = ""
    
    /// 品牌名称
    var brand = ""
    
    /// 设备的分类
    private var _category = ""
    
    var category: XWHDeviceCategory {
        get {
            return XWHDeviceCategory(rawValue: _category) ?? .none
        }
        
        set {
            _category = newValue.rawValue
        }
    }
    
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
    
    /// 绑定的时间
    var bindDate = ""
    
    /// 是否是当前
    var isCurrent = false
    
    class override var databaseTableName: String {
        "deviceBaseModel"
    }
    
    override var debugDescription: String {
        return "identifier = \(identifier), name = \(name), brand = \(brand), type = \(type), mac = \(mac), version = \(version)"
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    required init(row: Row) {
        super.init(row: row)
    }
    
}
