//
//  XWHSportHelper.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/4.
//

import Foundation


class XWHSportHelper {

    class func getSportIndex(sportType: XWHSportType) -> Int {
        return XWHSportDataHelper.getSportIndex(sportType: sportType)
    }
    
    class func getSportType(sportIndex: Int) -> XWHSportType {
        return XWHSportDataHelper.getSportType(sportIndex: sportIndex)
    }
    
    class func getPaceString(_ pace: Int) -> String {
        let m = pace / 60
        let s = pace % 60
        return "\(m)'\(s)\""
    }
    
    class func getDurationString(_ duration: Int) -> String {
        let tDate = Date().dayBegin.adding(.second, value: duration)
        return tDate.string(withFormat: XWHDate.timeAllFormat)
    }
    
}
