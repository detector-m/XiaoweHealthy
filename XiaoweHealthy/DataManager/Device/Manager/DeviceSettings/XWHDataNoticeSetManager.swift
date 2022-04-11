//
//  XWHDataNoticeSetManager.swift
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
    
    class func saveNoticeSet(_ noticeSet: XWHNoticeSetModel) {
        appDB.write { db in
            try noticeSet.save(db)
        }
    }
    
    class func getNoticeSet(identifier: String) -> XWHNoticeSetModel? {
        appDB.read { db in
//            try XWHNoticeSetModel.filter(XWHNoticeSetModel.Columns.identifier == identifier).fetchOne(db)
            try XWHNoticeSetModel.fetchOne(db, key: identifier)
        }
    }
    
    class func deleteNoticeSet(identifier: String) {
        appDB.write { db in
            try XWHNoticeSetModel.deleteOne(db, key: identifier)
        }
    }
    
    class func deleteNoticeSet(_ noticeSet: XWHNoticeSetModel) {
        appDB.write { db in
//            try XWHDevWatchModel.deleteOne(db, key: devWatch.identifier)
            try noticeSet.delete(db)
        }
    }
    
    class func deleteAllNoticeSet() {
        appDB.write { db in
            try XWHNoticeSetModel.deleteAll(db)
        }
    }
    
}
