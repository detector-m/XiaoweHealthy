//
//  XWHWeatherInfoOneDayModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/14.
//

import Foundation


// MARK: - 某天的天气信息模型
struct XWHWeatherInfoOneDayModel: CustomDebugStringConvertible {
    
    /**
     *  Weather code
     *  Weather icon  reference URL https://dev.qweather.com/docs/resource/icons/
     */
    var code = 0
    
    /// Weather type  @"Sunny"   (Depends on phone language)
    var type = ""
    
    /// Maximum temperature. Celsius
    var maxTemp = 0
    
    /// Minimum temperature. Celsius
    var minTemp = 0
    
    /// Sunrise   HH:mm  (Some regions may not support)
//    var sunrise = ""
    
    /// Sunset    HH:mm  (Some regions may not support)
//    var sunset = ""
    
    /// Moonrise   HH:mm  (Some regions may not support)
//    var moonrise = ""
    
    /// Moonset    HH:mm  (Some regions may not support)
//    var moonset = ""
    
    var debugDescription: String {
        return "{code = \(code) type = \(type) maxTemp = \(maxTemp) minTemp = \(minTemp)}"
    }
    
}
