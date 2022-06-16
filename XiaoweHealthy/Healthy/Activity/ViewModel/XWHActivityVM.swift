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
        activityProvider.request(.getActivitySums(date.year, date.month, XWHHealthyDateSegmentType.month.rawValue)) { result in
            let cId = "Healthy.getActivitySums"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = [XWHActivitySumUIModel].deserialize(from: json.arrayObject)
                
                return nil
            }
        }
    }
    
    /// 获取每日活动数据
    func getActivity(date: Date, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        activityProvider.request(.getActivity(date.year, date.month, date.day, XWHHealthyDateSegmentType.day.rawValue)) { result in
            let cId = "Healthy.getActivity"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                
                response.data = XWHActivitySumUIModel.deserialize(from: json.dictionaryObject)
                return nil
            }
        }
    }
    
}
