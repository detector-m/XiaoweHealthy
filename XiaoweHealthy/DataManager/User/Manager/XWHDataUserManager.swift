//
//  XWHDataUserManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/9.
//

import Foundation
import GRDB


// MARK: - 用户数据管理
class XWHDataUserManager {
    
    class func getCurrentUser() -> XWHUserModel? {
        guard let cUser = getUser() else {
//            UserDefaults.standard[kToken] = nil
            return nil
        }
        return cUser
    }
    
    class func deleteCurrentUser() {
        guard let cUser = getCurrentUser() else {
            log.error("当前不存在用户")
            return
        }
        
        deleteUser(cUser)
    }
    
    /// 创建设备模型表 (由于 AppDatabase还未初始化，所以当前使用的是在初始化过程中生成的db Handler)
    ///  - Parameter db: 数据库handler
    class func createUserTable(_ db: Database) throws {
        try db.create(table: XWHUserModel.databaseTableName) { t in
//            t.autoIncrementedPrimaryKey("id")
            t.column(XWHUserModel.Columns.mobile.name, .text).primaryKey()
            t.column(XWHUserModel.Columns.nickname.name, .text)
            t.column(XWHUserModel.Columns.avatar.name, .text)
            
            t.column(XWHUserModel.Columns.gender.name, .integer)
            t.column(XWHUserModel.Columns.height.name, .integer)
            t.column(XWHUserModel.Columns.weight.name, .integer)
            t.column(XWHUserModel.Columns.birthday.name, .text)
                        
            t.column(XWHUserModel.Columns.goal.name, .integer)
            
//            t.primaryKey([XWHUserModel.Columns.mobile.name])
        }
    }
    
    class func saveUser(_ user: inout XWHUserModel) {
        appDB.write { db in
            try user.save(db)
        }
    }
    
    private class func getUser() -> XWHUserModel? {
        return appDB.read { db in
            try XWHUserModel.fetchOne(db)
        }
    }
    
    class func deleteUser(_ user: XWHUserModel) {
        log.info("删除用户 user = \(user)")
        
        appDB.write { db in
            try user.delete(db)
        }
    }
    
    class func deleteAll() {
        log.info("删除所有用户")
        
        appDB.write { db in
            try XWHUserModel.deleteAll(db)
        }
    }
    
}

// Login
extension XWHDataUserManager {
    
    private static let kToken = "kToken"
    
    static var isHasToken: Bool {
        guard let _ = getToken() else {
            return false
        }
        
        return true
    }
    
    class func getToken() -> String? {
        return UserDefaults.standard[kToken] as? String
    }
    
    class func setToken(token: String?) {
        UserDefaults.standard[kToken] = token
        if token == nil {
            deleteCurrentUser()
        }
    }
    
    static var isLogined: Bool {
        guard let _ = getToken() else {
            return false
        }
        
        guard let _ = getCurrentUser() else {
            setToken(token: nil)
            return false
        }
        
        return true
    }
    
}

extension XWHDataUserManager {
    
    class func test() {
        var user = XWHUserModel(mobile: "15000847202", nickname: "Riven", avatar: "", gender: 1, height: 168, weight: 57, birthday: "1990-03-16", goal: 9000)
        saveUser(&user)
    }
    
}
