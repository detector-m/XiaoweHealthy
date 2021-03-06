//
//  XWHSportApi.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/1.
//

import Foundation
import Moya

let sportProvider = MoyaProvider<XWHSportApi>()

enum XWHSportApi {
    
    /// 获取运动列表
    case getSports(_ year: Int, _ type: Int)
    
    /// 获取总的运动记录
    case getSportTotalRecord(_ type: Int)
    
    /// 获取运动记录详情
    case getSportDetail(_ sportId: Int)
    
}

extension XWHSportApi: XWHServiceTargetType {
    
    var path: String {
        switch self {
        case .getSports:
            return "/sport/query_exercise_log"
            
        case .getSportTotalRecord:
            return "/sport/query_profile_data"
            
        case .getSportDetail:
            return "/sport/specify_exercise_data"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSports, .getSportTotalRecord, .getSportDetail:
            return .get
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        
        switch self {
        case .getSports(let year, let type):
            param = ["year": year, "exercise_type": type]
            if type == 0 {
                param["exercise_type"] = nil
            }
            
        case .getSportTotalRecord(let type):
            param = ["exercise_type": type]
            if type == 0 {
                param["exercise_type"] = nil
            }
            
        case .getSportDetail(let sportId):
            param = ["sport_id": sportId]
        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        
        if param.isEmpty {
            return .requestPlain
        }
        
        return .requestParameters(parameters: param, encoding: parameterEncoding)
    }
    
}
