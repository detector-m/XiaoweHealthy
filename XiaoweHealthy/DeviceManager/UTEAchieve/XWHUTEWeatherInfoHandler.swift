//
//  XWHUTEWeatherInfoHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/12.
//

import Foundation
import UTESmartBandApi
import CoreLocation

/// UTE 处理天气数据
class XWHUTEWeatherInfoHandler: XWHWeatherServiceProtocol {
    
    static let kUTEWeatherApiKey = "017f5b7d60003890229c3bdccf9548e1"
    
    /// 获取天气服务的天气数据
    func getWeatherServiceWeatherInfo(cityId: String? = nil, latitude: Double, longitude: Double, handler: XWHWeatherServiceHandler?) {
        let errorMsg = "获取天气服务的天气数据失败"
        log.debug("获取天气服务的天气数据")
        UTESmartBandClient.sharedInstance().getUTEWeatherDataFormServer(Self.kUTEWeatherApiKey, cityID: cityId, latitude: latitude, longitude: longitude) { (weatherInfo: UTEModelWeatherInfo?) -> Void in
            DispatchQueue.main.async {
                guard let wInfo = weatherInfo else {
                    self.handleError(errorMsg, handler: handler)

                    return
                }

                self.handlerWeatherInfo(wInfo, handler: handler)
            }
        } failure: { error in
            DispatchQueue.main.async {
                var sysErrorMsg = XWHError.handleSysError(error)
                sysErrorMsg = sysErrorMsg.isEmpty ? errorMsg : sysErrorMsg
                self.handleError(sysErrorMsg, handler: handler)
            }
        }
    }
    
    private func handlerWeatherInfo(_ wInfo: UTEModelWeatherInfo, handler: XWHWeatherServiceHandler?) {
        var weatherInfo = XWHWeatherInfoModel()
        weatherInfo.cityId = wInfo.cityID ?? ""
        weatherInfo.cityName = wInfo.city ?? ""
        weatherInfo.region = wInfo.region ?? ""
        weatherInfo.updateDate = wInfo.updateTime ?? ""
        weatherInfo.tempNow = wInfo.tempNow
        
        let weatherInfoItems: [XWHWeatherInfoOneDayModel] = wInfo.array.map { modle in
            let item = XWHWeatherInfoOneDayModel(code: modle.codeWeather, type: modle.text, maxTemp: modle.maxTemp, minTemp: modle.minTemp)
            
            return item
        }
        
        weatherInfo.items = weatherInfoItems
        
        handler?(.success(weatherInfo))
    }
    
    private func handleError(_ message: String, handler: XWHWeatherServiceHandler?) {
        var error = XWHError()
        error.message = message
        log.error(error)
        handler?(.failure(error))
    }
    
}


// MARK: - 定位
extension XWHUTEWeatherInfoHandler {
    
    
}
