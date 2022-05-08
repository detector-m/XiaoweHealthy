//
//  XWHSleepModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/7.
//

import UIKit
import GRDB

class XWHSleepModel: XWHSleepItemModel {
    
    enum Columns: String, ColumnExpression, CodingKey {
        case identifier, time, bTime, eTime, type, duration, deepSleepDuration, lightSleepDuration, awakeDuration, awakeTimes, items
    }
    
    class override var databaseTableName: String {
        "sleep_model"
    }
    
    /// 睡眠类型 1｜晚睡，2｜午睡
//    var type
    
    /// 睡眠总时长
//    var duration = 0
    
    /// 深睡时长
    var deepSleepDuration = 0
    /// 浅睡时长
    var lightSleepDuration = 0
    /// 清醒时长
    var awakeDuration = 0
    
    /// 清醒次数
    var awakeTimes = 0
    
    var items: [XWHSleepItemModel] = []
    
    override var description: String {
        "{ identifier = \(identifier), time = \(time), bTime = \(bTime), eTime = \(eTime), duration = \(duration), type = \(type), \n  itmes = \(items) }"
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
            identifier <-- "deviceSn"
        mapper <<<
            time <-- "collectTime"
        
        mapper <<<
            type <-- "sleepType"
        mapper <<<
            bTime <-- "startTime"
        mapper <<<
            eTime <-- "endTime"
        mapper <<<
            duration <-- "totalDuration"
        
        mapper <<<
            awakeTimes <-- "awakeCount"
        
        mapper <<<
            items <-- "data"
    }
    
    // MARK: - Encodable
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Columns.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(time, forKey: .time)
        try container.encode(bTime, forKey: .bTime)
        try container.encode(eTime, forKey: .eTime)
        try container.encode(type, forKey: .type)
        
        try container.encode(duration, forKey: .duration)
        try container.encode(deepSleepDuration, forKey: .deepSleepDuration)
        try container.encode(lightSleepDuration, forKey: .lightSleepDuration)
        try container.encode(awakeDuration, forKey: .awakeDuration)
        try container.encode(awakeTimes, forKey: .awakeTimes)

        try container.encode(items, forKey: .items)
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: Columns.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        time = try container.decode(String.self, forKey: .time)
        
        bTime = try container.decode(String.self, forKey: .bTime)
        eTime = try container.decode(String.self, forKey: .eTime)
        type = try container.decode(Int.self, forKey: .type)
        duration = try container.decode(Int.self, forKey: .duration)
        deepSleepDuration = try container.decode(Int.self, forKey: .deepSleepDuration)
        lightSleepDuration = try container.decode(Int.self, forKey: .lightSleepDuration)
        awakeDuration = try container.decode(Int.self, forKey: .awakeDuration)
        awakeTimes = try container.decode(Int.self, forKey: .awakeTimes)
        
        items = try container.decode([XWHSleepItemModel].self, forKey: .items)
    }
    
}
