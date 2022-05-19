//
//  XWHLog.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/9.
//

import Foundation

let log = XCGLogger.default

class XWHLog {
    
    private static var logDir: URL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    private static var logSufix = "-log.txt"
    static var logFileURL: URL = {
        //日志文件地址
        let cachePath = logDir
        let logName = Date().string(withFormat: "yyyy-MM-dd") + logSufix
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
        
        DispatchQueue.global().async {
            clearLogFiles()
        }
    }
    
    class func clearLogFiles() {
        do {
            let logDirPath = logDir.path
            var cFiles = try FileManager.default.contentsOfDirectory(atPath: logDirPath)
            cFiles = cFiles.filter({ $0.hasSuffix(logSufix) }).sorted()
            
            let removeMax = cFiles.count - 7
            if removeMax > 0 {
                for i in 0 ..< removeMax {
                    let iFile = cFiles[i]
                    let cPath = logDirPath.appendingPathComponent(iFile)
                    
                    try FileManager.default.removeItem(atPath: cPath)
                }
            }
        } catch let error {
            log.error(error)
        }
    }
    
}
