//
//  XWHHealthyDataBaseModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/29.
//

import Foundation
import HandyJSON
import GRDB

class XWHHealthyDataBaseModel: XWHDataBaseModel {
    
    var time = ""
    
//    var formatDate: Date? {
//        time.date(withFormat: standardTimeFormat)
//    }
    
    required init(row: Row) {
        super.init(row: row)
    }
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    
    // MARK: - Methods
    func formatDate() -> Date? {
        time.date(withFormat: standardTimeFormat)
    }
    
}
