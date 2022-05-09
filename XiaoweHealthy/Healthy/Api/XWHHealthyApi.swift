//
//  XWHHealthyApi.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/22.
//

import Foundation
import Moya

let healthyProvider = MoyaProvider<XWHHealthyApi>()

enum XWHHealthyApi {
    
    // MARK: - Heart(心率)
    /// 上传心率数据到服务
//    case postHeart(_ deviceSn: String, _ data: [[String: Any]])
    
    /// 用户心率数据存在的日期
    case getHeartExistDate(_ year: Int, _ month: Int, _ queryType: String)
    
    /// 获取心率数据
    case getHeart(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
    /// 查询心率历史数据
    case getHeartHistory(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
    /// 获取心率记录的详情数据
    case getHeartDetail(_ rId: Int)
    

    // MARK: - BloodOxygen(血氧)
    /// 上传血氧数据到服务
//    case postBloodOxygen(_ deviceSn: String, _ data: [[String: Any]])
    
    /// 用户血氧数据存在的日期
    case getBloodOxygenExistDate(_ year: Int, _ month: Int, _ queryType: String)

    /// 获取血氧
    case getBloodOxygen(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
    /// 查询血氧历史数据
    case getBloodOxygenHistory(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
    /// 获取血氧记录的详情数据
    case getBloodOxygenDetail(_ rId: Int)
    
    // MARK: - Sleep(睡眠)
    /// 用户睡眠数据是否存在的日期
    case getSleepExistDate(_ year: Int, _ month: Int, _ queryType: String)

    /// 获取睡眠数据
    case getSleep(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
    /// 查询睡眠历史数据
    case getSleepHistory(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
    // MARK: - MentalStress(精神压力)
    /// 查询用户压力数据是否存在的日期
    case getMentalStressExistDate(_ year: Int, _ month: Int, _ queryType: String)
    
    /// 获取精神压力
    case getMentalStress(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
    /// 获取精神压力历史数据
    case getMentalStressHistory(_ year: Int, _ month: Int, _ day: Int, _ queryType: String)
    
    /// 获取精神压力记录的详情数据
    case getMentalStressDetail(_ rId: Int)
    
}


extension XWHHealthyApi: XWHServiceTargetType {
    
    var path: String {
        switch self {
//        case .postHeart:
//            return "/device/post_heart_rate"
            
        case .getHeartExistDate:
            return "/device/heart_rate_exist"
            
        case .getHeart:
            return "/device/query_heart_rate"
            
        case .getHeartHistory:
            return "/device/log_heart_rate"
            
        case .getHeartDetail:
            return "/device/specify_heart_rate"
            
            
//        case .postBloodOxygen:
//            return "/device/post_blood_oxygen"
            
        case .getBloodOxygenExistDate:
            return "/device/blood_oxygen_exist"
            
        case .getBloodOxygen:
            return "/device/query_blood_oxygen"
            
        case .getBloodOxygenHistory:
            return "/device/log_blood_oxygen"
            
        case .getBloodOxygenDetail:
            return "/device/specify_blood_oxygen"
            
            
        case .getSleepExistDate:
            return "/device/sleep_data_exist"
            
        case .getSleep:
            return "/device/query_sleep_data"
            
        case .getSleepHistory:
            return "/device/log_sleep_data"
            
            
        case .getMentalStressExistDate:
            return "/device/pressure_data_exist"
            
        case .getMentalStress:
            return "/device/query_pressure_data"
            
        case .getMentalStressHistory:
            return "/device/log_pressure_data"
            
        case .getMentalStressDetail:
            return "/device/specify_pressure_data"
        }
    }
    
    var method: Moya.Method {
        switch self {
//        case .postHeart, .postBloodOxygen:
//            return .post
            
        case .getHeartExistDate, .getBloodOxygenExistDate, .getHeart, .getBloodOxygen, .getHeartHistory, .getBloodOxygenHistory, .getHeartDetail, .getBloodOxygenDetail, .getSleepExistDate, .getSleep, .getSleepHistory, .getMentalStressExistDate, .getMentalStress, .getMentalStressHistory, .getMentalStressDetail:
            return .get
        }
    }
    
    var task: Task {
        var param: [String: Any] = [:]
        
        switch self {
//        case .postHeart(let deviceSn, let data), .postBloodOxygen(let deviceSn, let data):
//            param = ["deviceSn": deviceSn, "data": data]
            
        case .getHeartExistDate(let year, let month, let queryType), .getBloodOxygenExistDate(let year, let month, let queryType), .getSleepExistDate(let year, let month, let queryType), .getMentalStressExistDate(let year, let month, let queryType):
            param = ["year": year, "month": month, "queryType": queryType]
            
        case .getHeart(let year, let month, let day, let queryType), .getBloodOxygen(let year, let month, let day, let queryType), .getSleep(let year, let month, let day, let queryType), .getMentalStress(let year, let month, let day, let queryType):
            param = ["year": year, "month": month, "day": day, "queryType": queryType]
            
        case .getHeartHistory(let year, let month, let day, let queryType), .getBloodOxygenHistory(let year, let month, let day, let queryType), .getSleepHistory(let year, let month, let day, let queryType), .getMentalStressHistory(let year, let month, let day, let queryType):
            param = ["year": year, "month": month, "day": day, "queryType": queryType]
            
        case .getHeartDetail(let rId), .getBloodOxygenDetail(let rId), .getMentalStressDetail(let rId):
            param = ["id": rId]

        }
        
        log.debug("url: \(baseURL.absoluteString + path) param: \(param)")
        
        if param.isEmpty {
            return .requestPlain
        }
        
        return .requestParameters(parameters: param, encoding: parameterEncoding)
    }
    
}
