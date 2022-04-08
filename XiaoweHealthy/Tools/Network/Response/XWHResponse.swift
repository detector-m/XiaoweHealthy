//
//  XWHResponse.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/24.
//

import Foundation


class XWHResponse: CustomDebugStringConvertible {
    
    var identifier: String = ""
    
    var tag: Int = 0
    
    var code: String = ""
    
    var message: String = ""
    
    var progress: Int = 0
    
    var data: Any? = nil
    
    var debugDescription: String {
        return "identifier = \(identifier)"
    }
    
}
