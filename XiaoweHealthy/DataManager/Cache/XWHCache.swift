//
//  XWHCache.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/6.
//

import Foundation
import Cache

class XWHCache {
    
    private static var storage: Storage<String, Data>?
    
    static var dataStorage: Storage<String, Data>? {
        return storage
    }
    static var stringStorage: Storage<String, String>? {
        return storage?.transformCodable(ofType: String.self)
    }
    
    class func config() {
        let diskConfig = DiskConfig(name: "XWHCache")
        let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

        do {
            storage = try Storage<String, Data>(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forData())
        } catch let error {
            log.error(error)
        }
    }
    
    class func test() {
        var a = try? stringStorage?.object(forKey: "Test")
        
        log.debug(a)
        
        try? stringStorage?.setObject("ABC", forKey: "Test")
        a = try? stringStorage?.object(forKey: "Test")
        log.debug(a)
    }
    
}
