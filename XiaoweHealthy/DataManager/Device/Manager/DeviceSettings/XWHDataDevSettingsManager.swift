//
//  XWHDataDevSettingsManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import GRDB


// MARK: - 消息通知数据管理
class XWHDataNoticeSetManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createNoticeSetTable(_ db: Database) throws {
        try db.create(table: XWHNoticeSetModel.databaseTableName, body: { t in
            t.column(XWHNoticeSetModel.Columns.identifier.name, .text).primaryKey()
            
            t.column(XWHNoticeSetModel.Columns.isOn.name, .boolean)
            
            t.column(XWHNoticeSetModel.Columns.isOnCall.name, .boolean)
            
            t.column(XWHNoticeSetModel.Columns.isOnSms.name, .boolean)
            
            t.column(XWHNoticeSetModel.Columns.isOnWeChat.name, .boolean)
            t.column(XWHNoticeSetModel.Columns.isOnQQ.name, .boolean)
        })
    }
    
}
