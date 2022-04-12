//
//  XWHDevCmdOperationProtocol.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/10.
//

import Foundation

typealias XWHDevCmdOperationHandler = ((Result<XWHResponse?, XWHError>) -> Void)


// MARK: - 设备指令操作协议
protocol XWHDevCmdOperationProtocol {
    
    // MARK: - 配置
    
    /// 配置手表
    /// - Parameters:
    ///     - user: 用户信息 （可能需要用户信息）
    ///     - raiseWristSet: 抬腕亮屏（可能部分设备与抬腕亮屏有关联）
    ///     - handler: 操作回调结果
    func config(_ user: XWHUserModel?, _ raiseWristSet: XWHRaiseWristSetModel?, handler: XWHDevCmdOperationHandler?)
    
    // MARK: - 重启/重置
    
    /// 重启设备
    /// - Parameter handler: 操作回调结果
    func reboot(handler: XWHDevCmdOperationHandler?)
    
    /// 重置设备 (恢复出厂设置)
    /// - Parameter handler: 操作回调结果
    func reset(handler: XWHDevCmdOperationHandler?)
    
    // MARK: - 基础指令
    
    /// 设置时间
    /// - Parameter handler: 操作回调结果
    func setTime(handler: XWHDevCmdOperationHandler?)
    
    /// 设置单位
    /// - Parameters:
    ///     - handler: 操作回调结果
    func setUnit(handler: XWHDevCmdOperationHandler?)
    
    /// 设置用户信息
    /// - Parameters:
    ///     - user: 用户信息
    ///     - raiseWristSet: 抬腕亮屏（可能部分设备与抬腕亮屏有关联）
    ///     - handler: 操作回调结果
    func setUserInfo(_ user: XWHUserModel, _ raiseWristSet: XWHRaiseWristSetModel?, handler: XWHDevCmdOperationHandler?)
    
    
    // MARK: - 获取设备信息
    /// 获取设备信息
    /// - Parameters:
    ///     - handler: 操作回调结果 (XWHResponse.data 为 XWHDevWatchModel )
    func getDeviceInfo(handler: XWHDevCmdOperationHandler?)
    
    // MARK: - 设备设置
    
    /// 设置抬腕亮屏
    /// - Parameters:
    ///   - raiseWristSet: 抬腕亮屏模型
    ///   - user: 用户信息 （有些设置可能跟用户有联系）
    ///   - handler: 操作回调结果
    func setRaiseWristSet(_ raiseWristSet: XWHRaiseWristSetModel, _ user: XWHUserModel?, handler: XWHDevCmdOperationHandler?)
    
    /// 设置消息通知
    /// - Parameters:
    ///   - noticeSet: 久坐设置模型
    func setNoticeSet(_ noticeSet: XWHNoticeSetModel, handler: XWHDevCmdOperationHandler?)
    
    /// 设置久坐提醒
    /// - Parameters:
    ///   - longSitSet: 久坐设置模型
    ///   - handler: 操作回调结果
    func setLongSitSet(_ longSitSet: XWHLongSitSetModel, handler: XWHDevCmdOperationHandler?)
    
    /// 设置血压设置
    /// - Parameters:
    ///   - bloodPressureSet: 血压设置模型
    ///   - handler: 操作回调结果
    func setBloodPressureSet(_ bloodPressureSet: XWHBloodPressureSetModel, handler: XWHDevCmdOperationHandler?)
    
    /// 设置血氧设置
    /// - Parameters:
    ///   - bloodOxygenSet: 血氧设置模型
    ///   - handler: 操作回调结果
    func setBloodOxygenSet(_ bloodOxygenSet: XWHBloodOxygenSetModel, handler: XWHDevCmdOperationHandler?)
    
    /// 设置心率设置
    /// - Parameters:
    ///   - heartSet: 心率设置模型
    ///   - user: 用户信息 （有些设置可能跟用户有联系）
    ///   - handler: 操作回调结果
    func setHeartSet(_ heartSet: XWHHeartSetModel, _ user: XWHUserModel?, handler: XWHDevCmdOperationHandler?)
    
    /// 设置勿扰模式设置
    /// - Parameters:
    ///   - disturbSet: 勿扰模式设置
    ///   - handler: 操作回调结果
    func setDisturbSet(_ disturbSet: XWHDisturbSetModel, handler: XWHDevCmdOperationHandler?)
    
    /// 设置天气
    /// - Parameters:
    ///   - weatherSet: 天气设置
    ///   - handler: 操作回调结果
    func setWeatherSet(_ weatherSet: XWHWeatherSetModel, handler: XWHDevCmdOperationHandler?)
    
}

// MARK: - 默认实现
extension XWHDevCmdOperationProtocol {
    
//    func reboot(handler: XWHDevCmdOperationHandler?) {
//        
//    }
    
}
