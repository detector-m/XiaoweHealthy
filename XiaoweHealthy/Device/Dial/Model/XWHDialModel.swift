//
//  XWHDialModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import Foundation
import HandyJSON

// MARK: - 表盘模型
class XWHDialModel: HandyJSON, CustomDebugStringConvertible {
    
    var identifier = ""
    
    // dialNo
    var dialNo = ""
    // dialName
    var name = ""
    
    var width = 0
    var height = 0
    
    // dialImage
    var image = ""
    
    // dialFile
    var file = ""
    
    var debugDescription: String {
        "{ identifier = \(identifier), dialNo = \(dialNo), name = \(name) width = \(width), height = \(height) }"
    }
    
    required init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            name <-- "dialName"        
        mapper <<<
            image <-- "dialImage"
        mapper <<<
            file <-- "dialFile"
        
        mapper >>> identifier
    }
    
}
