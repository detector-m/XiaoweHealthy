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
        let logName = Date().string(withFormat: "yyyy-MM-dd") + "-log.txt"
        let logURL = cachePath.appendingPathComponent(logName)
        
        return logURL
    }()
    
    class func configLog() {
        var logLevel: XCGLogger.Level = .debug
        #if DEBUG
        #else
        logLevel = .info
        #endif
        
        log.setup(level: logLevel, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: nil, fileLevel: .debug)
        let logFileDestination: FileDestination = FileDestination(writeToFile: logFileURL, identifier: XCGLogger.Constants.fileDestinationIdentifier, shouldAppend: true)
        log.add(destination: logFileDestination)
        log.logAppDetails(selectedDestination: logFileDestination)
    }
    
}
