//
//  XWHDialCategoryModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import Foundation
import HandyJSON

// MARK: - 表盘分类模型
class XWHDialCategoryModel: HandyJSON, CustomDebugStringConvertible {
    
    var identifier = ""
    
    // categoryId
    var categoryId = 0
    
    // cateName
    var name = ""
    
    var items = [XWHDialModel]()
    
    var debugDescription: String {
        "{ identifier = \(identifier), index = \(categoryId), name = \(name) }"
    }
    
    required init() {
        
    }
    
    func mapping(mapper: HelpingMapper) {
        // specify 'cateName' field in json map to 'name' property in object
        // mapper.specify(property: &name, name: "cateName")
        mapper <<<
            name <-- "cateName"
        
//        mapper.exclude(property: &identifier)
        mapper >>> identifier
    }
    
}
