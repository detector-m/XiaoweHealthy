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
    
    func config(handler: XWHDevCmdOperationHandler?) {
        setTime(handler: handler)
        setUnit(handler: handler)
        
        if let user = XWHDataUserManager.get() {
            setUserInfo(user: user, handler: handler)
        } else {
            log.error("UTE 获取用户信息失败")
        }
    }
    
    func reboot(handler: XWHDevCmdOperationHandler?) {
        
    }
    
    func reset(handler: XWHDevCmdOperationHandler?) {
        log.info("UTE 恢复出厂设置")
    }
    
    func setTime(handler: XWHDevCmdOperationHandler?) {
        log.info("UTE 设置时间")
        
        // 设置设备时间
        manager.setUTEOption(UTEOption.syncTime)
    }
    
    func setUnit(handler: XWHDevCmdOperationHandler?) {
        log.info("UTE 设置单位")
        
        // 设置设备单位:公尺或者英寸
        manager.setUTEOption(UTEOption.unitMeter)
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
    }

}
