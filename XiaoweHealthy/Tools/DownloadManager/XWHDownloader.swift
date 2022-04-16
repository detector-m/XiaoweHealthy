//
//  XWHDownloader.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/6.
//

import Foundation
import Tiercel


class XWHDownloader {
    
    deinit {
        log.debug("xxxx")
    }
    
    private(set) lazy var downloader: SessionManager = {
        var sessionConfiguration = SessionConfiguration()
        sessionConfiguration.allowsCellularAccess = true
        
        let _sManager = SessionManager("XWHFileDownload", configuration: sessionConfiguration)
        
        return _sManager
    }()
    
    func download(url: URLConvertible, headers: [String: String]? = ["Accept-Encoding": ""], fileName: String? = nil, onMainQueue: Bool = true, progressHandler: ProgressHandler? = nil, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let timeoutTask = XWHTimeoutHandler.delay(by: XWHTimeoutHandler.kTimeoutTS) {
            self.downloader.cancel(url)
            
            let error = XWHError(message: "下载失败")
            log.error("下载文件超时 url = \(url)")
            failureHandler?(error)
        }
        
        let cTask = downloader.download(url, headers: headers, fileName: fileName, onMainQueue: onMainQueue)?.progress(handler: { task in
            let res = XWHResponse()
            var cPrgress = 0
            if task.progress.fractionCompleted <= 0 {
                cPrgress = 1
            } else {
                cPrgress = Int(task.progress.fractionCompleted * 100)
            }
            res.progress = cPrgress
            progressHandler?(res)
        }).completion(handler: { task in
            if task.status == .removed {
                return
            }
            
            XWHTimeoutHandler.delayCancel(timeoutTask)

            if task.status == .failed {
                let error = XWHError(message: "下载失败")
                log.error("下载文件失败 url = \(url)")
                failureHandler?(error)
                
                return
            }
            
            if task.status == .succeeded {
                let res = XWHResponse()
                res.progress = 100
                
                let fileUrl = URL(fileURLWithPath: task.filePath)
                res.data = fileUrl
                
                successHandler?(res)
                return
            }
        })
        
        if cTask == nil {
            XWHTimeoutHandler.delayCancel(timeoutTask)

            let error = XWHError(message: "下载失败")
            log.error("创建下载文件任务失败 url = \(url)")
            failureHandler?(error)
        }
    }
    
}
