//
//  XWHWeather.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/20.
//

import Foundation


class XWHWeather {
    
    static func checkLocationState(_ completion: ((Bool) -> Void)?) {
        if !XWHLocation.shared.locationEnabled() {
            log.error("未开启定位功能")
            completion?(false)
            return
        }
        
        XWHLocation.shared.checkState { isOk in
            completion?(isOk)
        }
    }
    
    static func getWeatherInfo(_ completion: ((XWHWeatherInfoModel?) -> Void)?) {
        guard let loc = XWHLocation.shared.currentLocation else {
            log.error("未定位到坐标")
            completion?(nil)
            return
        }
        
        XWHUTEWeatherInfoHandler().getWeatherServiceWeatherInfo(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude) { result in
            switch result {
            case .success(let weatherInfo):
                completion?(weatherInfo)

            case .failure(let error):
                log.error(error)
                completion?(nil)
            }
        }
    }
    
    static func getWeatherName(code: Int) -> String {
        if code == 100 || code == 150 {
            return "晴"
        }
        
        if (code >= 101 && code <= 103) || (code >= 151 && code <= 153) {
            return "多云"
        }
        
        if code == 104 || code == 154 {
            return "阴"
        }
        
        if code == 300 || code == 301 {
            return "阵雨"
        }
        
        if code == 300 || code == 301 || code == 350 || code == 351 {
            return "阵雨"
        }
        
        if code >= 302, code <= 304 {
            return "雷阵雨"
        }
        
        if code == 305 || code == 309 || code == 399 {
            return "小雨"
        }
        
        if code == 306 {
            return "中雨"
        }
        
        if code == 307 || code == 308 {
            return "大雨"
        }
        
        if code >= 310, code <= 312 {
            return "雷阵雨"
        }
        
        if code == 313 {
            return "冻雨"
        }
        
        if code == 314 {
            return "小到中雨"
        }
        
        if code == 315 {
            return "中到大雨"
        }
        if code == 316 || code == 317 || code == 318 {
            return "大到暴雨"
        }
    
        if code == 316 || code == 317 || code == 318 {
            return "大到暴雨"
        }
        
        if code == 400 {
            return "小雪"
        }
        if code == 401 {
            return "中雪"
        }
        if code == 402 {
            return "大雪"
        }
        if code == 403 {
            return "暴雪"
        }
        
        if code == 404 {
            return "雨夹雪"
        }
        if code == 405 {
            return "雨雪天气"
        }
        if code == 406 {
            return "阵雨夹雪"
        }
        if code == 407 {
            return "阵雪"
        }
        if code == 408 {
            return "小到中雪"
        }
        if code == 409 {
            return "中到大雪"
        }
        if code == 410 {
            return "大到暴雪"
        }
        if code == 456 {
            return "阵雨夹雪"
        }
        if code == 457  {
            return "阵雪"
        }
        if code == 499 {
            return "雪"
        }
        if code == 500 {
            return "薄雾"
        }
        if code == 501 {
            return "雾"
        }
        if code == 502 {
            return "霾"
        }
        if code == 503 {
            return "扬沙"
        }
        if code == 504 {
            return "浮尘"
        }
        if code == 507 {
            return "沙尘暴"
        }
        if code == 508 {
            return "强沙尘暴"
        }
        if code == 509 {
            return "浓雾"
        }
        if code == 510 {
            return "强浓雾 "
        }
        if code == 511 {
            return "中度霾"
        }
        if code == 512 {
            return "重度霾"
        }
        if code == 513 {
            return "严重霾"
        }
        if code == 514 {
            return "大雾"
        }
        if code == 515 {
            return "特强浓雾"
        }
        
        return "未知"
    }
    
}
