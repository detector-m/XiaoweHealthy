//
//  XWHActivityCalendarMonthView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/16.
//

import UIKit
import JTAppleCalendar

class XWHActivityCalendarMonthView: XWHBaseView {

    /// 日历选择的view
    lazy var monthView = JTACMonthView()
    
    lazy var numberOfRows = 6 {
        didSet {
            monthView.reloadData()
        }
    }
    
    /// 日历开始的时间
    lazy var startDate = XWHCalendarHelper.startDate
    /// 日历的结束时间
    lazy var endDate = Date()
    
    lazy var sDayDate = Date()
    var clickDateHandler: ((Date) -> Void)?
    var didScrollToStartDate: ((Date) -> Void)?
    
    lazy var atSums: [XWHActivitySumUIModel] = []
    
    override func addSubViews() {
        super.addSubViews()
                
        addSubview(monthView)
        monthView.backgroundColor = bgColor
        
        configMonthView()
        registerViews()
    }
    
    override func relayoutSubViews() {
        monthView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
//        monthView.selectDates([sDayDate], triggerSelectionDelegate: false)
    }
    
    @objc func registerViews() {
        monthView.register(cellWithClass: XWHActivityCalendarDayCell.self)
    }
    
    func setSelectDate(_ date: Date) {
        sDayDate = date
        
        monthView.scrollToDate(sDayDate, triggerScrollToDateDelegate: false, animateScroll: false)
//        monthView.selectDates([sDayDate], triggerSelectionDelegate: false)
    }

}

extension XWHActivityCalendarMonthView: JTACMonthViewDataSource & JTACMonthViewDelegate {
    
    // MARK: - JTACMonthViewDataSource & JTACMonthViewDelegate
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: numberOfRows, calendar: Calendar.current, generateInDates: .forAllMonths, generateOutDates: .tillEndOfGrid, firstDayOfWeek: XWHCalendarHelper.firstDayOfWeek, hasStrictBoundaries: nil)

        return parameters
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableCell(withClass: XWHActivityCalendarDayCell.self, for: indexPath)
        if cellState.dateBelongsTo != .thisMonth {
            cell.isHidden = true
            return cell
            
        }
        
        cell.textLb.text = cellState.text
        cell.isHidden = false
        cell.textLb.textColor = XWHCalendarHelper.normalColor
        cell.indicator.isHidden = true

        if cellState.date.isInToday {
            cell.textLb.textColor = XWHCalendarHelper.curColor
            cell.indicator.isHidden = false
        } else if cellState.date.dayBegin == sDayDate.dayBegin  {
            cell.indicator.isHidden = false
        }
        
        let iSum = atSums.first(where: { cellState.date.dayBegin == ($0.calendarDate.date(withFormat: XWHDate.standardYearMonthDayFormat) ?? Date()).dayBegin })
        
        cell.updateActivityRings(atSumUIModel: iSum)

        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return true
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        sDayDate = cellState.date.dayBegin
        
        if sDayDate.isInFuture {
            return
        }
        
        clickDateHandler?(sDayDate)
    }
    
    func calendar(_ calendar: JTACMonthView, shouldDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return true
    }
    
    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        
    }

    func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard let fDate = visibleDates.monthDates.first?.date else {
            return
        }
        
        didScrollToStartDate?(fDate.dayBegin)
    }
    
//    func sizeOfDecorationView(indexPath: IndexPath) -> CGRect {
//        let stride = monthView.frame.width * CGFloat(indexPath.section)
//        return CGRect(x: stride + 5, y: 5, width: monthView.frame.width - 10, height: monthView.frame.height - 10)
//    }

    
}
