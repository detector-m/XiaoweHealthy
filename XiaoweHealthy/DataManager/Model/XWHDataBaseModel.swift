//
//  XWHDataBaseModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/11.
//

import Foundation
import HandyJSON
import GRDB


class XWHDataBaseModel: Record, HandyJSON, Codable, CustomStringConvertible, CustomDebugStringConvertible {
    
    /// 标准的时间格式
    static let standardTimeFormat = "yyyy-MM-dd HH:mm:ss"
    
    var standardTimeFormat: String {
        return Self.standardTimeFormat
    }
    
    /// 主键
    var identifier = ""
    
    /// mac 地址
    var mac = ""
    
    var description: String {
        "identifier = \(identifier), mac = \(mac)"
    }
    
    var debugDescription: String {
        return description
    }
    
    convenience init(_ identifier: String) {
        self.init()
        self.identifier = identifier
    }
    
    // MARK: GRDB
    required init(row: Row) {
        super.init(row: row)
    }
    
    // MARK: - HandyJSON
    required override init() {
        super.init()
    }
    
    func mapping(mapper: HelpingMapper) {
        
    }
    
    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        super.init()
    }
    
    func clone() -> Self {
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
