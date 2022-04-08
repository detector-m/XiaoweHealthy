//
//  XWHError.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/24.
//

import Foundation

struct XWHError: Error, CustomDebugStringConvertible {
    
    var identifier: String = ""
    
    var tag: Int = 0

    var code: String = ""
    var message: String = ""
    
    var debugDescription: String {
        return "identifier = \(identifier), code = \(code), message = \(message), tag = \(tag)"
    }
    
}
