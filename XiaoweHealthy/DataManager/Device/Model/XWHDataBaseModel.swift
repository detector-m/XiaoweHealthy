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
        return "identifier = \(identifier)"
    }
    
    override init() {
        super.init()
    }
    
    convenience init(_ identifier: String) {
        self.init()
        self.identifier = identifier
    }
    
    required init(row: Row) {
        super.init(row: row)
    }
    
}
