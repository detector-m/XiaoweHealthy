//
//  XWHCalendar.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/27.
//

import Foundation


class XWHCalendar {
    
    class func show(dayDate: Date, weekDate: Date, monthDate: Date, yearDate: Date, _ dateType: XWHHealthyDateSegmentType, _ calendarHandler: XWHCalendarHandler?) {
        let calendarView = XWHCalendarView()
        calendarView.calendarHandler = calendarHandler
        calendarView.backgroundColor = .white
        calendarView.size = CGSize(width: XWHCalendarHelper.calendarWidth, height: XWHCalendarHelper.calendarHeight)
        let calendarContainer =  XWHCalendarPopupContainer.generatePopupWithView(calendarView)
        calendarView.containerView = calendarContainer
        calendarContainer.show()
        
        calendarView.sDayDate = dayDate
        calendarView.sWeekDate = weekDate
        calendarView.sMonthDate = monthDate
        calendarView.sYearDate = yearDate
        calendarView.dateType = dateType
    }
    
}
