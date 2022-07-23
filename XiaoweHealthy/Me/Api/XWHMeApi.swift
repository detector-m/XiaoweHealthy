//
//  XWHMeApi.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/23.
//

import Foundation
import Moya

let meProvider = MoyaProvider<XWHMeApi>()

enum XWHMeApi {
    
    /// 上传意见反馈
    
}

extension XWHMeApi: XWHServiceTargetType {
    
    var path: String {
//        switch self {
//        case .getSports:
//        }
        return ""
    }
    

    var method: Moya.Method {
//        switch self {
//        case .getSports, .getSportTotalRecord, .getSportDetail:
//            return .get
//        }
        
        return .get
    }

    var task: Task {
        var param: [String: Any] = [:]

//        switch self {
//        case .getSportDetail(let sportId):
//            param = ["sport_id": sportId]
//        }

        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")

        if param.isEmpty {
            return .requestPlain
        }

        return .requestParameters(parameters: param, encoding: parameterEncoding)
    }
    
}
