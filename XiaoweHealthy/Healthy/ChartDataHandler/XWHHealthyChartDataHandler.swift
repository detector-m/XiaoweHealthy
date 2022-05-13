//
//  XWHHealthyChartDataHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/11.
//

import Foundation
//import AAInfographics


/// 图表数据管理器
class XWHHealthyChartDataHandler {
    
//    class func getSleepDayChartData(_ sleepUIModel: XWHHealthySleepUISleepModel) -> [AASeriesElement] {
//        let zeroArray = [0, 0]
//        var retArray = [AASeriesElement]()
//
//        var sum = 0
//        for iItem in sleepUIModel.items {
//            let iElement = AASeriesElement()
//            let sState = XWHHealthySleepState(iItem.sleepStatus)
//            var iElementDataArray = [zeroArray, zeroArray, zeroArray]
//            let iDataArray = [sum, sum + iItem.duration]
//            switch sState {
//            case .deep:
//                iElementDataArray[2] = iDataArray
//
//            case .light:
//                iElementDataArray[1] = iDataArray
//
//            case .awake:
//                iElementDataArray[0] = iDataArray
//            }
//            iElement.color(sState.color.hexString).data(iElementDataArray)
//
//            sum += iItem.duration
//            retArray.append(iElement)
//        }
//
//        return retArray
//    }
    
    class func getSleepWeekMonthYearChartDataModel(date: Date, dateType: XWHHealthyDateSegmentType, sItems: [XWHHealthySleepUISleepItemModel]) -> XWHSleepWMYChartDataModel {
        var retModel = XWHSleepWMYChartDataModel()
        var xAxisValues = [String]()
//        var yAxisValues = [String]()
        var yValues = [[Double]]()
        let bDates = getBeginDates(date: date, dateType: dateType)
        
        switch dateType {
        case .day:
            return retModel

        case .week:
            for iDate in bDates {
                var yValue: [Double] = [0, 0, 0]
            
                let iDateString = iDate.string(withFormat: XWHDate.standardYearMonthDayFormat)
                if let iItem = sItems.first(where: { $0.timeAxis == iDateString }) {
                    yValue = [iItem.deepSleepDuration.double, iItem.lightSleepDuration.double, iItem.awakeDuration.double]
                }
                
                xAxisValues.append("\(iDate.month)/\(iDate.day)")
                yValues.append(yValue)
            }

        case .month:
            for (i, iDate) in bDates.enumerated() {
                var yValue: [Double] = [0, 0, 0]
            
                let iDateString = iDate.string(withFormat: XWHDate.standardYearMonthDayFormat)
                if let iItem = sItems.first(where: { $0.timeAxis == iDateString }) {
                    yValue = [iItem.deepSleepDuration.double, iItem.lightSleepDuration.double, iItem.awakeDuration.double]
                }
                
                xAxisValues.append("\(i + 1)")
                yValues.append(yValue)
            }

        case .year:
            for (i, iDate) in bDates.enumerated() {
                var yValue: [Double] = [0, 0, 0]
            
                if let iItem = sItems.first(where: { $0.timeAxis.date(withFormat: XWHDate.standardYearMonthDayFormat)?.monthBegin == iDate }) {
                    yValue = [iItem.deepSleepDuration.double, iItem.lightSleepDuration.double, iItem.awakeDuration.double]
                }
                
                if i == 0 {
                    xAxisValues.append(iDate.localizedString(withFormat: XWHDate.monthFormat))
                } else {
                    xAxisValues.append(i.string)
                }
                yValues.append(yValue)
            }
        }
        
        let yAxisCount: Double = 5
        var max = yValues.map({ $0.sum() }).max() ?? 0
        var hMax = ceil(max / 60)
        let hGranularity = ceil(hMax / yAxisCount)
        
        hMax = hGranularity * yAxisCount
        max = hMax * 60
        let granularity = hGranularity * 60
        
        retModel.max = max
        retModel.granularity = granularity
        
//        for i in 0 ... yAxisCount.int {
//            var tValue = ""
//            if i != 0 {
//                tValue = (i * hGranularity.int).string + "h"
//            }
//            
//            yAxisValues.append(tValue)
//        }
        
        retModel.xAxisValues = xAxisValues
//        retModel.yAxisValues = yAxisValues
        retModel.yValues = yValues
        return retModel
    }
    
}


// MARK: - Tools
extension XWHHealthyChartDataHandler {
    
    private class func getBeginDates(date: Date, dateType: XWHHealthyDateSegmentType) -> [Date] {
        var retArray = [Date]()
        var bDate = date.dayBegin
        var count = 0
        var calendarComponent = Calendar.Component.day
        
        switch dateType {
        case .day:
            return retArray
            
        case .week:
            bDate = date.weekBegin
            count = 7
            calendarComponent = .day
            
        case .month:
            bDate = date.monthBegin
            count = date.calendar.numberOfDaysInMonth(for: date)
            calendarComponent = .day
            
        case .year:
            bDate = date.yearBegin
            count = 12
            calendarComponent = .month
        }
        
        for i in 0 ..< count {
            let cDate = bDate.adding(calendarComponent, value: i)
            retArray.append(cDate)
        }
        
        return retArray
    }
    
}
