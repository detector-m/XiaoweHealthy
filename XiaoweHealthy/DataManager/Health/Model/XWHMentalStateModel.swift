//
//  XWHMentalStateModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/9.
//

import UIKit
import GRDB


/// 精神状态模型 （压力、情绪、疲劳度数据）
class XWHMentalStateModel: XWHHealthyDataBaseModel {
    
    enum Columns: String, ColumnExpression, CodingKey {
        case identifier, time, mood, fatigue, stress
    }
    
    class override var databaseTableName: String {
        "mental_state_model"
    }

    /// 情绪值0消极1正常2积极
    var mood = 0
    /// 疲劳度值
    var fatigue = 0
    /// 压力值
    var stress = 0
    
    override var description: String {
        "{ identifier = \(identifier), time = \(time), mood = \(mood), fatigue = \(fatigue), stress = \(stress) }"
    }
    
    required init() {
        super.init()
    }
    
    // MARK: - GRDB
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[Columns.identifier]
        time = row[Columns.time]
        mood = row[Columns.mood]
        fatigue = row[Columns.fatigue]
        stress = row[Columns.stress]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier
        container[Columns.time] = time
        container[Columns.mood] = mood
        container[Columns.fatigue] = fatigue
        container[Columns.stress] = stress
    }

    
    // MARK: - HandyJSON
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            time <-- "collectTime"
        
        mapper <<<
            stress <-- "pressure"
        
        mapper >>> identifier
    }
    
    // MARK: - Encodable
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Columns.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(time, forKey: .time)
        try container.encode(mood, forKey: .mood)
        try container.encode(fatigue, forKey: .fatigue)
        try container.encode(stress, forKey: .stress)
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: Columns.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        time = try container.decode(String.self, forKey: .time)
        mood = try container.decode(Int.self, forKey: .mood)
        fatigue = try container.decode(Int.self, forKey: .fatigue)
        stress = try container.decode(Int.self, forKey: .stress)
    }
    
}
