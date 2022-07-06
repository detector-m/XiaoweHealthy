//
//  XWHSportMonthRecordItemModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/4.
//

import Foundation
import HandyJSON


class XWHSportMonthRecordItemModel: HandyJSON {
    
    var totalDistance = 0
    var totalCalories = 0
    var totalTimes = 0
    
    var items: [XWHSportMonthRecordItemsSubItemModel] = []
    
    required init() {
        
    }
    
}

class XWHSportMonthRecordItemsSubItemModel: HandyJSON {
    
    var sportId = 0
    // "2022-12-31 07:35:42",
    var exerciseTime = ""
    var exerciseType = 0
    var distance = 0
    var duration = 0
    var avgPace = 0
    var calories = 0
    var avgHeartRate = 0
    
    required init() {
        
    }
    
}
