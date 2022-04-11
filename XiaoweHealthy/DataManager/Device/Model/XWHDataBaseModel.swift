//
//  XWHDataBaseModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import GRDB


class XWHDataBaseModel: Record, CustomDebugStringConvertible {
    
    /// 主键
    var identifier = ""
    
    var debugDescription: String {
        return "pid = \(identifier)"
    }
    
}
