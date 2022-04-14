//
//  XWHWeatherInfoModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/14.
//

import Foundation
import CoreLocation


// MARK: - 天气信息模型
struct XWHWeatherInfoModel: CustomDebugStringConvertible {
    
    /// City ID
    var cityId = ""
    
    /// Which city  e.g. @"BeiJing"   (Depends on phone language)
    var cityName = ""
    
    /// That district of the city e.g. @"Chaoyang"   (Depends on phone language)
    var region = ""
    
    /// Today Current Temperature. Celsius
    var tempNow = 0
    
    // 经纬度
//    let location = CLLocationCoordinate2D()
   
    /// Today weather PM2.5 (Unit μg/m³)
//    var PM25 = 0
    
    /// Today weather humidity (湿度)
//    var humidity = 0
    
    /// Today weather UV （紫外线）
//    var UV = 0
    
    /**
     *  Today city aqi (Air Quality Index)  空气质量指数
     *  Excellent:                  0 ~ 50
     *  Generally:                  51 ~ 100
     *  Slight pollution:           101 ~ 150
     *  Moderate pollution:     151 ~ 200
     *  Heavy pollution:            201 ~ 300
     *  Serious pollution:          >= 301
     */
//    var aqi = 0

    /**
     *  The highest temperature and lowest temperature today and the next 6 days
     *  index 0: today , index 1: tomorrow ....... and so on
     */
    var items = [XWHWeatherInfoOneDayModel]()
    
    /// The time the server updates the weather   yyyy-MM-dd HH:mm
    var updateDate = ""
    
    var debugDescription: String {
        return "{cityId = \(cityId), cityName = \(cityName), region = \(region), tempNow = \(tempNow), items = \(items), updateDate = \(updateDate)}"
    }
    
}
