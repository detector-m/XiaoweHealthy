//
//  XWHGaodeMapManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/6.
//

import Foundation
import AMapFoundationKit

class XWHGaodeMapManager {
    
    class func config() {
        AMapServices.shared().enableHTTPS = true
        AMapServices.shared().apiKey = kGaodeMapAppKey
    }
    
}
