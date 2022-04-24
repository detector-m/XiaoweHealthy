//
//  XWHHeartModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/24.
//

import Foundation
import HandyJSON
import GRDB


/// 心率数据模型
class XWHHeartModel: XWHDataBaseModel, HandyJSON {
    
    var time = ""
    var value = 0
    
    override var debugDescription: String {
        "{identifier = \(identifier), time = \(time), value = \(value)}"
    }
    
    required override init() {
        super.init()
    }
    
    required init(row: Row) {
        super.init(row: row)
    }
    
    // MARK: - HandyJSON
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            time <-- "collectTime"
        mapper <<<
            value <-- "rateVal"
        
        mapper >>> identifier
    }
    
}