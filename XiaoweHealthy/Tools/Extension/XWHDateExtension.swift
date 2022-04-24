//
//  XWHDateExtension.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/22.
//

import Foundation


extension Date {
    
    /// 本地格式化转换
    func localizedString(withFormat: String = "yyyyMMMd HH:mm") -> String {
        let lFormat =  DateFormatter.dateFormat(fromTemplate: withFormat, options: 0, locale: Locale.current) ?? withFormat
        
        return string(withFormat: lFormat)
    }
    
}