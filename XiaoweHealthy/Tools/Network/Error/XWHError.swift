//
//  XWHError.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/24.
//

import Foundation

struct XWHError: Error, CustomDebugStringConvertible, CustomStringConvertible {
    
    var identifier: String = ""
    
    var tag: Int = 0

    var code: String = ""
    var message: String = ""
    
    var data: Any?
    
    // token 过期
    var isExpiredUserToken: Bool {
        if code.int == 10010, message.lowercased().contains("token") {
            return true
        }
        
        return false
    }
    
    var description: String {
        return "identifier = \(identifier), code = \(code), message = \(message), tag = \(tag)"
    }
    
    var debugDescription: String {
        return description
    }
    
    static func handleSysError(_ sysError: Error?) -> String {
        guard let nsError = sysError as NSError? else {
            return ""
        }
        
        return nsError.localizedDescription
    }
    
    init() {

    }
    
    init(message: String) {
        self.message = message
    }
    
}
