//
//  XWHSportFunction.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/30.
//

import Foundation


class XWHSportFunction {
    
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
    
}
