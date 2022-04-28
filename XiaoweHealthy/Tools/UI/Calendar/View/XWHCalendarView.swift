//
//  XWHCalendarView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/25.
//

import UIKit

typealias XWHCalendarSelectDateHandler = (Date) -> Void

typealias XWHCalendarHandler = (Date, XWHHealthyDateSegmentType) -> Void

class XWHCalendarView: RLPopupContentBaseView {
    
    lazy var dateSegment = XWHDateSegmentView()
    var dateType: XWHHealthyDateSegmentType {
        get {
            dateSegment.sType
        }
        set {
            dateSegment.sType = newValue
        }
    }
    
    /// 选择的日期
//    lazy var sDate = Date()
    
//    var dateFormat: String {
//        switch dateType {
//        case .day:
//            return XWHDate.yearMonthDayFormat
//        case .week:
//            return XWHDate.yearMonthDayFormat
//
//        case .month:
//            return XWHDate.yearMonthFormat
//
//        case .year:
//            return XWHDate.yearFormat
//        }
//    }
    
    lazy var yearView = XWHCalendarYearView()
    lazy var monthView = XWHCalendarMonthView()
    lazy var weekView = XWHCalendarWeekView()
    lazy var dayView = XWHCalendarDayView()
    
    lazy var sYearDate = Date() {
        didSet {
            yearView.sDate = sYearDate
        }
    }
    lazy var sMonthDate = Date() {
        didSet {
            monthView.sDate = sMonthDate
        }
    }
    lazy var sWeekDate = Date() {
        didSet {
            weekView.sDate = sWeekDate
        }
    }
    lazy var sDayDate = Date() {
        didSet {
            dayView.sDate = sDayDate
        }
    }
    
    var calendarHandler: XWHCalendarHandler?
    weak var containerView: XWHCalendarPopupContainer?
        
    override func addSubViews() {
        super.addSubViews()
        
        detailLb.isHidden = true
        cancelBtn.isHidden = true
        confirmBtn.isHidden = true
        
        addSubview(dateSegment)
        
        addSubview(yearView)
        addSubview(monthView)
        addSubview(weekView)
        addSubview(dayView)
        
        configEventAction()
        
        dateSegmentValueChanged(dateType)
    }
    
    override func relayoutSubViews() {
        relayoutDateSegment()
        
        relayoutYearView()
        relayoutMonthView()
        relayoutWeekView()
        relayoutDayView()
    }
    
    @objc final func relayoutDateSegment() {
        dateSegment.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(32)
        }
    }
    
    @objc final func relayoutYearView() {
        yearView.snp.makeConstraints { make in
            make.left.right.equalTo(dateSegment)
            make.top.equalTo(dateSegment.snp.bottom).offset(31)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc final func relayoutMonthView() {
        monthView.snp.makeConstraints { make in
//            make.left.right.equalTo(dateSegment)
//            make.top.equalTo(dateSegment.snp.bottom).offset(31)
//            make.bottom.equalToSuperview()
            make.edges.equalTo(yearView)
        }
    }
    
    @objc final func relayoutWeekView() {
        weekView.snp.makeConstraints { make in
//            make.left.right.equalTo(dateSegment)
//            make.top.equalTo(dateSegment.snp.bottom).offset(31)
//            make.bottom.equalToSuperview()
            make.edges.equalTo(yearView)
        }
    }
    
    @objc final func relayoutDayView() {
        dayView.snp.makeConstraints { make in
//            make.left.right.equalTo(dateSegment)
//            make.top.equalTo(dateSegment.snp.bottom).offset(31)
//            make.bottom.equalToSuperview()
            make.edges.equalTo(yearView)
        }
    }
    
    func setSegmentType(_ sType: XWHHealthyDateSegmentType, animated: Bool = true, shouldSendValueChangedEvent: Bool = false) {
        dateSegment.setSegmentType(sType, animated: animated, shouldSendValueChangedEvent: shouldSendValueChangedEvent)
    }
    
}

extension XWHCalendarView {
    
    func configEventAction() {
        dateSegment.segmentValueChangedHandler = { [unowned self] dateSegmentType in
            self.dateSegmentValueChanged(dateSegmentType)
        }
        
        yearView.selectHandler = { [unowned self] cDate in
            self.calendarHandler?(cDate, .year)
            self.containerView?.close()
        }
        
        monthView.selectHandler = { [unowned self] cDate in
            self.calendarHandler?(cDate, .month)
            self.containerView?.close()
        }
        
        weekView.selectHandler = { [unowned self] cDate in
            self.calendarHandler?(cDate, .week)
            self.containerView?.close()
        }
        
        dayView.selectHandler = { [unowned self] cDate in
            self.calendarHandler?(cDate, .day)
            self.containerView?.close()
        }
    }
    
    func dateSegmentValueChanged(_ segmentType: XWHHealthyDateSegmentType) {
        yearView.isHidden = true
        monthView.isHidden = true
        weekView.isHidden = true
        dayView.isHidden = true
        
        switch segmentType {
        case .day:
            dayView.isHidden = false
//            dayView.sDate = sDate
            
        case .week:
            weekView.isHidden = false
//            weekView.sDate = sDate
            
        case .month:
            monthView.isHidden = false
//            monthView.sDate = sDate
            
        case .year:
            yearView.isHidden = false
//            yearView.sDate = sDate
        }
    }
    
}
