//
//  XWHTestModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/9.
//

import Foundation
import GRDB


class XWHTestModel: Codable, FetchableRecord {
    
    var id: Int64?
    var name: String = ""
    var score: Int = 0
    
    var age: Int = 10
    
//    func encode(to container: inout PersistenceContainer) {
//
//    }
    
}

extension XWHTestModel: PersistableRecord, TableRecord {
    
    private enum Columns: String, ColumnExpression {
        case id, name, score
    }
    
    static var databaseTableName: String {
        "deviceModel"
    }
    
    func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = id
        container[Columns.name] = name
        container[Columns.score] = score
    }
    
    func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
}
