//
//  XWHUTEWeatherInfoHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/12.
//

import Foundation
import UTESmartBandApi

class XWHUTEWeatherInfoHandler {
    
    static let kUTEWeatherApiKey = "017f5b7d60003890229c3bdccf9548e1"
    
    class func getWeatherInfo(cityId: String, latitude: Double, longitude: Double) {
        UTESmartBandClient.sharedInstance().getUTEWeatherDataFormServer(kUTEWeatherApiKey, cityID: cityId, latitude: latitude, longitude: longitude) { (weatherInfo: UTEModelWeatherInfo?) -> Void in
            log.debug(weatherInfo)
        } failure: { error in
            log.error(error)
        }

    }
    
}
