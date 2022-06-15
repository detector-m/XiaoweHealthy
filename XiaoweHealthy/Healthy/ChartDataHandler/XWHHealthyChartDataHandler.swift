//
//  XWHHealthyChartDataHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/11.
//

import Foundation


typealias XWHChartDataParseResult<ChartValue, RawValue> = (xAxisValue: String, yValue: ChartValue, rawValue: RawValue?)
typealias XWHChartDataParseHandler<ChartValue, RawValue> = (_ dateType: XWHHealthyDateSegmentType, _ i: Int, _ iDate: Date, _ rawItems: [RawValue]) -> XWHChartDataParseResult<ChartValue, RawValue>

typealias XWHChartDataYAxisResult<ChartValue> = (max: Double, granularity: Double, yAxisValues: [String])
typealias XWHChartDataYAxisHandler<ChartValue> = (_ yValues: [ChartValue], _ yAxisLabelCount: Int) -> XWHChartDataYAxisResult<ChartValue>


/// 图表数据管理器
class XWHHealthyChartDataHandler {
    
}

// MARK: - 情绪
extension XWHHealthyChartDataHandler {
    
    class func getMoodChartDataModel(date: Date, dateType: XWHHealthyDateSegmentType, rawItems: [XWHMoodUIMoodItemModel]) -> XWHChartDataBaseModel {
        let retModel = XWHChartDataBaseModel()
        
        var iXAxisValue = ""
        var iRawValue: XWHMoodUIMoodItemModel? = nil
        let defaultIYValue: [Double] = [0, 0]
        var iYValue = defaultIYValue
        
        configChartDataModel(date: date, dateType: dateType, rawItems: rawItems, chartDataModel: retModel, dayParser: { (dateType, i, iDate, rawItems) -> (String, [Double], XWHMoodUIMoodItemModel?) in
            iXAxisValue = ""
            iYValue = defaultIYValue
            iRawValue = nil
            
            (iYValue, iRawValue) = getChartRawValue(in: rawItems, where: { $0.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat)?.hour == iDate.hour }, chartValueHandler: { getMoodColumnRangeBarValidChartValue($0, iDate, dateType) }, defaultChartValue: defaultIYValue)
            iXAxisValue = getDayXAxisValue(i: i, iDate: iDate)
            
            return (iXAxisValue, iYValue, iRawValue)
        }, weekParser: { dateType, i, iDate, rawItems in
            iXAxisValue = ""
            iYValue = defaultIYValue
            iRawValue = nil
                        
            (iYValue, iRawValue) = getChartRawValue(in: rawItems, where: { $0.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat)?.dayBegin == iDate }, chartValueHandler: { getMoodColumnRangeBarValidChartValue($0, iDate, dateType) }, defaultChartValue: defaultIYValue)
            
            iXAxisValue = getWeekXAxisValue(i: i, iDate: iDate)

            return (iXAxisValue, iYValue, iRawValue)
        }, monthParser: { dateType, i, iDate, rawItems in
            iXAxisValue = ""
            iYValue = defaultIYValue
            iRawValue = nil
                        
            (iYValue, iRawValue) = getChartRawValue(in: rawItems, where: { $0.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat)?.dayBegin == iDate }, chartValueHandler: { getMoodColumnRangeBarValidChartValue($0, iDate, dateType) }, defaultChartValue: defaultIYValue)
            
            iXAxisValue = getMonthXAxisValue(i: i, iDate: iDate)

            return (iXAxisValue, iYValue, iRawValue)
        }, yearParser: { dateType, i, iDate, rawItems in
            iXAxisValue = ""
            iYValue = defaultIYValue
            iRawValue = nil
            
            (iYValue, iRawValue) = getChartRawValue(in: rawItems, where: { $0.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat)?.monthBegin == iDate }, chartValueHandler: { getMoodColumnRangeBarValidChartValue($0, iDate, dateType) }, defaultChartValue: defaultIYValue)
            
            iXAxisValue = getYearXAxisValue(i: i, iDate: iDate)

            return (iXAxisValue, iYValue, iRawValue)
        }, yAxisHandler: { yValues, yAxisLabelCount in
            return getMoodYAxisResult(yValues: yValues, yAxisLabelCount: yAxisLabelCount)
        }, yAxisLabelCount: 5)
        
        return retModel
    }
    
    
    class func getMoodColumnRangeBarValidChartValue(_ item: XWHMoodUIMoodItemModel, _ iDate: Date, _ dateType: XWHHealthyDateSegmentType) -> [Double] {
//        switch dateType {
//        case .day:
//            break
//            
//        case .week, .month:
//            break
//            
//        case .year:
//            break
//        }
        guard let bDate = item.initialPoint.date(withFormat: XWHDate.standardTimeAllFormat), let eDate = item.finalPoint.date(withFormat: XWHDate.standardTimeAllFormat) else {
            return [0, 0]
        }
        
        var offsetDuration = bDate.minutesSince(iDate)
        var duration = eDate.minutesSince(bDate)
        
        if offsetDuration < 0 {
            offsetDuration = 0
        }
        
        if duration < 0 {
            duration = 0
        }
        
        if offsetDuration > 0, duration == 0 {
            duration = 1
        }
        
        return [offsetDuration, offsetDuration + duration]
    }
    
    private class func getMoodYAxisResult(yValues: [[Double]], yAxisLabelCount: Int) -> XWHChartDataYAxisResult<[Double]> {
        let yAxisCount: Double = yAxisLabelCount.double
        var max = yValues.map({ $0.max() ?? 0 }).max() ?? 0
        
        // 防止不弹出marker
        if max > 0 {
            max += 1
        }
        
        let granularity = ceil(max / yAxisCount)
        max = granularity * yAxisCount
        
        return (max, granularity, [])
    }
    
}

// MARK: - 精神压力(MentalStress)
extension XWHHealthyChartDataHandler {
    
    class func getMentalStressChartDataModel(date: Date, dateType: XWHHealthyDateSegmentType, rawItems: [XWHChartUIChartItemModel]) -> XWHChartDataBaseModel {
        let retModel = getHeartChartDataModel(date: date, dateType: dateType, rawItems: rawItems)
        
        retModel.min = 0
        retModel.max = 100
        retModel.granularity = 25
        
        retModel.yValues = getValidYValues(with: retModel)
        
        return retModel
    }
    
}

// MARK: - 血氧(BloodOxygen)
extension XWHHealthyChartDataHandler {

    class func getBOChartDataModel(date: Date, dateType: XWHHealthyDateSegmentType, rawItems: [XWHChartUIChartItemModel]) -> XWHChartDataBaseModel {
        let retModel = getHeartChartDataModel(date: date, dateType: dateType, rawItems: rawItems)
        
        retModel.min = 80
        retModel.max = 100
        retModel.granularity = 5
        
        retModel.yValues = getValidYValues(with: retModel)
        
        return retModel
    }
    
    
}

// MARK: - 心率(Heart)
extension XWHHealthyChartDataHandler {
    
    class func getHeartChartDataModel(date: Date, dateType: XWHHealthyDateSegmentType, rawItems: [XWHChartUIChartItemModel]) -> XWHChartDataBaseModel {
        let retModel = XWHChartDataBaseModel()
        
        var iXAxisValue = ""
        var iRawValue: XWHChartUIChartItemModel? = nil
        let defaultIYValue: [Double] = [0, 0]
        var iYValue = defaultIYValue
        
        configChartDataModel(date: date, dateType: dateType, rawItems: rawItems, chartDataModel: retModel, dayParser: { (dateType, i, iDate, rawItems) -> (String, [Double], XWHChartUIChartItemModel?) in
            iXAxisValue = ""
            iYValue = defaultIYValue
            iRawValue = nil
            
            (iYValue, iRawValue) = getChartRawValue(in: rawItems, where: { $0.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat)?.hour == iDate.hour }, chartValueHandler: { getColumnRangeBarValidChartValue($0) }, defaultChartValue: defaultIYValue)
            iXAxisValue = getDayXAxisValue(i: i, iDate: iDate)
            
            return (iXAxisValue, iYValue, iRawValue)
        }, weekParser: { dateType, i, iDate, rawItems in
            iXAxisValue = ""
            iYValue = defaultIYValue
            iRawValue = nil
                        
            (iYValue, iRawValue) = getChartRawValue(in: rawItems, where: { $0.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat)?.dayBegin == iDate }, chartValueHandler: { getColumnRangeBarValidChartValue($0) }, defaultChartValue: defaultIYValue)
            
            iXAxisValue = getWeekXAxisValue(i: i, iDate: iDate)

            return (iXAxisValue, iYValue, iRawValue)
        }, monthParser: { dateType, i, iDate, rawItems in
            iXAxisValue = ""
            iYValue = defaultIYValue
            iRawValue = nil
                        
            (iYValue, iRawValue) = getChartRawValue(in: rawItems, where: { $0.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat)?.dayBegin == iDate }, chartValueHandler: { getColumnRangeBarValidChartValue($0) }, defaultChartValue: defaultIYValue)
            
            iXAxisValue = getMonthXAxisValue(i: i, iDate: iDate)

            return (iXAxisValue, iYValue, iRawValue)
        }, yearParser: { dateType, i, iDate, rawItems in
            iXAxisValue = ""
            iYValue = defaultIYValue
            iRawValue = nil
            
            (iYValue, iRawValue) = getChartRawValue(in: rawItems, where: { $0.timeAxis.date(withFormat: XWHDate.standardTimeAllFormat)?.monthBegin == iDate }, chartValueHandler: { getColumnRangeBarValidChartValue($0) }, defaultChartValue: defaultIYValue)
            
            iXAxisValue = getYearXAxisValue(i: i, iDate: iDate)

            return (iXAxisValue, iYValue, iRawValue)
        }, yAxisHandler: { yValues, yAxisLabelCount in
            return getHeartYAxisResult(yValues: yValues, yAxisLabelCount: yAxisLabelCount)
        }, yAxisLabelCount: 5)
        
        return retModel
    }
    
    private class func getHeartYAxisResult(yValues: [[Double]], yAxisLabelCount: Int) -> XWHChartDataYAxisResult<[Double]> {
        let yAxisCount: Double = yAxisLabelCount.double
        var max = yValues.map({ $0.max() ?? 0 }).max() ?? 0
        
        if max > 0, max < 100 {
            max = 100
        }
        
        let granularity = ceil(max / yAxisCount)
        max = granularity * yAxisCount
        
        return (max, granularity, [])
    }
    
    private class func getYAxisResult(yValues: [[Double]], yAxisLabelCount: Int) -> XWHChartDataYAxisResult<[Double]> {
        let yAxisCount: Double = yAxisLabelCount.double
        var max = yValues.map({ $0.max() ?? 0 }).max() ?? 0
        
        let granularity = ceil(max / yAxisCount)
        max = granularity * yAxisCount
        
        return (max, granularity, [])
    }
    
    private class func getValidYValues(with chartDataModel: XWHChartDataBaseModel) -> [[Double]] {
        var yValues: [[Double]] = (chartDataModel.yValues as? [[Double]]) ?? []
        yValues = yValues.map({
            var low = $0[0]
            var high = $0[1]
            
            if low == 0, high == 0 {
                return [low, high]
            }
            
            if low < chartDataModel.min {
              low = chartDataModel.min
            }
            
            if high > chartDataModel.max {
                high = chartDataModel.max
            }
            
            return [low, high]
        })
        
        return yValues
    }
        
}

// MARK: - 睡眠(Sleep)
extension XWHHealthyChartDataHandler {
    
    #if false
    
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
    
    class func getSleepWeekMonthYearChartDataModel(date: Date, dateType: XWHHealthyDateSegmentType, sItems: [XWHHealthySleepUISleepItemModel]) -> XWHChartDataBaseModel {
        let retModel = XWHChartDataBaseModel()
        
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
    
}

// MARK: - Config
extension XWHHealthyChartDataHandler {
    
    class func getColumnRangeBarValidChartValue(_ item: XWHChartUIChartItemModel) -> [Double] {
        if item.lowest > 0, item.highest == item.lowest {
            return [item.lowest.double, (item.highest + 1).double]
        } else {
            return [item.lowest.double, item.highest.double]
        }
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
            for (i, iDate) in bDates.enumerated() {
                (iXAxisValue, iYValue, iRawValue) = dayParser(dateType, i, iDate, rawItems)
                
                xAxisValues.append(iXAxisValue)
                yValues.append(iYValue)
                rawValues.append(iRawValue)
            }

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
            bDate = date.dayBegin
            count = 24
            calendarComponent = .hour
            
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
        if i == 0 || i == 6 || i == 12 || i == 18 {
            return iDate.string(withFormat: XWHDate.hourMinuteFormat)
        } else if i == 23 {
            return iDate.dayEnd.string(withFormat: XWHDate.hourMinuteFormat)
        } else {
            return ""
        }
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
