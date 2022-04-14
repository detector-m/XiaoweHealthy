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
    
    var data: Any?
    
    var debugDescription: String {
        return "identifier = \(identifier), code = \(code), message = \(message), tag = \(tag)"
    }
    
    init() {

    }
    
    init(message: String) {
        self.message = message
    }
    
    static func handleSysError(_ sysError: Error?) -> String {
        guard let nsError = sysError as NSError? else {
            return ""
        }
        
        return nsError.localizedDescription
    }
    
}
