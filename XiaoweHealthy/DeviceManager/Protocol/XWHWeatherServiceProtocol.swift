//
//  XWHWeatherServiceProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/14.
//

import Foundation

typealias XWHWeatherServiceHandler = (Result<XWHWeatherInfoModel, XWHError>) -> Void


// MARK: - 天气服务协议
protocol XWHWeatherServiceProtocol {
    
    /// 获取天气服务的天气数据
    /// - Parameters:
    ///     - cityId: 城市代码 (为nil时使用 latitude, longitude )
    ///     - latitude: 纬度
    ///     - longitude: 经度
    ///     - handler: 操作回调结果
    func getWeatherServiceWeatherInfo(cityId: String?, latitude: Double, longitude: Double, handler: XWHWeatherServiceHandler?)
    
}

