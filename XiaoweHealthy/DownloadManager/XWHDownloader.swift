//
//  XWHDownloader.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/6.
//

import Foundation
import Tiercel


class XWHDownloader {
    
    private(set) lazy var downloader: SessionManager = {
        var sessionConfiguration = SessionConfiguration()
        sessionConfiguration.allowsCellularAccess = true
        
        let _sManager = SessionManager("XWHFileDownload", configuration: sessionConfiguration)
        
        return _sManager
    }()
    
    func download(url: URLConvertible, headers: [String: String]? = ["Accept-Encoding": ""], fileName: String? = nil, onMainQueue: Bool = true) {
        let timeoutTask = XWHTimeoutHandler.delay(by: XWHTimeoutHandler.kTimeoutTS) {
            self.downloader.cancel(url)
            
            log.error("下载文件超时 url = \(url)")
        }
        
        let cTask = downloader.download(url, headers: headers, fileName: fileName, onMainQueue: onMainQueue)?.progress(handler: { task in
            var cPrgress = 0
            if task.progress.fractionCompleted <= 0 {
                cPrgress = 1
            } else {
                cPrgress = Int(task.progress.fractionCompleted * 100)
            }
        }).completion(handler: { task in
            XWHTimeoutHandler.delayCancel(timeoutTask)
        })
        
        if cTask == nil {
            XWHTimeoutHandler.delayCancel(timeoutTask)

            log.error("创建下载文件任务失败 url = \(url)")
        }
    }
    
}