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
    
    static let monthFormat = "MMM"
    static let monthDayFormat = "MMMd"
    static let monthDayWeekFormat = "MMMdEEE"
    static let dayFormat = "d"
    
    static let standardYearMonthFormat = "yyyy-MM"
    static let standardYearMonthDayFormat = "yyyy-MM-dd"
    static let standardYearMonthDayWeekFormat = "yyyy-MM-dd EEE"
    
    static let hourMinuteFormat = "HH:mm"
    static let timeAllFormat = "HH:mm:ss"
    
    static let YearMonthDayHourMinuteFormat = "\(yearMonthDayFormat) \(hourMinuteFormat)"
    
    static let dateTimeAllFormat = "\(yearMonthDayFormat) \(timeAllFormat)"
    
    static let standardTimeAllFormat = "\(standardYearMonthDayFormat) \(timeAllFormat)"
    
    static let monthDayHourMinute = "MMMd HH:mm"
    
    class func localizedFormat(_ format: String) -> String {
        let lFormat =  DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: Locale.current) ?? format

        return lFormat
    }
    
    
    
}
