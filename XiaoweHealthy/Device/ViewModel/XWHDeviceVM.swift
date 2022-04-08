//
//  XWHDeviceVM.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/26.
//

import Foundation
import Cache


class XWHDeviceVM {
    
    // 获取设备产品列表
    func list(failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        deviceProvider.request(.list) { result in
            let cId = "Device.List"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                response.data = [XWHDeviceProductModel].deserialize(from: json.arrayObject)
                
                return nil
            }
        }
    }
    
    // 检查固件更新
    func firmwareUpdate(deviceSn: String, version: String, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        deviceProvider.request(.firmwareUpdate(deviceSn: deviceSn, version: version)) { result in
            let cId = "Device.FirmwareUpdate"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                response.data = json.dictionaryObject
                
                return nil
            }
        }
    }
        
}
