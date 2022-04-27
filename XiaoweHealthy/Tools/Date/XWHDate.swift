//
//  XWHDate.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/22.
//

import Foundation

class XWHDate {
    
    static let yearFormat = "yyyy"
    static let yearMonthFormat = "yyyyMMM"
    static let yearMonthDayFormat = "yyyyMMMd"
    static let yearMonthDayWeekFormat = "yyyyMMMdEEE"
    
    static let hourMinuteFormat = "HH:mm"
    static let timeAllFormat = "HH:mm:ss"
    
    static let dateTimeAllFormat = "\(yearMonthDayFormat) \(timeAllFormat)"
    
    class func localizedFormat(_ format: String) -> String {
        let lFormat =  DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: Locale.current) ?? format

        return lFormat
    }
    
}
