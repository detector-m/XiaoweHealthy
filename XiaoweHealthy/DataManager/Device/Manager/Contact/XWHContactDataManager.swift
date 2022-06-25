//
//  XWHContactDataManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/17.
//

import Foundation
import GRDB


// MARK: - 联系人数据管理器
class XWHContactDataManager {
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createContactTable(_ db: Database) throws {
        try db.create(table: XWHDevContactModel.databaseTableName, body: { t in
            t.autoIncrementedPrimaryKey(XWHDevContactModel.Columns.pid.name)
            t.column(XWHDevContactModel.Columns.identifier.name, .text)
            
            t.column(XWHDevContactModel.Columns.name.name, .text)
            t.column(XWHDevContactModel.Columns.number.name, .text)
        })
    }
    
    class func saveContacts(_ contacts: [XWHDevContactModel]) {
        appDB.write { db in
            try contacts.forEach({ try $0.save(db) })
        }
    }

    class func getContacts(identifier: String) -> [XWHDevContactModel]? {
        appDB.read { db in
            try XWHDevContactModel.filter(XWHDevContactModel.Columns.identifier == identifier).fetchAll(db)
        }
    }
    
    class func deleteContacts(identifier: String) {
        appDB.write { db in
            try XWHDevContactModel.filter(XWHDevContactModel.Columns.identifier == identifier).deleteAll(db)
        }
    }
    
    class func saveContact(_ contact: XWHDevContactModel) {
        appDB.write { db in
            try contact.save(db)
        }
    }
    
    class func deleteContact(_ contact: XWHDevContactModel) {
        appDB.write { db in
            try contact.delete(db)
        }
    }
    
    class func deleteAllContacts() {
        appDB.write { db in
            try XWHDevContactModel.deleteAll(db)
        }
    }
    
}
