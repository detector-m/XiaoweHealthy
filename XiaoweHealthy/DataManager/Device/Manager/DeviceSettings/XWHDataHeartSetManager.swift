//
//  XWHDataHeartSetManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import GRDB


// MARK: - 心率设置数据管理
class XWHDataHeartSetManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createHeartSetTable(_ db: Database) throws {
//        try db.create(table: XWHHeartSetModel.databaseTableName, body: { t in
//            t.column(XWHWeatherSetModel.Columns.identifier.name, .text).primaryKey()
//            
//            t.column(XWHHeartSetModel.Columns.isOn.name, .boolean)
//            t.column(XWHHeartSetModel.Columns.isOnCall.name, .boolean)
//            t.column(XWHHeartSetModel.Columns.isOnSms.name, .boolean)
//            t.column(XWHHeartSetModel.Columns.isOnWeChat.name, .boolean)
//            t.column(XWHHeartSetModel.Columns.isOnQQ.name, .boolean)
//        })
    }
    
}
