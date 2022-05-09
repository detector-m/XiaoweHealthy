//
//  XWHDataMentalStressSetManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/9.
//

import Foundation
import GRDB


// MARK: - 精神压力设置数据管理
class XWHDataMentalStressSetManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createMentalStressSetTable(_ db: Database) throws {
        try db.create(table: XWHMentalStressSetModel.databaseTableName, body: { t in
            t.column(XWHMentalStressSetModel.Columns.identifier.name, .text).primaryKey()

            t.column(XWHMentalStressSetModel.Columns.isOn.name, .boolean)
        })
    }
    
    class func saveMentalStressSet(_ mentalStress: XWHMentalStressSetModel) {
        appDB.write { db in
            try mentalStress.save(db)
        }
    }
    
    class func getMentalStressSet(identifier: String) -> XWHMentalStressSetModel? {
        appDB.read { db in
            try XWHMentalStressSetModel.fetchOne(db, key: identifier)
        }
    }
    
    class func deleteMentalStressSet(identifier: String) {
        appDB.write { db in
            try XWHMentalStressSetModel.deleteOne(db, key: identifier)
        }
    }
    
    class func deleteMentalStressSet(_ mentalStressSet: XWHMentalStressSetModel) {
        appDB.write { db in
            try mentalStressSet.delete(db)
        }
    }
    
    class func deleteAllMentalStressSet() {
        appDB.write { db in
            try XWHMentalStressSetModel.deleteAll(db)
        }
    }
    
}
