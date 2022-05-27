//
//  XWHSleepItemModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/7.
//

import UIKit
import GRDB

class XWHSleepItemModel: XWHHealthyDataBaseModel {
    
    public enum ItemColumns: String, ColumnExpression, CodingKey {
        case identifier, mac, time, bTime, duration, eTime, type
    }
    
    class override var databaseTableName: String {
        "sleep_item_model"
    }
    
    /// 入睡时间
    var bTime = ""
    /// 醒来时间
    var eTime = ""
    
    /// 时长
    var duration = 0
    
    /// 睡眠类型 0｜深睡，1｜浅睡，2｜清醒
    var type = 0
    
    override var description: String {
        "{ identifier = \(identifier), mac = \(mac), time = \(time), bTime = \(bTime), eTime = \(eTime), duration = \(duration), type = \(type) }"
    }
    
    required init() {
        super.init()
    }
    
    // MARK: - GRDB
    required init(row: Row) {
        super.init(row: row)
    }
    
//    override func encode(to container: inout PersistenceContainer) {
//        container[Columns.identifier] = identifier
//        container[Columns.time] = time
//        container[Columns.value] = value
//    }
    
    // MARK: - HandyJSON
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            bTime <-- "startTime"
        mapper <<<
            eTime <-- "endTime"
        
        mapper <<<
            type <-- "sleepStatus"
        
//        mapper <<<
//            identifier <-- "deviceName"
        
        mapper >>> identifier
        mapper >>> time
        mapper >>> duration
    }
    
    // MARK: - Encodable
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ItemColumns.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(mac, forKey: .mac)

        try container.encode(time, forKey: .time)
        try container.encode(bTime, forKey: .bTime)
        try container.encode(eTime, forKey: .eTime)
        try container.encode(duration, forKey: .duration)
        try container.encode(type, forKey: .type)
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: ItemColumns.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        mac = try container.decode(String.self, forKey: .mac)

        time = try container.decode(String.self, forKey: .time)
        
        bTime = try container.decode(String.self, forKey: .bTime)
        eTime = try container.decode(String.self, forKey: .eTime)
        duration = try container.decode(Int.self, forKey: .duration)
        type = try container.decode(Int.self, forKey: .type)
    }

}
