//
//  XWHDataBaseModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import GRDB


class XWHDataBaseModel: Record, CustomStringConvertible, CustomDebugStringConvertible {
    
    /// 标准的时间格式
    static let standardTimeFormat = "yyyy-MM-dd HH:mm:ss"
    
    var standardTimeFormat: String {
        return Self.standardTimeFormat
    }
    
    /// 主键
    var identifier = ""
    
    var description: String {
        "identifier = \(identifier)"
    }
    
    var debugDescription: String {
        return description
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
