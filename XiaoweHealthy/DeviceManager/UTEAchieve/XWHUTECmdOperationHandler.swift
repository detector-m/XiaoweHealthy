//
//  XWHUTECmdOperationHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/10.
//

import UIKit
import UTESmartBandApi
import Alamofire
import SwiftUI

class XWHUTECmdOperationHandler: XWHDevCmdOperationProtocol {
    
    // MARK: - 变量
    var manager: UTESmartBandClient {
        return UTESmartBandClient.sharedInstance()
    }
    
    // 传输进度handler
    var transferProgressHandler: DevTransferProgressHandler?
    var transferResultHandler: XWHDevCmdOperationHandler?
    
    // 天气服务数据处理
//    private var _wsHandler: XWHWeatherServiceProtocol?
    var wsHandler: XWHWeatherServiceProtocol?
    
    func config(_ user: XWHUserModel?, _ raiseWristSet: XWHRaiseWristSetModel?, handler: XWHDevCmdOperationHandler?) {
        setTime(handler: handler)
        setUnit(handler: handler)
        
        if let user = XWHDataUserManager.getCurrentUser() {
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
            
            let devId = connDevice.identifier ?? ""
//            retWatchModel.identifier = XWHDeviceHelper.getStandardDeviceSn(devId)
            retWatchModel.identifier = devId

            let devMac = connDevice.addressStr ?? ""
            retWatchModel.mac = XWHDeviceHelper.getStandardFormatMac(devMac)

            retWatchModel.battery = connDevice.battery
            retWatchModel.name = connDevice.name
            retWatchModel.version = connDevice.version ?? ""
            
            retWatchModel.isCurrent = true
            
            response.data = retWatchModel
            
            handler?(.success(response))
        } else {
            var error = XWHError()
            error.identifier = retIdStr
            error.message = "设备未连接"
            
            handler?(.failure(error))
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [unowned self] in
//            if let connDevice = self.manager.connectedDevicesModel {
//                let response = XWHResponse()
//                response.identifier = retIdStr
//
//                let retWatchModel = XWHDevWatchModel()
//                retWatchModel.identifier = connDevice.identifier
//                retWatchModel.battery = connDevice.battery
//                retWatchModel.name = connDevice.name
//                retWatchModel.mac = connDevice.addressStr ?? ""
//                retWatchModel.version = connDevice.version ?? ""
//                retWatchModel.isCurrent = true
//
//                response.data = retWatchModel
//
//                handler?(.success(response))
//            } else {
//                var error = XWHError()
//                error.identifier = retIdStr
//                error.message = "设备未连接"
//
//                handler?(.failure(error))
//            }
//        }
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
        var boTimeInterval = UTECommonTestTime.time30Mins
        if bloodOxygenSet.duration <= 10 {
            boTimeInterval = .time10Mins
        } else if bloodOxygenSet.duration <= 30 {
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
        
        // 设置血氧开关
        if bloodOxygenSet.isSetBeginEndTime {
            manager.setBloodOxygenAutoTestDuration(false, startTime: bloodOxygenSet.beginTime, endTime: bloodOxygenSet.endTime)
        } else {
            manager.setBloodOxygenAutoTestDuration(bloodOxygenSet.isOn, startTime: bloodOxygenSet.beginTime, endTime: bloodOxygenSet.endTime)
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
        handler?(.success(nil))
    }
    
    /// 同步天气信息
    func sendWeatherInfo(_ weatherInfo: XWHWeatherInfoModel, handler: XWHDevCmdOperationHandler?) {
//        UTEModelWeatherInfo
        guard let uteConnModel = manager.connectedDevicesModel else {
            handleDisconnectError(handler)
            return
        }
        
        if uteConnModel.isHasWeatherSeven {
            if weatherInfo.items.count < 2 {
                let errorMsg = "传入的天气信息有误"
                log.error(errorMsg)
                handler?(.failure(XWHError(message: errorMsg)))
                return
            }
            
            let uteWeatherItems: [UTEModelWeather] = weatherInfo.items.map { one in
                let uteOne = UTEModelWeather()
                uteOne.city = weatherInfo.cityName
                uteOne.temperatureMax = one.maxTemp
                uteOne.temperatureMin = one.minTemp
                uteOne.type = manager.getUTEWeatherType(one.code)
                
                return uteOne
            }
            
            uteWeatherItems[0].temperatureCurrent = weatherInfo.tempNow
            
            manager.sendUTESevenWeather(uteWeatherItems)
            
            handler?(.success(nil))
        } else if uteConnModel.isHasWeather {
            if weatherInfo.items.count < 2 {
                let errorMsg = "传入的天气信息有误"
                log.error(errorMsg)
                handler?(.failure(XWHError(message: errorMsg)))
                return
            }
            
            let today = weatherInfo.items[0]
            let tom = weatherInfo.items[1]
            
            let todayType = manager.getUTEWeatherType(today.code)
            let tomType = manager.getUTEWeatherType(tom.code)
            manager.sendUTETodayWeather(todayType, currentTemp: weatherInfo.tempNow, maxTemp: today.maxTemp, minTemp: today.minTemp, pm25: 0, aqi: 0, tomorrowType: tomType, tmrMax: tom.maxTemp, tmrMin: tom.maxTemp)
            
            handler?(.success(nil))
        } else {
            let errorMsg = "不支持天气设置"
            log.error(errorMsg)
            handler?(.failure(XWHError(message: "不支持天气设置")))
        }
    }
    
    /// 同步天气服务的天气信息信息
    func sendWeatherServiceWeatherInfo(cityId: String? = nil, latitude: Double, longitude: Double, handler: XWHDevCmdOperationHandler?) {
        wsHandler?.getWeatherServiceWeatherInfo(cityId: cityId, latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success(let weatherInfo):
                self?.sendWeatherInfo(weatherInfo, handler: handler)

            case .failure(let error):
                handler?(.failure(error))
            }
        }        
    }
    
    /// 同步联系人
    func sendContact(_ contacts: [XWHDevContactModel], handler: XWHDevCmdOperationHandler?) {
        if !checkUTEConnectBind(handler: handler) {
            return
        }
        
        let uteContacts = getUTEContacts(contacts)
        manager.sendUTEContactInfo(uteContacts) {
            DispatchQueue.main.async {
                handler?(.success(nil))
            }
        }
    }
    
    // MARK: - 表盘（Dial）
    /// 发送表盘数据
    func sendDialData(_ data: Data, progressHandler: DevTransferProgressHandler?, handler: XWHDevCmdOperationHandler?) {
        if !checkUTEConnectBind(handler: handler) {
            return
        }
        
        var error = XWHError()
        error.message = "发送表盘数据失败"
        error.data = XWHDevDataTransferState.failed
        
        if data.isEmpty {
            error.message = "发送表盘数据为空"
            
            log.error(error)
            
            handler?(.failure(error))
            
            return
        }
        
        log.info("UTE 发送表盘数据")
        manager.sendUTEDisplayData(toDevice: data) { cp in
            DispatchQueue.main.async {
                progressHandler?((cp * 100) .int)
            }
        } success: {
            DispatchQueue.main.async {
                handler?(.success(nil))
            }
        } failure: { cErr in
            log.error(cErr)
            DispatchQueue.main.async {
                handler?(.failure(error))
            }
        }
    }
    
    /// 发送表盘文件
    func sendDialFile(_ fileUrl: URL, progressHandler: DevTransferProgressHandler?, handler: XWHDevCmdOperationHandler?) {
        if !checkUTEConnectBind(handler: handler) {
            return
        }
        
        var error = XWHError()
        error.message = "发送表盘文件失败"
        error.data = XWHDevDataTransferState.failed
        
//        if !fileUrl.isFileURL {
//            error.message = "发送表盘文件路径错误"
//
//            log.error("\(error), \(fileUrl)")
//
//            handler?(.failure(error))
//            return
//        }
        
        guard let dailData = try? Data(contentsOf: fileUrl) else {
            error.message = "发送表盘文件路径错误"
            
            log.error("\(error), \(fileUrl)")
            
            handler?(.failure(error))
            
            return
        }
        
        log.info("UTE 发送表盘文件 fileUrl = \(fileUrl.path)")
        sendDialData(dailData, progressHandler: progressHandler, handler: handler)
    }
    
    // MARK: - 固件 （Firmware）
    /// 发送固件文件
    func sendFirmwareFile(_ fileUrl: URL, progressHandler: DevTransferProgressHandler?, handler: XWHDevCmdOperationHandler?) {
        var error = XWHError()
        error.message = "发送固件文件失败"
        error.data = XWHDevDataTransferState.failed
        
        transferProgressHandler = nil
        transferResultHandler = nil
        
        if !fileUrl.isFileURL {
            error.message = "发送固件文件路径错误"
            
            log.error("\(error), \(fileUrl)")
            
            handler?(.failure(error))
            return
        }
        
        // 请修改固件名称与当前设备完整的名称类似（UTEModelDevices.version,如SH0AV0000564.bin）
        let isOk = manager.updateLocalFirmwareUrl(fileUrl.path)
        if isOk {
            // 开始升级
            log.info("UTE 发送固件文件")
            transferProgressHandler = progressHandler
            transferResultHandler = handler
            manager.beginUpdateFirmware()
        } else {
            // 固件名称不对，请修改。或固件文件不存在、版本不一致。
            error.message = "固件名称不对，请修改。或固件文件不存在、版本不一致。"
            log.error("\(error), \(fileUrl)")
            
            handler?(.failure(error))
        }
    }
    
    // MARK: - 设备数据传输处理
    /// 处理数据传输结果
    /// - Parameters:
    ///     - tProgress: 进度
    func handleTransferProgress(_ tProgress: Int) {
        transferProgressHandler?(tProgress)
    }
    
    /// 处理数据传输结果
    /// - Parameters:
    ///     - result: 结果<传输状态, 传输错误>
    func handleTransferResult(_ result: Result<XWHDevDataTransferState, XWHError>) {
        switch result {
        case .success(let tState):
            let res = XWHResponse()
            res.data = tState
            
            transferResultHandler?(.success(res))
            if tState == .succeed {
                transferProgressHandler = nil
                transferResultHandler = nil
            }
            
        case .failure(let error):
            transferResultHandler?(.failure(error))
            
            transferProgressHandler = nil
            transferResultHandler = nil
        }
    }

}

// MARK: - Private
extension XWHUTECmdOperationHandler {
    
    private func handleDisconnectError(_ handler: XWHDevCmdOperationHandler?) {
        var error = XWHError()
        error.message = "设备未连接"
        log.error(error.message)
        handler?(.failure(error))
    }
    
}

// MARK: - Private (UTE)
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
    
    private func getUTEContacts(_ contacts: [XWHDevContactModel]) -> [UTEModelContactInfo] {
        let uteContacts = contacts.map { contact -> UTEModelContactInfo in
            let uteContact = UTEModelContactInfo()
            uteContact.name = contact.name
            uteContact.number = contact.number
            
            return uteContact
        }
        
        return uteContacts
    }
    
    private func isUTEConnectBind() -> Bool {
        if let _ = manager.connectedDevicesModel {
            return true
        }
        
        return false
    }
    
    private func checkUTEConnectBind(handler: XWHDevCmdOperationHandler?) -> Bool {
        if isUTEConnectBind() {
            return true
        }
        
        let error = XWHError(message: "未连接绑定")
        log.error(error)
        handler?(.failure(error))
        
        return false
    }
    
}
