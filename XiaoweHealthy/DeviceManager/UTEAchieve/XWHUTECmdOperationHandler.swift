//
//  XWHUTECmdOperationHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/10.
//

import UIKit
import UTESmartBandApi
import Alamofire

class XWHUTECmdOperationHandler: XWHDevCmdOperationProtocol {
    
    // MARK: - 变量
    var manager: UTESmartBandClient {
        return UTESmartBandClient.sharedInstance()
    }
    
    func config(_ user: XWHUserModel?, _ raiseWristSet: XWHRaiseWristSetModel?, handler: XWHDevCmdOperationHandler?) {
        setTime(handler: handler)
        setUnit(handler: handler)
        
        if let user = XWHDataUserManager.get() {
            setUserInfo(user, raiseWristSet, handler: handler)
        } else {
            log.error("UTE 获取用户信息失败")
            var error = XWHError()
            error.message = "获取用户信息失败"
            handler?(.failure(error))
        }
    }
    
    func reboot(handler: XWHDevCmdOperationHandler?) {
        log.info("UTE 重启设备")
    }
    
    func reset(handler: XWHDevCmdOperationHandler?) {
        log.info("UTE 恢复出厂设置")
        manager.setUTEOption(UTEOption.deleteDevicesAllData)
        handler?(.success(nil))
    }
    
    func setTime(handler: XWHDevCmdOperationHandler?) {
        log.info("UTE 设置时间")
        
        // 设置设备时间
        manager.setUTEOption(UTEOption.syncTime)
        handler?(.success(nil))
    }
    
    func setUnit(handler: XWHDevCmdOperationHandler?) {
        log.info("UTE 设置单位")
        
        // 设置设备单位:公尺或者英寸
        manager.setUTEOption(UTEOption.unitMeter)
        handler?(.success(nil))
    }
    
    // 设置用户信息
    func setUserInfo(_ user: XWHUserModel, _ raiseWristSet: XWHRaiseWristSetModel?, handler: XWHDevCmdOperationHandler?) {
        log.info("UTE 设置用户信息")
        let infoModel = getUTEDeviceInfo(user)
        infoModel.lightTime = raiseWristSet?.duration ?? 5
        infoModel.handlight = (raiseWristSet?.isOn ?? false) ? 1 : -1
        
        manager.setUTEInfoModel(infoModel)
        
        handler?(.success(nil))
    }
    
    // MARK: - 获取设备信息
    func getDeviceInfo(handler: XWHDevCmdOperationHandler?) {
        let retIdStr = "getDeviceInfo"
        if let connDevice = manager.connectedDevicesModel {
            let response = XWHResponse()
            response.identifier = retIdStr
            
            let retWatchModel = XWHDevWatchModel()
            retWatchModel.identifier = connDevice.identifier
            retWatchModel.battery = connDevice.battery
            retWatchModel.name = connDevice.name
            retWatchModel.mac = connDevice.addressStr ?? ""
            retWatchModel.version = connDevice.version
            retWatchModel.isCurrent = true
            
            response.data = retWatchModel
            
            handler?(.success(response))
        } else {
            var error = XWHError()
            error.identifier = retIdStr
            error.message = "设备未连接"
            
            handler?(.failure(error))
        }
    }
    
    // MARK: - 设备设置
    
    /// 设置抬腕亮屏
    func setRaiseWristSet(_ raiseWristSet: XWHRaiseWristSetModel, _ user: XWHUserModel?, handler: XWHDevCmdOperationHandler?) {
        guard let user = user else {
            var error = XWHError()
            error.message = "UTE 设备设置抬腕 用户信息为空"
            handler?(.failure(error))
            return
        }
        
        setUserInfo(user, raiseWristSet, handler: handler)
    }
    
    // 设置通知设置
    func setNoticeSet(_ noticeSet: XWHNoticeSetModel, handler: XWHDevCmdOperationHandler?) {
        guard let uteConnModel = manager.connectedDevicesModel else {
            var error = XWHError()
            error.message = "设备未连接"
            log.error(error.message)
            handler?(.failure(error))
            
            return
        }
        
        if uteConnModel.isHasSocialNotification || uteConnModel.isHasSocialNotification2 {
            let remindApp = UTEModelDeviceRemindApp()
            
            if noticeSet.isOnCall {
                remindApp.phone = UTEDeviceRemindEnableType.open
            } else {
                remindApp.phone = UTEDeviceRemindEnableType.close
            }
            
            if noticeSet.isOn {
                remindApp.sms = noticeSet.isOnSms ? .open : .close
                remindApp.wechat = noticeSet.isOnWeChat ? .open : .close
                remindApp.qq = noticeSet.isOnQQ ? .open : .close
                
                remindApp.other = .open
            } else {
                let remindType = UTEDeviceRemindEnableType.close
                
                remindApp.sms = remindType
                remindApp.wechat = remindType
                remindApp.qq = remindType
                
                remindApp.other = remindType
            }
            
            manager.setUTERemindApp(remindApp)
        } else {
            if noticeSet.isOnCall {
                setUTEOption(UTEOption.openRemindIncall)
            } else {
                setUTEOption(UTEOption.closeRemindIncall)
            }
            
            if noticeSet.isOn {
                if noticeSet.isOnSms {
                    setUTEOption(UTEOption.openRemindSms)
                } else {
                    setUTEOption(UTEOption.closeRemindSms)
                }
                
                if noticeSet.isOnWeChat {
                    setUTEOption(UTEOption.openRemindWeixin)
                } else {
                    setUTEOption(UTEOption.closeRemindWeixin)
                }
                
                if noticeSet.isOnQQ {
                    setUTEOption(UTEOption.openRemindQQ)
                } else {
                    setUTEOption(UTEOption.closeRemindQQ)
                }
                
                setUTEOption(UTEOption.openRemindMore)
                
            } else {
                setUTEOption(UTEOption.closeRemindSms)
                
                setUTEOption(UTEOption.closeRemindWeixin)
                setUTEOption(UTEOption.closeRemindQQ)
                
                setUTEOption(UTEOption.closeRemindMore)
            }
        }
        
        handler?(.success(nil))
    }

    // 设置久坐提醒
    func setLongSitSet(_ longSitSet: XWHLongSitSetModel, handler: XWHDevCmdOperationHandler?) {
        guard let uteConnModel = manager.connectedDevicesModel else {
            var error = XWHError()
            error.message = "设备未连接"
            log.error(error.message)
            handler?(.failure(error))
            
            return
        }
        
        if uteConnModel.isHasSitRemindDuration {
            let model = UTEModelDeviceSitRemind()
            model.enable = longSitSet.isOn
            model.startTime = longSitSet.beginTime
            model.endTime = longSitSet.endTime
            model.duration = longSitSet.duration
            model.enableSiesta = longSitSet.isSiestaOn
            
            manager.sendUTESitRemindModel(model)
        } else {
            if longSitSet.isOn {
                manager.setUTESitRemindOpenTime(longSitSet.duration)
            } else {
                manager.setUTESitRemindClose()
            }
        }
        
        handler?(.success(nil))
    }
    
    /// 设置血压设置
    func setBloodPressureSet(_ bloodPressureSet: XWHBloodPressureSetModel, handler: XWHDevCmdOperationHandler?) {
        let option: UTEOption = bloodPressureSet.isOn ? .bloodCalibrateStart : .bloodDetectingStop
        
        setUTEOption(option)
        
        handler?(.success(nil))
    }
    
    /// 设置血氧设置
    func setBloodOxygenSet(_ bloodOxygenSet: XWHBloodOxygenSetModel, handler: XWHDevCmdOperationHandler?) {
        // 设置血氧开关
        if bloodOxygenSet.isSetBeginEndTime {
            var boTimeInterval = UTECommonTestTime.time30Mins
            if bloodOxygenSet.duration <= 30 {
                boTimeInterval = .time30Mins
            } else if bloodOxygenSet.duration <= 60 {
                boTimeInterval = .time1Hour
            } else if bloodOxygenSet.duration <= 120 {
                boTimeInterval = .time2Hours
            } else if bloodOxygenSet.duration <= 180 {
                boTimeInterval = .time3Hours
            } else if bloodOxygenSet.duration <= 240 {
                boTimeInterval = .time4Hours
            } else if bloodOxygenSet.duration <= 360 {
                boTimeInterval = .time6Hours
            } else if bloodOxygenSet.duration <= 420 {
                boTimeInterval = .timeAt_8_14_20
            } else {
                boTimeInterval = .timeAt_8_20
            }
            
            manager.setBloodOxygenAutoTest(bloodOxygenSet.isOn, time: boTimeInterval)
        } else {
            manager.setBloodOxygenAutoTestDuration(true, startTime: bloodOxygenSet.beginTime, endTime: bloodOxygenSet.endTime)
        }
        
        handler?(.success(nil))
    }
    
    /// 设置心率设置
    func setHeartSet(_ heartSet: XWHHeartSetModel, _ user: XWHUserModel?, handler: XWHDevCmdOperationHandler?) {
        switch heartSet.optionType {
        case .none:
            let option = heartSet.isOn ? UTEOption.open24HourHRM : UTEOption.close24HourHRM
            
            setUTEOption(option)
            
        case .highWarn:
            guard let cUser = user else {
                var error = XWHError()
                error.message = "设置心率设置 用户信息为空"
                log.error(error.message)
                handler?(.failure(error))
                return
            }
            
            let uteDeviceInfo = getUTEDeviceInfo(cUser)
            uteDeviceInfo.maxHeart = heartSet.isHighWarn ? heartSet.highWarnValue : -1
            setUTEDeviceInfo(uteDeviceInfo)
        }
        
        handler?(.success(nil))
    }
    
    /// 设置勿扰模式设置
    func setDisturbSet(_ disturbSet: XWHDisturbSetModel, handler: XWHDevCmdOperationHandler?) {
        if disturbSet.isOn {
//            * 2.当except为No时，表示一天的“请勿打扰”受类型属性UTESilenceType控制，与startTime和endTime无关。
            var uteTypeRawValue = 0
            if disturbSet.isVibrationOn {
                uteTypeRawValue += UTESilenceType.vibration.rawValue
            }
            if disturbSet.isMessageOn {
                uteTypeRawValue += UTESilenceType.message.rawValue
            }
            
            let uteType = UTESilenceType(rawValue: uteTypeRawValue) ?? .none
            manager.sendUTEAllTime(uteType, exceptStartTime: disturbSet.beginTime, endTime: disturbSet.endTime, except: false)
        } else {
            // 3.如果您想关闭“请勿打扰”，请设置 except=NO 并键入 UTESilenceTypeNone。
            manager.sendUTEAllTime(.none, exceptStartTime: disturbSet.beginTime, endTime: disturbSet.endTime, except: false)
        }
        
        handler?(.success(nil))
    }
    
    /// 设置天气
    func setWeatherSet(_ weatherSet: XWHWeatherSetModel, handler: XWHDevCmdOperationHandler?) {
//        UTEModelWeatherInfo
        manager.sendUTETodayWeather(UTEWeatherType.snow, currentTemp: -2, maxTemp: 10, minTemp: -5, pm25: 100, aqi: 120, tomorrowType: UTEWeatherType.wind, tmrMax: 5, tmrMin: 0)
        handler?(.success(nil))
    }

}

// MARK: - Private
extension XWHUTECmdOperationHandler {
    
    private func getUTEDeviceInfo(_ user: XWHUserModel) -> UTEModelDeviceInfo {
        // 设置设备中身高、体重
        let infoModel = UTEModelDeviceInfo()
        infoModel.heigh = user.height.cgFloat
        infoModel.weight = user.weight.cgFloat
        infoModel.age = user.age
        
        if user.genderType == .female {
            infoModel.sex = UTEDeviceInfoSex.female
        } else if user.genderType == .male {
            infoModel.sex = UTEDeviceInfoSex.male
        } else {
            infoModel.sex = UTEDeviceInfoSex.default
        }
        
        infoModel.sportTarget = user.goal

        // 抬腕亮屏开关
        infoModel.handlight = 0
        infoModel.lightTime = 5
        
        return infoModel
    }
    
    private func setUTEDeviceInfo(_ uteDeviceInfo: UTEModelDeviceInfo) {
        manager.setUTEInfoModel(uteDeviceInfo)
    }
    
    private func setUTEOption(_ option: UTEOption) {
        manager.setUTEOption(option)
    }
    
}
