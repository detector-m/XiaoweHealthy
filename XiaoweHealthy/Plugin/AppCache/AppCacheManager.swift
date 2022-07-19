//
//  AppCacheManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import Foundation
import Kingfisher

class AppCacheManager {
    
    class func getAllCacheSize(completion: @escaping (Double) -> Void) {
        ImageCache.default.calculateDiskStorageSize { (result) in
            var size: Double = 0
            switch result {
            case .success(let value):
                size = Double(value / 1024 / 1024)
                size = size.rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrAwayFromZero)
                
            case .failure(let error):
                log.error(error)
            }
            
            completion(size)
        }
    }
    
    class func cleanAllCache(completion: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            ImageCache.default.clearDiskCache {
                completion(true)
            }
        }
    }
    
}
