//
//  XWHDeviceProductModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/8.
//

import Foundation
import HandyJSON


struct XWHDeviceProductModel: HandyJSON {
    
    // 产品品牌
    var brand = ""
    
    // 产品型号
    var mode = ""
    
    // 产品图片
    var cover = ""
    // 用于合成该手表型号展示图片的底图
    var draftImg = ""
    
}
