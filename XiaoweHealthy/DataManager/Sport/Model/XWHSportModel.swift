//
//  XWHSportModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/30.
//

import UIKit
import GRDB

import CoreLocation


/// 运动模型
class XWHSportModel: XWHDataBaseModel {
    
    var uuid = ""
    
    var type: XWHSportType {
        get {
            return XWHSportDataHelper.getSportType(sportIndex: intSportType)
        }
        
        set {
            intSportType = XWHSportDataHelper.getSportIndex(sportType: newValue)
        }
    }
    var state: XWHSportState = .stop
    
    var intSportType: Int = 0
    
    /// 开始时间
    var bTime = ""
    /// 结束时间
    var eTime = ""
    
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
    
    /// 平均心率
    var avgHeartRate = 0
    
    /// 心率列表
    var heartRateList: [XWHHeartModel] = []
    
    /// 步幅 cm
    var stepWidth = 70
    
    /// each parts
    var eachPartItems: [XWHSportEachPartSportModel] = []
    
    /// 轨迹列表
//    var locations: [CLLocation] = []
    
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
            eTime <-- "exerciseTime"

        mapper <<<
            intSportType <-- "exerciseType"
        
        mapper <<<
            duration <-- "duration"

        mapper <<<
            distance <-- "distance"
        
        mapper <<<
            cal <-- "calories"
        
        mapper <<<
            step <-- "stepCount"

        mapper <<<
            pace <-- "avgPace"
        
        mapper <<<
            speed <-- "avgSpeed"
        
//        mapper <<<
//            avgHeartRate <-- "avgHeartRate"
        
        mapper <<<
            stepWidth <-- "avgStepWidth"
        
        mapper <<<
            eachPartItems <-- "kilometers"
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
