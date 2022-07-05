//
//  XWHSportVM.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/1.
//

import Foundation


class XWHSportVM {
    
    /// 获取运动列表
    func getSports(year: Int, type: XWHSportType, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let intType = XWHSportFunction.getSportIndexToServer(sType: type)
        sportProvider.request(.getSports(year, intType)) { result in
            let cId = "Sport.getSports"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = [XWHSportMonthRecordModel].deserialize(from: json.arrayObject)
                return nil
            }
        }
    }
    
    /// 获取总的运动记录
    func getSportTotalRecord(type: XWHSportType, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        let intType = XWHSportFunction.getSportIndexToServer(sType: type)
        sportProvider.request(.getSportTotalRecord(intType)) { result in
            let cId = "Sport.getSportTotalRecord"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = XWHSportTotalRecordModel.deserialize(from: json.dictionaryObject)
                return nil
            }
        }
    }
    
    
    /// 获取运动详情
    func getSportDetail(sportId: Int, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        sportProvider.request(.getSportDetail(sportId)) { result in
            let cId = "Sport.getSportDetail"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = XWHSportModel.deserialize(from: json.dictionaryObject)
                return nil
            }
        }
    }
    
}
