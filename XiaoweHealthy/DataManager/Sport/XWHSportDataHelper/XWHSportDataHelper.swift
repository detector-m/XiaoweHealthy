//
//  XWHSportDataHelper.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/4.
//

import Foundation


class XWHSportDataHelper {
    
    class func getSportIndex(sportType: XWHSportType) -> Int {
        var intSportType = 0
        switch sportType {
        case .none:
            intSportType = 0
            
        case .run:
            intSportType = 1
        
        case .walk:
            intSportType = 2
            
        case .ride:
            intSportType = 3
            
        case .climb:
            intSportType = 4
        }
        
        return intSportType
    }
    
    class func getSportType(sportIndex: Int) -> XWHSportType {
        switch sportIndex {
        case 1:
            return .run
            
        case 2:
            return .walk
            
        case 3:
            return .ride
        
        case 4:
            return .climb
            
        default:
            return .none
        }
    }
    
    class func mToKm(_ distance: Int) -> Double {
        var km = distance.double / 1000
        km = km.rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrAwayFromZero)
        
        return km
    }
    
    class func kmToM(_ distance: Double) -> Int {
        let m = distance * 1000
        return m.int
    }
    
}
