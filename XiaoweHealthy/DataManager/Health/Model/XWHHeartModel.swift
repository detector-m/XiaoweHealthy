//
//  XWHHeartModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import Foundation
import HandyJSON
import GRDB


/// 心率数据模型
class XWHHeartModel: XWHHealthyDataBaseModel {
    
    public enum Columns: String, ColumnExpression, CodingKey {
        case identifier, time, value
    }
    
    class override var databaseTableName: String {
        "heart_model"
    }
    
    /// 服务记录id
    var srId = 0
    var value = 0
    
    override var description: String {
        "{ identifier = \(identifier), time = \(time), value = \(value) }"
    }
    
    required init() {
        super.init()
    }
    
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[Columns.identifier]
        time = row[Columns.time]
        value = row[Columns.value]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier
        container[Columns.time] = time
        container[Columns.value] = value
    }

    
    // MARK: - HandyJSON
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            srId <-- "id"
        
        mapper <<<
            time <-- "collectTime"
        mapper <<<
            value <-- "rateVal"
        
        mapper <<<
            identifier <-- "deviceName"
        
//        mapper >>> identifier
    }
    
    // MARK: - Encodable
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Columns.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(time, forKey: .time)
        try container.encode(value, forKey: .value)
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: Columns.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        time = try container.decode(String.self, forKey: .time)
        value = try container.decode(Int.self, forKey: .value)
    }
    
//    func clone() -> Self {
//        let encoder = JSONEncoder()
//        guard let data = try? encoder.encode(self) else {
//            fatalError("encode failed")
//        }
//        let decoder = JSONDecoder()
//        guard let target = try? decoder.decode(Self.self, from: data) else {
//            fatalError("decode failed")
//        }
//        
//        return target
//    }
    
}
