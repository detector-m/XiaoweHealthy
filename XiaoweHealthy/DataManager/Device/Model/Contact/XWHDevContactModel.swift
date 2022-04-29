//
//  XWHDevContactModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/13.
//

import Foundation
import GRDB


class XWHDevContactModel: XWHDataBaseModel {
    
    enum CodingKeys: String, CodingKey {
        case identifier
        case pid
        case name
        case number
        case isSelected
    }
    
    enum Columns: String, ColumnExpression {
        case pid, identifier, name, number
    }
    
    class override var databaseTableName: String {
        "device_contact_model"
    }

    // 主键
    var pid: Int64?

    /// 属于那个设备 （非主键）
//    var identifier = ""
    
    var name = ""
    var number = ""
    
    // 用于UI设置
    var isSelected = false
    
    override var debugDescription: String {
        return "{ identifier = \(identifier), name = \(name), number = \(number) }"
    }
    
    required init() {
        super.init()
    }
    
    required init(row: Row) {
        super.init(row: row)
        
        pid = row[Columns.pid]
        
        identifier = row[Columns.identifier]
        name = row[Columns.name]
        number = row[Columns.number]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.pid] = pid
        
        container[Columns.identifier] = identifier
        container[Columns.name] = name
        container[Columns.number] = number
    }
    
    override func didInsert(with rowID: Int64, for column: String?) {
        pid = rowID
    }
    
    // MARK: - Encodable
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encodeIfPresent(pid, forKey: .pid)
        try container.encode(name, forKey: .name)
        try container.encode(number, forKey: .number)
        try container.encode(isSelected, forKey: .isSelected)
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        pid = try container.decodeIfPresent(Int64.self, forKey: .pid)
        name = try container.decode(String.self, forKey: .name)
        number = try container.decode(String.self, forKey: .number)
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
    }
    
    override func clone() -> Self {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self) else {
            fatalError("encode failed")
        }
        let decoder = JSONDecoder()
        guard let target = try? decoder.decode(Self.self, from: data) else {
            fatalError("decode failed")
        }
        
        return target
    }
    
}

