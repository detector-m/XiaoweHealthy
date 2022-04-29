//
//  XWHHealthyDataBaseModel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/29.
//

import Foundation
import HandyJSON
import GRDB

class XWHHealthyDataBaseModel: XWHDataBaseModel, HandyJSON, Codable {
    
    var time = ""
    
//    var formatDate: Date? {
//        time.date(withFormat: standardTimeFormat)
//    }
        
    required override init() {
        super.init()
    }
    
    required init(row: Row) {
        super.init(row: row)
    }
    
    // MARK: - HandyJSON
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
    
    
    // MARK: - Methods
    func formatDate() -> Date? {
        time.date(withFormat: standardTimeFormat)
    }
    
}
