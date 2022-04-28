//
//  XWHCalendarDayView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/26.
//

import UIKit
import JTAppleCalendar

class XWHCalendarDayView: UIView, JTACMonthViewDataSource & JTACMonthViewDelegate {
    
    var dateType: XWHHealthyDateSegmentType {
        .day
    }

    lazy var preNextView = XWHCalendarPreNextBtnView(dateType: dateType)
    lazy var weekIndicatiorView = XWHCalendarWeekIndicatorView(config: .init())
    
    /// 日历选择的view
    lazy var monthView = JTACMonthView()
    
    /// 日历开始的时间
    lazy var startDate = XWHCalendarHelper.startDate
    /// 日历的结束时间
    lazy var endDate = Date()
    
    /// 选择的日期
    lazy var sDate = Date() {
        didSet {
            curBeginDate = sDate.monthBegin
        }
    }
    /// 选择日期 日的开始时间
    var sBeginDate: Date {
        sDate.dayBegin
    }
    
    /// 当前的年月开始日期
    lazy var curBeginDate = Date().monthBegin
    
    var selectHandler: XWHCalendarSelectDateHandler?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
        
        configEventAction()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func addSubViews() {
        addSubview(preNextView)
        addSubview(weekIndicatiorView)
        
        monthView.backgroundColor = bgColor
        addSubview(monthView)
        
        configMonthView()
        
        registerViews()
    }
    
    
    // MARK: - 日历配置
    @objc func configMonthView() {
        monthView.calendarDataSource = self
        monthView.calendarDelegate = self
        
        monthView.minimumLineSpacing = 1
        monthView.minimumInteritemSpacing = 1
        monthView.showsVerticalScrollIndicator = false
        monthView.showsHorizontalScrollIndicator = false
        monthView.cellSize = 0
        monthView.scrollingMode = .stopAtEachSection
        monthView.scrollDirection = .horizontal
        
//        monthView.isScrollEnabled = false
        let now = Date()
        monthView.scrollToDate(now, triggerScrollToDateDelegate: false, animateScroll: false)
        monthView.selectDates([sDate], triggerSelectionDelegate: false)
        preNextView.curBeginDate = now
    }
    
    @objc func registerViews() {
        monthView.register(cellWithClass: XWHCalendarDayCTCell.self)
    }
    
    @objc func relayoutSubViews() {
        preNextView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(25)
        }
        weekIndicatiorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(24)
            make.top.equalTo(preNextView.snp.bottom).offset(22)
        }
        
        monthView.snp.makeConstraints { make in
            make.top.equalTo(weekIndicatiorView.snp.bottom).offset(12)
            make.bottom.equalToSuperview()
            make.left.right.equalTo(weekIndicatiorView)
        }
    }
    
    // MARK: - JTACMonthViewDataSource & JTACMonthViewDelegate
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfRow, firstDayOfWeek: XWHCalendarHelper.firstDayOfWeek, hasStrictBoundaries: true)

        return parameters
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableCell(withClass: XWHCalendarDayCTCell.self, for: indexPath)
        
        cell.textLb.text = cellState.text
        
        cell.textLb.textColor = XWHCalendarHelper.normalColor
        cell.nowIndicator.isHidden = true
        cell.dotIndicator.isHidden = true
        cell.selectedIndicator.isHidden = true

        if cellState.date.isInToday {
            cell.nowIndicator.isHidden = false
            cell.textLb.textColor = XWHCalendarHelper.curColor
        } else {
            if cellState.dateBelongsTo != .thisMonth {
                cell.textLb.textColor = XWHCalendarHelper.disableColor
            }
            
            if cellState.date.isInFuture {
                cell.dotIndicator.isHidden = true
                cell.textLb.textColor = XWHCalendarHelper.disableColor
            }
        }
        
        if cellState.date.dayBegin == sBeginDate {
            cell.selectedIndicator.isHidden = false
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
//        if cellState.dateBelongsTo != .thisMonth {
//            return false
//        }
//
//        if cellState.date.isInFuture {
//            return false
//        }
//
//        if cellState.date.dayBegin == sBeginDate {
//            if cellState.isSelected {
//                return false
//            }
//        }
        
        return true
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.dateBelongsTo != .thisMonth {
            return
        }
        
        if cellState.date.isInFuture {
            return
        }
        
        if cellState.date.dayBegin == sBeginDate {
            return
        }
        
        sDate = cellState.date.dayBegin
        calendar.reloadData(withAnchor: sDate, completionHandler: nil)
        
//        guard let cell = cell as? XWHCalendarDayCTCell else {
//            return
//        }
//
//        if cellState.date.dayBegin == sBeginDate {
//            cell.selectedIndicator.isHidden = false
//        }
        
        selectHandler?(sDate)
    }
    
    func calendar(_ calendar: JTACMonthView, shouldDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
//        if cellState.dateBelongsTo != .thisMonth {
//            return false
//        }
//
//        if cellState.date.isInFuture {
//            return false
//        }
//
//        if cellState.date.dayBegin == sBeginDate, !cellState.isSelected {
//            return false
//        }
        
        return true
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
//        guard let cell = cell as? XWHCalendarDayCTCell else {
//            return
//        }
//
//        if cellState.date.dayBegin == sBeginDate {
//            cell.selectedIndicator.isHidden = true
//        }
    }

    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard let fDate = visibleDates.monthDates.first?.date else {
            return
        }
        
        preNextView.curBeginDate = fDate.monthBegin
    }
    
//    func sizeOfDecorationView(indexPath: IndexPath) -> CGRect {
//        let stride = monthView.frame.width * CGFloat(indexPath.section)
//        return CGRect(x: stride + 5, y: 5, width: monthView.frame.width - 10, height: monthView.frame.height - 10)
//    }

}

// MARK: - ConfigEventAction
extension XWHCalendarDayView {
    
    private func configEventAction() {
        preNextView.selectHandler = { [unowned self] cbDate, aType in
            self.curBeginDate = cbDate
            if aType == .pre {
                self.monthView.scrollToSegment(.previous)
            } else {
                self.monthView.scrollToSegment(.next)
            }
        }
    }
    
}
