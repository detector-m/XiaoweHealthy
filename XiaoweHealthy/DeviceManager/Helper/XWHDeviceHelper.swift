//
//  XWHDeviceHelper.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/8.
//

import Foundation


class XWHDeviceHelper {
    
    static let standardTimeFormat = "yyyy-MM-dd HH:mm:ss"
    
    static let standardYMDFormat = "yyyy-MM-dd"
    
    static var sleepCollectionTimeFormat: String {
        return standardYMDFormat
    }
    
    
    class func getStandardDeviceSn(_ identifier: String) -> String {
        var devId = identifier
        let devIdArray: [String] = devId.compactMap({ c in
            if c.isNumber {
                return c.string
            }
            
            return nil
        })
        
        devId = devIdArray.joined(separator: "")
        if devId.count > 19 {
            devId = devId[..<19]?.string ?? ""
        } else {
            let tmpStr = String.init(repeating: "0", count: 19 - devId.count)
            devId += tmpStr
        }
        
        return devId
    }
    
    class func getStandardFormatMac(_ mac: String) -> String {
//        var devMac = "f802b7112283"
        if mac.contains(":") {
            return mac
        }
        
        var retMac = mac
        var macArray = [String]()
        var tmpStr = ""
        for (i, s) in mac.enumerated() {
            tmpStr += s.string
            if i % 2 == 1 {
                macArray.append(tmpStr)
                tmpStr = ""
            }
        }
        
        retMac = macArray.joined(separator: ":")
        log.debug(retMac)
        
        return retMac
    }
    
}
