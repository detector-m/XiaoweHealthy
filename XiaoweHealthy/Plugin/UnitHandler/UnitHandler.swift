//
//  UnitHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/16.
//

import Foundation

class UnitHandler {
    
    class func getKm(m: Int) -> Double {
        return (m.double / 1000).rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrAwayFromZero)
    }
    
}
