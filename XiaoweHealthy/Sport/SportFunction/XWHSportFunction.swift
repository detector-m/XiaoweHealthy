//
//  XWHSportFunction.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/30.
//

import Foundation


class XWHSportFunction {
    
    /// 获取计算运动卡路里
    class func getCal(sportTime: Int, distance: Int) -> Int {
        if sportTime == 0 {
            return 0
        }
        
        /*
         (1) 已知体重、时间和速度
         跑步热量（kcal）＝体重（kg）×运动时间（小时）×指数K
         指数K＝30÷速度（分钟/400米）
         */
        var weight: Double = 60
        if let user = XWHUserDataManager.getCurrentUser() {
            weight = user.weight.double
        }
        
        let hTime = sportTime.double / 3600
        let speed = distance.double / sportTime.double
        let mTime = (speed * 400) / 60
        
        let k = 30 / mTime
        
        let cal = weight * hTime * k
        return cal.int
    }
    
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
