//
//  XWHDataLongSitSetManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import GRDB


// MARK: - 久坐设置数据管理
class XWHDataLongSitSetManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createLongSitSetTable(_ db: Database) throws {
        try db.create(table: XWHLongSitSetModel.databaseTableName, body: { t in
            t.column(XWHLongSitSetModel.Columns.identifier.name, .text).primaryKey()
            
            t.column(XWHLongSitSetModel.Columns.isOn.name, .boolean)
            
            t.column(XWHLongSitSetModel.Columns.beginTime.name, .text)
            t.column(XWHLongSitSetModel.Columns.endTime.name, .text)
            t.column(XWHLongSitSetModel.Columns.duration.name, .integer)
            
            t.column(XWHLongSitSetModel.Columns.isSiestaOn.name, .boolean)
        })
    }
    
}
