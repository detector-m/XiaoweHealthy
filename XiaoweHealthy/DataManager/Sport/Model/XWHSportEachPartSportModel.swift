//
//  XWHSportEachPartSportModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/1.
//

import UIKit
import GRDB
import CoreLocation
import HandyJSON


/// 每段运动的模型（每公里）
class XWHSportEachPartSportModel: XWHDataBaseModel {
    
    var sportId = 0
    
    /// 开始时间
    var bTime = ""
    /// 结束时间
    var eTime = ""
    
    /// 开始/结束里程
    var startMileage = 0
    var endMileage = 0
    
    /// 持续时间 (s)
    var duration = 0
    
    /// 步数
    var step = 0
    
    /// 距离 （m）
    var distance = 0
    
    /// 消耗 (KAL)
    var cal = 0
    
    /// 配速
    var pace = 0
    
    /// 速度
    var speed = 0
    
    /// 心率
    var heartRate = 0
    
    /// 步幅 cm
    var stepWidth = 70
    
    var coordinates: [CLLocationCoordinate2D] = []
    
    required init() {
        super.init()
    }
    
    // MARK: - GRDB
    required init(row: Row) {
        super.init(row: row)
    }
    
    
    // MARK: - HandyJSON
    override func mapping(mapper: HelpingMapper) {
        mapper <<<
            identifier <-- "deviceSn"
        
        mapper <<<
            eTime <-- "startTime"
        mapper <<<
            eTime <-- "endTime"

        mapper <<<
            duration <-- "timeConsuming"

        mapper <<<
            distance <-- "distance"
        
        mapper <<<
            cal <-- "calories"
        
        mapper <<<
            step <-- "stepCount"

        mapper <<<
            pace <-- "currentPace"
        
        mapper <<<
            speed <-- "avgSpeed"
        
        mapper <<<
            stepWidth <-- "avgStepWidth"
    }
    
    // MARK: - Encodable
    override func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: Columns.self)
//
//        try container.encode(identifier, forKey: .identifier)
//        try container.encode(mac, forKey: .mac)
//        try container.encode(time, forKey: .time)
//        try container.encode(value, forKey: .value)
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        super.init()
        
//        let container = try decoder.container(keyedBy: Columns.self)
//
//        identifier = try container.decode(String.self, forKey: .identifier)
//        mac = try container.decode(String.self, forKey: .mac)
//        time = try container.decode(String.self, forKey: .time)
//        value = try container.decode(Int.self, forKey: .value)
    }

}

extension CLLocationCoordinate2D: HandyJSON {
    
}
