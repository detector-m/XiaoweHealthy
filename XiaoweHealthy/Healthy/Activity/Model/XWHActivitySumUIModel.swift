//
//  XWHActivitySumUIModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/16.
//

import UIKit
import HandyJSON

class XWHActivitySumUIModel: HandyJSON {

    /// "2022-04-06"
    var collectDate = ""
    var calendarDate = ""
    var totalSteps = 0
    var totalCalories = 0
    var totalDistance = 0
    
    var stepGoal = 0
    var caloriesGoal = 0
    var distanceGoal = 0
    
    var steps: [XWHActivityItemUIModel] = []
    var calories: [XWHActivityItemUIModel] = []
    var distance: [XWHActivityItemUIModel] = []
    
    required init() {
        
    }
    
}
