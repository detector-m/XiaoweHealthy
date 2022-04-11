//
//  XWHDataNoticeManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import GRDB


// MARK: - 消息通知数据管理
class XWHDataNoticeManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createNoticeTable(_ db: Database) throws {
        try db.create(table: XWHNoticeModel.databaseTableName, body: { t in
            t.column(XWHNoticeModel.Columns.identifier.name, .integer).primaryKey()
            t.column(XWHNoticeModel.Columns.isOn.name, .boolean)
            t.column(XWHNoticeModel.Columns.isOnCall.name, .boolean)
            t.column(XWHNoticeModel.Columns.isOnSms.name, .boolean)
            t.column(XWHNoticeModel.Columns.isOnWeChat.name, .boolean)
            t.column(XWHNoticeModel.Columns.isOnQQ.name, .boolean)
        })
    }
    
}
