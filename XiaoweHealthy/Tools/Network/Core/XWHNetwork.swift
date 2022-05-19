//
//  XWHNetwork.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/24.
//

import Foundation
import Moya

typealias SuccessHandler = (XWHResponse) -> Void
typealias FailureHandler = (XWHError) -> Void
typealias ProgressHandler = SuccessHandler

typealias ParseDataHandler = (SwiftyJSON.JSON, XWHResponse) -> Any?

class XWHNetwork {
    
    class func handleResult(rId: String, result: Result<Moya.Response, MoyaError>, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil, parseDataHandler: ParseDataHandler? = nil) {
        let cId = rId
        var retError = XWHError()
        retError.identifier = cId
        
        switch result {
        case .failure(let error):
            retError.message = error.errorDescription ?? ""
            
            log.error(retError)
            
            failureHandler?(retError)
            return
            
        case .success(let response):
            let cJson = try? JSON(data: response.data)
            guard let json = cJson else {
                retError.message = tdParseFailed
                
                log.error(retError)
                
                failureHandler?(retError)
                
                return
            }
            
            log.debug(json.dictionaryObject)
            if json["code"].intValue != 0 {
                retError.code = json["code"].stringValue
                retError.message = json["message"].stringValue
                
                log.error(retError)
                
                // Token 过期
                if retError.code.int == 10010, retError.message.lowercased().contains("token") {
                    XWHUser.handleExpiredUserToken()
                }
                
                failureHandler?(retError)
                return
            }
    
            let retRawString = json["data"].rawString() ?? ""
            log.debug("handleResult -> retRawString = \(retRawString)")
            
            let retResponse = XWHResponse()
            retResponse.identifier = cId
            let _ = parseDataHandler?(json["data"], retResponse)
            
            
            successHandler?(retResponse)
        }
    }
    
}
