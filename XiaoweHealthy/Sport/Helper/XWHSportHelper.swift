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
    
}
