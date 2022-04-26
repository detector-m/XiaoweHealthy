//
//  XWHCalendarView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/25.
//

import UIKit

class XWHCalendarView: RLPopupContentBaseView {
    
    lazy var dateSegment = XWHDateSegmentView()
    var dateType: XWHHealthyDateSegmentType {
        dateSegment.selectedType
    }
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
    lazy var dayView = XWHCalendarDayView()
        
    override func addSubViews() {
        super.addSubViews()
        
        detailLb.isHidden = true
        cancelBtn.isHidden = true
        confirmBtn.isHidden = true
        
        addSubview(dateSegment)
        
        addSubview(yearView)
        addSubview(monthView)
        addSubview(dayView)
        
        configEventAction()
        
        dateSegmentValueChanged(dateType)
    }
    
    override func relayoutSubViews() {
        relayoutDateSegment()
        
        relayoutYearView()
        relayoutMonthView()
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
            make.left.right.equalTo(dateSegment)
            make.top.equalTo(dateSegment.snp.bottom).offset(31)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc final func relayoutDayView() {
        dayView.snp.makeConstraints { make in
            make.left.right.equalTo(dateSegment)
            make.top.equalTo(dateSegment.snp.bottom).offset(31)
            make.bottom.equalToSuperview()
        }
    }
    
}

extension XWHCalendarView {
    
    func configEventAction() {
        dateSegment.segmentValueChangedHandler = { [unowned self] dateSegmentType in
            self.dateSegmentValueChanged(dateSegmentType)
        }
    }
    
    func dateSegmentValueChanged(_ segmentType: XWHHealthyDateSegmentType) {
        yearView.isHidden = true
        monthView.isHidden = true
        dayView.isHidden = true
        switch segmentType {
        case .day:
            dayView.isHidden = false
            
        case .week:
            dayView.isHidden = false
            
        case .month:
            monthView.isHidden = false
            
        case .year:
            yearView.isHidden = false
        }
    }
    
}
