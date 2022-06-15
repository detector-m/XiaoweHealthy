//
//  XWHActivityItemModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/15.
//

import UIKit
import GRDB

/// 每个活动的数据模型
class XWHActivityItemModel: XWHHealthyDataBaseModel {
    
    public enum ItemColumns: String, ColumnExpression, CodingKey {
        case identifier, mac, time, steps, calories, distance
    }
    
    class override var databaseTableName: String {
        "activity_item_model"
    }
    
    
    var steps = 0
    var calories = 0
    var distance = 0
    
    override var description: String {
        "{ identifier = \(identifier), mac = \(mac), time = \(time), steps = \(steps), calories = \(calories), distance = \(distance) }"
    }
    
    required init() {
        super.init()
    }
    
    // MARK: - GRDB
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[ItemColumns.identifier]
        mac = row[ItemColumns.mac]
        time = row[ItemColumns.time]
        
        steps = row[ItemColumns.steps]
        calories = row[ItemColumns.calories]
        distance = row[ItemColumns.distance]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[ItemColumns.identifier] = identifier
        container[ItemColumns.mac] = mac
        container[ItemColumns.time] = time
        
        container[ItemColumns.steps] = steps
        container[ItemColumns.calories] = calories
        container[ItemColumns.distance] = distance
    }

    
    // MARK: - HandyJSON
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            time <-- "collectTime"
        
//        mapper >>> identifier
    }
    
    // MARK: - Encodable
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ItemColumns.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(mac, forKey: .mac)
        try container.encode(time, forKey: .time)
        
        try container.encode(steps, forKey: .steps)
        try container.encode(calories, forKey: .calories)
        try container.encode(distance, forKey: .distance)
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: ItemColumns.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        mac = try container.decode(String.self, forKey: .mac)
        time = try container.decode(String.self, forKey: .time)
        
        steps = try container.decode(Int.self, forKey: .steps)
        calories = try container.decode(Int.self, forKey: .calories)
        distance = try container.decode(Int.self, forKey: .distance)
    }

}
