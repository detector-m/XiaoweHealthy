//
//  XWHHealthyExistDataDateModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/28.
//

import Foundation


/// 存在数据的日期模型
class XWHHealthyExistDataDateModel: CustomDebugStringConvertible {
    
    var identifier = ""
    var code = ""
    var items: [Date] = []
    
    var debugDescription: String {
        "{ identifier = \(identifier) }"
    }
    
}
