//
//  XWHActivityVM.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/15.
//

import Foundation


class XWHActivityVM {
    
    /// 每日活动数据概览
    func getActivitySums(date: Date, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        activityProvider.request(.getActivitySums(date.year, date.month, XWHHealthyDateSegmentType.day.rawValue)) { result in
            let cId = "Healthy.getActivitySums"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                guard let items = json.arrayObject as? [String] else {
                    log.error("\(cId) 获取用户活动数据概览错误")
                    return nil
                }
                
                response.data = [XWHActivitySumModel].deserialize(from: items)
                
                return nil
            }
        }
    }
    
    /// 获取每日活动数据
    func getActivity(date: Date, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        activityProvider.request(.getActivity(date.year, date.month, date.day, XWHHealthyDateSegmentType.day.rawValue)) { result in
            let cId = "Healthy.getActivity"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = XWHActivitySumModel.deserialize(from: json.arrayValue.first?.dictionaryObject)
                return nil
            }
        }
    }
    
}
