//
//  XWHDialDownloadInstallManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/16.
//

import Foundation
import Tiercel


class XWHDialDownloadInstallManager {
    
    class func download(url: URLConvertible, progressHandler: ProgressHandler? = nil, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        XWHDownloader().download(url: url) { pRes in
            progressHandler?(pRes)
        } failureHandler: { error in
            failureHandler?(error)
        } successHandler: { sRes in
            successHandler?(sRes)
        }
    }
    
}
