//
//  XWHUTECmdOperationHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/10.
//

import UIKit
import UTESmartBandApi

class XWHUTECmdOperationHandler: XWHDevCmdOperationProtocol {
    
    // MARK: - 变量
    var manager: UTESmartBandClient {
        return UTESmartBandClient.sharedInstance()
    }
    
    func config(handler: XWHDevCmdOperationHandler?) {
        setTime(handler: handler)
        setUnit(handler: handler)
        
        if let user = XWHDataUserManager.get() {
            setUserInfo(user: user, handler: handler)
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
    
    func setUserInfo(user: XWHUserModel, handler: XWHDevCmdOperationHandler?) {
        log.info("UTE 设置用户信息")
        
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

        infoModel.lightTime = 6
        
        infoModel.sportTarget = 8000
        
        // 手灯
        infoModel.handlight = 0
        
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
    

}
