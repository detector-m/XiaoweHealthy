//
//  XWHCalendarWeekView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/27.
//

import UIKit
import JTAppleCalendar

class XWHCalendarWeekView: XWHCalendarDayView {
    
    override var dateType: XWHHealthyDateSegmentType {
        .week
    }
    
    /// 选择的日期
    override var sDate: Date {
        didSet {
            curBeginDate = sDate.weekBegin
        }
    }
    /// 选择日期 周的开始时间
    override var sBeginDate: Date {
        sDate.weekBegin
    }
    
//    override 

    // MARK: - 日历配置
    override func configMonthView() {
        monthView.calendarDataSource = self
        monthView.calendarDelegate = self
        
        monthView.minimumLineSpacing = 1
        monthView.minimumInteritemSpacing = 0
        monthView.showsVerticalScrollIndicator = false
        monthView.showsHorizontalScrollIndicator = false

        monthView.cellSize = 0
        monthView.allowsMultipleSelection = false
        monthView.allowsRangedSelection = true
        monthView.rangeSelectionMode = .segmented
        monthView.scrollingMode = .stopAtEachSection
        monthView.scrollDirection = .horizontal
        
        let now = Date()
        monthView.scrollToDate(now, triggerScrollToDateDelegate: false, animateScroll: false)
        monthView.selectDates(from: sBeginDate, to: sDate.weekEnd, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: false)
//        monthView.selectDates([sDate.weekBegin], triggerSelectionDelegate: true)
        preNextView.curBeginDate = now
    }
    
    override func registerViews() {
        monthView.register(cellWithClass: XWHCalendarWeekCTCell.self)
    }
    
    // MARK: - JTACMonthViewDataSource & JTACMonthViewDelegate
    override func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableCell(withClass: XWHCalendarWeekCTCell.self, for: indexPath)
        
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
        
        if cellState.date.weekBegin == sBeginDate {
            cell.selectedIndicator.isHidden = false

            if cellState.date.dayBegin == sBeginDate {
                cell.position = .begin
            } else if cellState.date.dayBegin == sBeginDate.weekEnd.dayBegin {
                cell.position = .end
            } else {
                cell.position = .midle
            }
        }
        
        return cell
    }
    
    override func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.dateBelongsTo != .thisMonth {
            return
        }

        if cellState.date.isInFuture {
            return
        }

        if cellState.date.weekBegin == sBeginDate {
            return
        }
   
        calendar.deselectAllDates()
        sDate = cellState.date.weekBegin
        calendar.selectDates(from: sBeginDate, to: sDate.weekEnd, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: false)
        
        calendar.reloadData(withAnchor: nil, completionHandler: nil)
    }
    
    override func calendar(_ calendar: JTACMonthView, shouldDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
    }
    
}
