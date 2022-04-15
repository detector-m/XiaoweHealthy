//
//  XWHDialVM.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import Foundation
import HandyJSON


class XWHDialVM {
    
    /// 用户新增表盘
    /// - Parameters:
    ///     - dialNo: 表盘ID
    ///     - deviceSn: 设备编号
    ///     - failureHandler: 失败回调
    ///     - successHandler: 成功回调
    func add(dialNo: String, deviceSn: String, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        dialProvider.request(.add(dialNo, deviceSn)) { result in
            let cId = "Dial.Add"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { _,_ in nil }
        }
    }
    
    /// 用户移除表盘
    /// - Parameters:
    ///     - dialNo: 表盘ID
    ///     - deviceSn: 设备编号
    ///     - failureHandler: 失败回调
    ///     - successHandler: 成功回调
    func delete(dialNo: String, deviceSn: String, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        dialProvider.request(.delete(dialNo, deviceSn)) { result in
            let cId = "Dial.Delete"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { _,_ in nil }
        }
    }
    
    /// 获取我的当前设备表盘
    /// - Parameters:
    ///     - deviceSn: 设备编号
    ///     - page: 分页码
    ///     - pageSize: 每页个数
    ///     - failureHandler: 失败回调
    ///     - successHandler: 成功回调
    func getMyDial(deviceSn: String, page: Int = 1, pageSize: Int = 20, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        dialProvider.request(.getMyDial(deviceSn, page, pageSize)) { result in
            let cId = "Dial.GetMyDial"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                response.data = [XWHDialModel].deserialize(from: json.arrayObject)
                
                return nil
            }
        }
    }
    
    /// 表盘市场列表页数据
    /// - Parameters:
    ///     - failureHandler: 失败回调
    ///     - successHandler: 成功回调
    func getMarketDialCategory(failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        dialProvider.request(.getMarketDialCategory) { result in
            let cId = "Dial.GetMarketDialCategory"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                response.data = [XWHDialCategoryModel].deserialize(from: json.arrayObject)
                return nil
            }
        }
    }
    
    /// 表盘市场分类页数据
    /// - Parameters:
    ///     - categoryId: 分类id
    ///     - deviceSn: 设备编号
    ///     - page: 分页码
    ///     - pageSize: 每页个数
    ///     - failureHandler: 失败回调
    ///     - successHandler: 成功回调
    func getMarketCategoryDial(categoryId: Int, deviceSn: String, page: Int = 1, pageSize: Int = 20, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        dialProvider.request(.getMarketCategoryDial(categoryId, deviceSn, page, pageSize)) { result in
            let cId = "Dial.GetMarketCategoryDial"
            XWHNetwork.handleResult(rId: cId, result: result, failureHandler: failureHandler, successHandler: successHandler) { json, response in
                response.data = [XWHDialModel].deserialize(from: json.arrayObject)
                
                return nil
            }
        }
    }
    
}
