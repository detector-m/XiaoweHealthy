//
//  XWHCalendarHelper.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/27.
//

import Foundation
import UIKit
import JTAppleCalendar


class XWHCalendarHelper {
    
    static var curColor: UIColor {
        btnBgColor
    }
    
    static var normalColor: UIColor {
        fontDarkColor
    }
    
    static var disableColor: UIColor {
        fontDarkColor.withAlphaComponent(0.22)
    }
    
    static var startDate: Date {
        let cDate = Date().adding(.year, value: -3).yearBegin
        
        return cDate
    }
    
    static var firstDayOfWeek: DaysOfWeek {
        .monday
    }
    
    static var calendarContentInset: CGFloat {
        18
    }
    
    static var calendarInset: CGFloat {
        16
    }
    
    static var calendarWidth: CGFloat {
        let cViewWidth: CGFloat = (UIScreen.main.bounds.width - calendarContentInset * 2 - calendarInset * 2)
        
        var minimumDifference = Int(cViewWidth) % 7 // 最小差值
        if (minimumDifference + Int(cViewWidth)) % 7 != 0 {
            minimumDifference = 7 - minimumDifference
        }
        let maxWidth = CGFloat(minimumDifference) + cViewWidth
        
        return maxWidth + calendarContentInset * 2
    }
    
    static var calendarHeight: CGFloat {
        469
    }
    
}

extension Date {
    
    /// 本地格式化转换
    func localizedString(withFormat: String = "yyyyMMMd HH:mm") -> String {
        let lFormat =  DateFormatter.dateFormat(fromTemplate: withFormat, options: 0, locale: Locale.current) ?? withFormat
        
        return string(withFormat: lFormat)
    }
    
    var dayBegin: Self {
        return beginning(of: .day) ?? self
    }
    
    var weekBegin: Self {
//        return beginning(of: .weekOfMonth) ?? self
        var cd = Calendar.current
        cd.firstWeekday = XWHCalendarHelper.firstDayOfWeek.rawValue
        return cd.date(from: cd.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) ?? self
    }
    
    var monthBegin: Self {
        return beginning(of: .month) ?? self
    }
    
    var yearBegin: Self {
        return beginning(of: .year) ?? self
    }
    
    var weekEnd: Self {
//        return end(of: .weekOfMonth) ?? self
        return weekBegin.adding(.day, value: 7).adding(.second, value: -1)
    }
    
}
