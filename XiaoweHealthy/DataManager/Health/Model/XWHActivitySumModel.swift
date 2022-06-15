//
//  XWHActivitySumModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/15.
//

import UIKit
import GRDB


/// 活动数据总和数据
class XWHActivitySumModel: XWHActivityItemModel {

    public enum SumColumns: String, ColumnExpression, CodingKey {
        case identifier, mac, time, steps, calories, distance, stepGoal, caloriesGoal, distanceGoal
    }
    
    class override var databaseTableName: String {
        "activity_sum_model"
    }
    
    var stepGoal = 0
    var caloriesGoal = 0
    var distanceGoal = 0
    
    var items: [XWHActivityItemModel] = []
    
    override var description: String {
        "{ identifier = \(identifier), mac = \(mac), time = \(time), steps = \(steps), calories = \(calories), distance = \(distance), stepGoal = \(stepGoal), caloriesGoal = \(caloriesGoal), distanceGoal = \(distanceGoal) }"
    }
    
    required init() {
        super.init()
    }
    
    // MARK: - GRDB
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[SumColumns.identifier]
        mac = row[SumColumns.mac]
        time = row[SumColumns.time]
        
        steps = row[SumColumns.steps]
        calories = row[SumColumns.calories]
        distance = row[SumColumns.distance]
        
        stepGoal = row[SumColumns.stepGoal]
        caloriesGoal = row[SumColumns.caloriesGoal]
        distanceGoal = row[SumColumns.distanceGoal]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[SumColumns.identifier] = identifier
        container[SumColumns.mac] = mac
        container[SumColumns.time] = time
        
        container[SumColumns.steps] = steps
        container[SumColumns.calories] = calories
        container[SumColumns.distance] = distance
        
        container[SumColumns.stepGoal] = stepGoal
        container[SumColumns.caloriesGoal] = caloriesGoal
        container[SumColumns.distanceGoal] = distanceGoal
    }

    
    // MARK: - HandyJSON
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            identifier <-- "deviceSn"
        
        mapper <<<
            time <-- "collectDate"
        
        mapper <<<
            steps <-- "totalSteps"
        
        mapper <<<
            calories <-- "totalCalories"
        
        mapper <<<
            distance <-- "totalDistance"
        
        mapper <<<
            items <-- "data"
        
//        mapper >>> identifier
    }
    
    // MARK: - Encodable
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SumColumns.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(mac, forKey: .mac)
        try container.encode(time, forKey: .time)
        
        try container.encode(steps, forKey: .steps)
        try container.encode(calories, forKey: .calories)
        try container.encode(distance, forKey: .distance)
        
        try container.encode(steps, forKey: .stepGoal)
        try container.encode(calories, forKey: .caloriesGoal)
        try container.encode(distance, forKey: .distanceGoal)
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: SumColumns.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        mac = try container.decode(String.self, forKey: .mac)
        time = try container.decode(String.self, forKey: .time)
        
        steps = try container.decode(Int.self, forKey: .steps)
        calories = try container.decode(Int.self, forKey: .calories)
        distance = try container.decode(Int.self, forKey: .distance)
        
        stepGoal = try container.decode(Int.self, forKey: .stepGoal)
        caloriesGoal = try container.decode(Int.self, forKey: .caloriesGoal)
        distanceGoal = try container.decode(Int.self, forKey: .distanceGoal)
    }
    
}
