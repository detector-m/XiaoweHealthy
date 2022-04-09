//
//  XWHLog.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/9.
//

import Foundation

let log = XCGLogger.default

class XWHLog {
    
    static var logFileURL: URL = {
        //日志文件地址
        let cachePath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let logURL = cachePath.appendingPathComponent("log.txt")
        
        return logURL
    }()
    
    class func configLog() {
        log.setup(level: .debug, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logFileURL, fileLevel: .debug)
    }
    
}
