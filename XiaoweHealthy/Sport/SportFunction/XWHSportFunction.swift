//
//  XWHSportFunction.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/30.
//

import Foundation


class XWHSportFunction {
    
    // MARK: - 卡路里
    /// 获取计算运动卡路里
    class func getCal(sportTime: Int, distance: Int, sportType: XWHSportType) -> Int {
        if sportTime == 0 {
            return 0
        }
        
        var weight: Int = 60
        if let user = XWHUserDataManager.getCurrentUser() {
            weight = user.weight
        }
        let cal = calculateCalorie(weight: weight, distance: distance, sportType: sportType)
        
        return cal
    }
    
    private class func calculateCalorie(weight: Int, distance: Int, sportType: XWHSportType) -> Int {
        // 暂时用这个算卡路里
        // 跑步热量（kcal）＝体重（kg）×距离（公里）×1.036
        var k: Double = 0
        switch sportType {
        case .none:
            k = 0
        case .run:
            k = 1.036
        case .walk:
            k = 0.8214
        case .ride:
            k = 0.6142
        case .climb:
            k = 1.036
        case .other:
            k = 0.5
        }
        let calorie: Double = weight.double * distance.double / 1000 * k
        return calorie.int
    }
    
    private class func calculateCalorie(weight: Int, distance: Int, duration: Int) -> Int {
        /*
         (1) 已知体重、时间和速度
         跑步热量（kcal）＝体重（kg）×运动时间（小时）×指数K
         指数K＝30÷速度（分钟/400米）
         */
        
        let hTime = duration.double / 3600
        let speed = distance.double / duration.double
        let mTime = (speed * 400) / 60
        
        let k = 30 / mTime
        
        let cal = weight.double * hTime * k
        return cal.int
    }
    
    // MARK: - 步幅
    /// 获取步幅
    class func getStepWidth() -> Int {
        var stepWidth: Double = 60
        if let user = XWHUserDataManager.getCurrentUser() {
            stepWidth = user.height.double * 0.45
        }
        
        return stepWidth.int
    }
    
}

extension XWHSportFunction {
    
    class func getSportIndexToServer(sType: XWHSportType) -> Int {
        switch sType {
        case .none:
            return 0
            
        case .run:
            return 1
        
        case .walk:
            return 2
            
        case .ride:
            return 3
            
        case .climb:
            return 4
            
        case .other:
            return 10000
        }
    }
    
    class func getGpsLevel(gpsSignal: Double) -> Int {
        if gpsSignal < 0 {
            return 0
        } else if gpsSignal >= 60 {
            return 1
        } else if gpsSignal >= 40 {
            return 2
        } else if gpsSignal >= 20 {
            return 3
        } else {
            return 4
        }
    }
    
}
