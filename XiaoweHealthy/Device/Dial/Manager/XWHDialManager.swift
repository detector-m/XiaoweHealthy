//
//  XWHDialManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/16.
//

import Foundation
import Tiercel


class XWHDialManager {
    
    static let shared: XWHDialManager = XWHDialManager()
    
    private static let kInstallTimeout: TimeInterval = 120
    
    private lazy var downloader = XWHDownloader()
    
    private init() {
        
    }
    
    // 下载表盘
    class func download(url: URLConvertible, progressHandler: ProgressHandler? = nil, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        shared.download(url: url, progressHandler: progressHandler, failureHandler: failureHandler, successHandler: successHandler)
    }
    
    // 下载表盘
    func download(url: URLConvertible, progressHandler: ProgressHandler? = nil, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
//        downloader.download(url: url) { pRes in
//            progressHandler?(pRes)
//        } failureHandler: { error in
//            failureHandler?(error)
//        } successHandler: { sRes in
//            successHandler?(sRes)
//        }
        
        downloader.download(url: url, progressHandler: progressHandler, failureHandler: failureHandler, successHandler: successHandler)
    }
    
    
    // 安装表盘
    class func install(url: URL, progressHandler: DevTransferProgressHandler? = nil, handler: XWHDevCmdOperationHandler? = nil) {
        shared.install(url: url, progressHandler: progressHandler, handler: handler)
    }
    
    // 安装表盘
    func install(url: URL, progressHandler: DevTransferProgressHandler? = nil, handler: XWHDevCmdOperationHandler? = nil) {
        //        let fileName = "D391901_pix360x360_rgb565"
        //
        //        guard let dialUrl = Bundle.main.url(forResource: fileName, withExtension: "bin") else {
        //            return
        //        }
        
        log.debug("安装表盘的文件路径 = \(url.path)")
        guard let dev = ddManager.getCurrentDevice() else {
            return
        }
        XWHDDMShared.config(device: dev)
        XWHDDMShared.sendDialFile(url, progressHandler: progressHandler, handler: handler)
    }
}
