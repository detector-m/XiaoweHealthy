//
//  XWHNoticeModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB

// MARK: - 消息通知/来电提醒
class XWHNoticeModel: XWHDataBaseModel {
    
    public enum Columns: String, ColumnExpression {
        case identifier, isOn, isOnCall, isOnSms, isOnWeChat, isOnQQ
    }
    
    class override var databaseTableName: String {
        "notice_model"
    }
    
    /// 总开关
    var isOn = false
    
    /// 电话
    var isOnCall = false
    
    /// 信息
    var isOnSms = false
    /// 微信
    var isOnWeChat = false
    /// QQ
    var isOnQQ = false

}
