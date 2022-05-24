//
//  XWHNoticeSetModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import UIKit
import GRDB

// MARK: - 消息通知/来电提醒 设置
class XWHNoticeSetModel: XWHDataBaseModel {
    
    enum Columns: String, ColumnExpression {
        case identifier, isOn, isOnCall, isOnSms, isOnWeChat, isOnQQ
    }
    
    class override var databaseTableName: String {
        "notice_set_model"
    }
    
    /// 总开关
    var isOn = true
    
    /// 电话
    var isOnCall = true
    
    /// 信息
    var isOnSms = true
    /// 微信
    var isOnWeChat = false
    /// QQ
    var isOnQQ = false
    
    required init() {
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }
    
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[Columns.identifier]

        isOn = row[Columns.isOn]
        
        isOnCall = row[Columns.isOnCall]
        
        isOnSms = row[Columns.isOnSms]
        
        isOnWeChat = row[Columns.isOnWeChat]
        isOnQQ = row[Columns.isOnQQ]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier

        container[Columns.isOn] = isOn
        
        container[Columns.isOnCall] = isOnCall
        
        container[Columns.isOnSms] = isOnSms
        
        container[Columns.isOnWeChat] = isOnWeChat
        container[Columns.isOnQQ] = isOnQQ        
    }

}
