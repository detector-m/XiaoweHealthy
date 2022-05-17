//
//  XWHHealthyChartDataHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/11.
//

import Foundation
//import AAInfographics


typealias XWHChartDataParseResult<ChartValue, RawValue> = (xAxisValue: String, yValue: ChartValue, rawValue: RawValue?)
typealias XWHChartDataParseHandler<ChartValue, RawValue> = (_ dateType: XWHHealthyDateSegmentType, _ i: Int, _ iDate: Date, _ rawItems: [RawValue]) -> XWHChartDataParseResult<ChartValue, RawValue>

typealias XWHChartDataYAxisResult<ChartValue> = (max: Double, granularity: Double, yAxisValues: [String])
typealias XWHChartDataYAxisHandler<ChartValue> = (_ yValues: [ChartValue], _ yAxisLabelCount: Int) -> XWHChartDataYAxisResult<ChartValue>


/// 图表数据管理器
class XWHHealthyChartDataHandler {
    
    #if false
    
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
    
    #endif
    
    class func getSleepWeekMonthYearChartDataModel(date: Date, dateType: XWHHealthyDateSegmentType, sItems: [XWHHealthySleepUISleepItemModel]) -> XWHSleepWMYChartDataModel {
        let retModel = XWHSleepWMYChartDataModel()
        
        var iXAxisValue = ""
        var iRawValue: XWHHealthySleepUISleepItemModel? = nil
        let defaultIYValue: [Double] = [0, 0, 0]
        var iYValue = defaultIYValue
        
        configChartDataModel(date: date, dateType: dateType, rawItems: sItems, chartDataModel: retModel, dayParser: { (dateType, i, iDate, rawItems) -> (String, [Double], XWHHealthySleepUISleepItemModel?) in
            iXAxisValue = ""
            iYValue = defaultIYValue
            iRawValue = nil
            
            let iDateString = iDate.string(withFormat: XWHDate.standardYearMonthDayFormat)
//            if let iItem = sItems.first(where: { $0.timeAxis == iDateString }) {
//                iYValue = [iItem.deepSleepDuration.double, iItem.lightSleepDuration.double, iItem.awakeDuration.double]
//
//                iRawValue = iItem
//            }
            
            (iYValue, iRawValue) = getChartRawValue(in: sItems, where: { $0.timeAxis == iDateString }, chartValueHandler: { [$0.deepSleepDuration.double, $0.lightSleepDuration.double, $0.awakeDuration.double] }, defaultChartValue: defaultIYValue)
            iXAxisValue = getDayXAxisValue(i: i, iDate: iDate)
            
            return (iXAxisValue, iYValue, iRawValue)
        }, weekParser: { dateType, i, iDate, rawItems in
            iXAxisValue = ""
            iYValue = defaultIYValue
            iRawValue = nil
            
            let iDateString = iDate.string(withFormat: XWHDate.standardYearMonthDayFormat)
//            if let iItem = sItems.first(where: { $0.timeAxis == iDateString }) {
//                iYValue = [iItem.deepSleepDuration.double, iItem.lightSleepDuration.double, iItem.awakeDuration.double]
//
//                iRawValue = iItem
//            }
            
            (iYValue, iRawValue) = getChartRawValue(in: sItems, where: { $0.timeAxis == iDateString }, chartValueHandler: { [$0.deepSleepDuration.double, $0.lightSleepDuration.double, $0.awakeDuration.double] }, defaultChartValue: defaultIYValue)
            
            iXAxisValue = getWeekXAxisValue(i: i, iDate: iDate)

            return (iXAxisValue, iYValue, iRawValue)
        }, monthParser: { dateType, i, iDate, rawItems in
            iXAxisValue = ""
            iYValue = defaultIYValue
            iRawValue = nil
            
            let iDateString = iDate.string(withFormat: XWHDate.standardYearMonthDayFormat)
//            if let iItem = sItems.first(where: { $0.timeAxis == iDateString }) {
//                iYValue = [iItem.deepSleepDuration.double, iItem.lightSleepDuration.double, iItem.awakeDuration.double]
//
//                iRawValue = iItem
//            }
            
            (iYValue, iRawValue) = getChartRawValue(in: sItems, where: { $0.timeAxis == iDateString }, chartValueHandler: { [$0.deepSleepDuration.double, $0.lightSleepDuration.double, $0.awakeDuration.double] }, defaultChartValue: defaultIYValue)
            
            iXAxisValue = getMonthXAxisValue(i: i, iDate: iDate)

            return (iXAxisValue, iYValue, iRawValue)
        }, yearParser: { dateType, i, iDate, rawItems in
            iXAxisValue = ""
            iYValue = defaultIYValue
            iRawValue = nil
            
//            if let iItem = sItems.first(where: { $0.timeAxis.date(withFormat: XWHDate.standardYearMonthDayFormat)?.monthBegin == iDate }) {
//                iYValue = [iItem.deepSleepDuration.double, iItem.lightSleepDuration.double, iItem.awakeDuration.double]
//                iRawValue = iItem
//            }
            
            (iYValue, iRawValue) = getChartRawValue(in: sItems, where: { $0.timeAxis.date(withFormat: XWHDate.standardYearMonthDayFormat)?.monthBegin == iDate }, chartValueHandler: { [$0.deepSleepDuration.double, $0.lightSleepDuration.double, $0.awakeDuration.double] }, defaultChartValue: defaultIYValue)
            
            iXAxisValue = getYearXAxisValue(i: i, iDate: iDate)

            return (iXAxisValue, iYValue, iRawValue)
        }, yAxisHandler: { yValues, yAxisLabelCount in
            let yAxisCount: Double = yAxisLabelCount.double
            var max = yValues.map({ $0.sum() }).max() ?? 0
            var hMax = ceil(max / 60)
            let hGranularity = ceil(hMax / yAxisCount)
            
            hMax = hGranularity * yAxisCount
            max = hMax * 60
            let granularity = hGranularity * 60
            
            return (max, granularity, [])
        }, yAxisLabelCount: 5)
        
        return retModel
    }
    
    class func getChartRawValue<ChartValue, RawValue>(in rawValues: [RawValue], where predicate: (RawValue) -> Bool, chartValueHandler: (RawValue) -> ChartValue, defaultChartValue: ChartValue) -> (ChartValue, RawValue?) {
        guard let retRawValue = rawValues.first(where: predicate) else {
            return (defaultChartValue, nil)
        }
        
        let cValue = chartValueHandler(retRawValue)
        
        return (cValue, retRawValue)
    }
    
    @discardableResult
    class func configChartDataModel<ChartValue, RawValue>(date: Date, dateType: XWHHealthyDateSegmentType, rawItems: [RawValue], chartDataModel: XWHChartDataBaseModel, dayParser: XWHChartDataParseHandler<ChartValue, RawValue>, weekParser: XWHChartDataParseHandler<ChartValue, RawValue>, monthParser: XWHChartDataParseHandler<ChartValue, RawValue>, yearParser: XWHChartDataParseHandler<ChartValue, RawValue>, yAxisHandler: XWHChartDataYAxisHandler<ChartValue>, yAxisLabelCount: Int = 5) -> XWHChartDataBaseModel {
        let retModel = chartDataModel
        var xAxisValues = [String]()
//        var yAxisValues = [String]()
        var yValues = [ChartValue]()
        var rawValues = [RawValue?]()

        let bDates = getBeginDates(date: date, dateType: dateType)
        let xLabelCount = bDates.count

        var iXAxisValue = ""
        var iRawValue: RawValue? = nil
        var iYValue: ChartValue

        switch dateType {
        case .day:
            return retModel

        case .week:
//            xLabelCount = 7

            for (i, iDate) in bDates.enumerated() {
                (iXAxisValue, iYValue, iRawValue) = weekParser(dateType, i, iDate, rawItems)
                
                xAxisValues.append(iXAxisValue)
                yValues.append(iYValue)
                rawValues.append(iRawValue)
            }

        case .month:
//            xLabelCount = 32

            for (i, iDate) in bDates.enumerated() {
                (iXAxisValue, iYValue, iRawValue) = monthParser(dateType, i, iDate, rawItems)

                xAxisValues.append(iXAxisValue)
                yValues.append(iYValue)
                rawValues.append(iRawValue)
            }

        case .year:
//            xLabelCount = 12

            for (i, iDate) in bDates.enumerated() {
                (iXAxisValue, iYValue, iRawValue) = yearParser(dateType, i, iDate, rawItems)
                
                xAxisValues.append(iXAxisValue)
                yValues.append(iYValue)
                rawValues.append(iRawValue)
            }
        }
        
        let (max, granularity, yAxisValues) = yAxisHandler(yValues, yAxisLabelCount)
        retModel.max = max
        retModel.granularity = granularity
        retModel.xLabelCount = xLabelCount
        retModel.xAxisValues = xAxisValues
        retModel.yAxisValues = yAxisValues
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
    
    private class func getDayXAxisValue(i: Int, iDate: Date) -> String {
        return ""
    }
    
    private class func getWeekXAxisValue(i: Int, iDate: Date) -> String {
        return "\(iDate.month)/\(iDate.day)"
    }
    
    private class func getMonthXAxisValue(i: Int, iDate: Date) -> String {
        let cI = i + 1
        if cI == 1 {
            return iDate.localizedString(withFormat: XWHDate.monthDayFormat)
        } else if cI % 7 == 0 {
            return iDate.localizedString(withFormat: XWHDate.dayFormat)
        } else {
            return ""
        }
    }
    
    private class func getYearXAxisValue(i: Int, iDate: Date) -> String {
        if i == 0 {
            return iDate.localizedString(withFormat: XWHDate.monthFormat)
        } else {
            return (i + 1).string
        }
    }
    
}
