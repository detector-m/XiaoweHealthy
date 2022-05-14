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
        let retModel = XWHSleepWMYChartDataModel()
        var xAxisValues = [String]()
//        var yAxisValues = [String]()
        var yValues = [[Double]]()
        var rawValues = [Any?]()
        
        let bDates = getBeginDates(date: date, dateType: dateType)
        var xLabelCount = 5
        
        var iRawValue: Any? = nil
        var iYValue: [Double] = [0, 0, 0]
        
        switch dateType {
        case .day:
            return retModel

        case .week:
            xLabelCount = 7
            
            for iDate in bDates {
                iRawValue = nil
                iYValue = [0, 0, 0]
                
                let iDateString = iDate.string(withFormat: XWHDate.standardYearMonthDayFormat)
                if let iItem = sItems.first(where: { $0.timeAxis == iDateString }) {
                    iYValue = [iItem.deepSleepDuration.double, iItem.lightSleepDuration.double, iItem.awakeDuration.double]
                    
                    iRawValue = iItem
                }
                
                xAxisValues.append("\(iDate.month)/\(iDate.day)")
                yValues.append(iYValue)
                rawValues.append(iRawValue)
            }

        case .month:
            xLabelCount = 32
            
            for (i, iDate) in bDates.enumerated() {
                iRawValue = nil
                iYValue = [0, 0, 0]
                
                let iDateString = iDate.string(withFormat: XWHDate.standardYearMonthDayFormat)
                if let iItem = sItems.first(where: { $0.timeAxis == iDateString }) {
                    iYValue = [iItem.deepSleepDuration.double, iItem.lightSleepDuration.double, iItem.awakeDuration.double]
                    
                    iRawValue = iItem
                }
                
                let cI = i + 1
                if cI == 1 {
                    xAxisValues.append(iDate.localizedString(withFormat: XWHDate.monthDayFormat))
                } else if cI % 7 == 0 {
                    xAxisValues.append(iDate.localizedString(withFormat: XWHDate.dayFormat))
                } else {
                    xAxisValues.append("")
                }
                yValues.append(iYValue)
                rawValues.append(iRawValue)
            }

        case .year:
            xLabelCount = 12

            for (i, iDate) in bDates.enumerated() {
                iRawValue = nil
                iYValue = [0, 0, 0]
                
                if let iItem = sItems.first(where: { $0.timeAxis.date(withFormat: XWHDate.standardYearMonthDayFormat)?.monthBegin == iDate }) {
                    iYValue = [iItem.deepSleepDuration.double, iItem.lightSleepDuration.double, iItem.awakeDuration.double]
                    iRawValue = iItem
                }
                
                if i == 0 {
                    xAxisValues.append(iDate.localizedString(withFormat: XWHDate.monthFormat))
                } else {
                    xAxisValues.append((i + 1).string)
                }
                
                yValues.append(iYValue)
                rawValues.append(iRawValue)
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
        retModel.xLabelCount = xLabelCount
        retModel.xAxisValues = xAxisValues
//        retModel.yAxisValues = yAxisValues
        retModel.yValues = yValues
        retModel.rawValues = rawValues
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
