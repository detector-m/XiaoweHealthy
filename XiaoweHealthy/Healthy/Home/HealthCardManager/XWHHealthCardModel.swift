//
//  XWHHealthCardModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/10.
//

import UIKit
import GRDB

class XWHHealthCardModel: XWHDataBaseModel {
    
    public enum Columns: String, ColumnExpression, CodingKey {
        case identifier, mac, isHidden, type
    }

    /// 是否隐藏
    var isHidden: Bool = false
    
    /// 卡片类型
    var type = ""
    
    var cardType: XWHHealthyType {
        XWHHealthyType(rawValue: type) ?? .none
    }
    
    override var description: String {
        "{ identifier = \(identifier), mac = \(mac), isHidden = \(isHidden), type = \(type) }"
    }
    
    required init() {
        super.init()
    }
    
    // MARK: - GRDB
    required init(row: Row) {
        super.init(row: row)
        
        identifier = row[Columns.identifier]
        mac = row[Columns.mac]
        isHidden = row[Columns.isHidden]
        type = row[Columns.type]
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.identifier] = identifier
        container[Columns.mac] = mac
        container[Columns.isHidden] = isHidden
        container[Columns.type] = type
    }

    
    // MARK: - HandyJSON
//    override func mapping(mapper: HelpingMapper) {
//        mapper <<<
//            identifier <-- "deviceName"
//
//        mapper >>> identifier
//    }
    
    // MARK: - Encodable
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Columns.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(mac, forKey: .mac)
        try container.encode(isHidden, forKey: .isHidden)
        try container.encode(type, forKey: .type)
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        super.init()
        
        let container = try decoder.container(keyedBy: Columns.self)
        
        identifier = try container.decode(String.self, forKey: .identifier)
        mac = try container.decode(String.self, forKey: .mac)
        isHidden = try container.decode(Bool.self, forKey: .isHidden)
        type = try container.decode(String.self, forKey: .type)
    }
    
}
