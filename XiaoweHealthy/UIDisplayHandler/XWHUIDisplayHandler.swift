//
//  XWHUIDisplayHandler.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/7.
//

import Foundation


/// 界面显示处理器
class XWHUIDisplayHandler {
    
    // MARK: - 健康
    /// 获取压力区间
    class func getPressureRangeString(_ value: Int) -> String {
        let strings = getPressureRangeStrings()
        switch value {
        case 0...29:
            return strings[0]
            
        case 30...59:
            return strings[1]
            
        case 60...79:
            return strings[2]
        
        default:
            return strings[3]
        }
    }
    
    class func getPressureRangeStrings() -> [String] {
        return [R.string.xwhHealthyText.放松(), R.string.xwhHealthyText.正常(), R.string.xwhHealthyText.中等(), R.string.xwhHealthyText.偏高()]
    }
    
    class func getPressureRangeFullStrings() -> [String] {
        return [R.string.xwhHealthyText.放松129(), R.string.xwhHealthyText.正常3059(), R.string.xwhHealthyText.中等6079(), R.string.xwhHealthyText.偏高80100()]
    }
    
    /// 获取压力区间颜色
    class func getPressureRangeColors() -> [UIColor] {
        return [UIColor(hex: 0x49CE64)!, UIColor(hex: 0x76D4EA)!, UIColor(hex: 0xF0B36D)!, UIColor(hex: 0xED7135)!]
    }
    
    /// 获取睡眠状态的颜色
    class func getSleepStateColors() -> [UIColor] {
        let sStates: [XWHHealthySleepState] = [.deep, .light, .awake]
        return sStates.map({ $0.color })
    }
    
    /// 获取睡眠分布的文案
    class func getSleepRangeStrings(_ dateType: XWHHealthyDateSegmentType) -> [String] {
        switch dateType {
        case .day:
            return [R.string.xwhHealthyText.深睡时长(), R.string.xwhHealthyText.浅睡时长(), R.string.xwhHealthyText.清醒时长(), R.string.xwhHealthyText.清醒次数()]
        case .week, .month, .year:
            return [R.string.xwhHealthyText.平均深睡时长(), R.string.xwhHealthyText.平均浅睡时长(), R.string.xwhHealthyText.平均清醒时长(), R.string.xwhHealthyText.平均清醒次数()]
        }
    }
    
    /// 获取睡眠分布的颜色
    class func getSleepRangeColors() -> [UIColor] {
        var colors = getSleepStateColors()
        colors.append(UIColor(hex: 0xFACA79)!)
        return colors
    }
    
    /// 获取深睡区间文案
    class func getDeepSleepRangeString(_ value: Int) -> String {
        if value <= 0 {
            return R.string.xwhHealthyText.无()
        }
        
        if value > 0, value < 30 {
            return R.string.xwhHealthyText.较少()
        }
        
        if value >= 30, value < 60 {
            return R.string.xwhHealthyText.尚可()
        }
        
        return R.string.xwhHealthyText.充足()
    }
    
    /// 获取浅睡区间文案
    class func getLightSleepRangeString(_ value: Int, _ total: Int) -> String {
        if value <= 0 || total <= 0 {
            return R.string.xwhHealthyText.无()
        }
        
        let tagValue = (total.cgFloat * 0.55).int
        
        if value > tagValue {
            return R.string.xwhHealthyText.较长()
        }
        
        return R.string.xwhHealthyText.正常()
    }
    
    /// 获取清醒区间文案
    class func getAwakeSleepRangeString(_ value: Int) -> String {
        if value <= 0 {
            return R.string.xwhHealthyText.无()
        }
        
        if value > 30 {
            return R.string.xwhHealthyText.较长()
        }
        
        return R.string.xwhHealthyText.正常()
    }
    
    /// 获取清醒次数区间文案
    class func getAwakeTimesRangeString(_ value: Int) -> String {
        if value <= 0 {
            return R.string.xwhHealthyText.无()
        }
        
        if value > 5 {
            return R.string.xwhHealthyText.过多()
        }
        
        if value > 2, value <= 5 {
            return R.string.xwhHealthyText.较长()
        }
        
        return R.string.xwhHealthyText.正常()
    }
    
    /// 获取睡眠分钟转换的数据
    class func getSleepDurationString(_ value: Int) -> String {
        let h = value / 60
        let m = value % 60
        
        if h == 0 {
            return m.string + " " + R.string.xwhHealthyText.time分()
        } else if m == 0 {
            return h.string + " " + R.string.xwhDeviceText.小时()
        } else {
            return h.string + " " + R.string.xwhDeviceText.小时() + " " + m.string + " " + R.string.xwhHealthyText.time分()
        }
    }
    
    /// 获取睡眠占比
    class func getSleepRateStrings(_ deepValue: Int, _ lightValue: Int, _ awakeValue: Int, _ total: Int) -> [String] {
        if total <= 0 {
            return ["0%", "0%", "0%"]
        }
        
        let dRate = ((deepValue.cgFloat / total.cgFloat) * 100).int

        let pStr = "%"
        if awakeValue == 0 {
            let lRate = 100 - dRate
            return [dRate.string + pStr, lRate.string + pStr, "0%"]
        } else {
            let lRate = ((lightValue.cgFloat / total.cgFloat) * 100).int
            let aRate = 100 - lRate - dRate
            return [dRate.string + pStr, lRate.string + pStr, aRate.string + pStr]
        }
    }
    
    /// 获取天睡眠总时长得分
    class func getDaySleepTotalDurationScore(_ total: Int) -> Int {
        if total <= 0 {
            return 0
        }
        
        if total <= 60 {
            return 7
        }
        
        if total < 120 {
            return 7 * 2
        }
        
        if total < 60 * 3 {
            return 7 * 3
        }
        
        if  total < 60 * 4 {
            return 7 * 4
        }
        
        if  total < 60 * 5 {
            return 7 * 5
        }
        
        if  total < 60 * 6 {
            return 7 * 6
        }
        
        if  total <= 60 * 10 {
            return 50
        }
        
        if  total < 60 * 11 {
            return 7 * 6
        }
        
        if  total < 60 * 12 {
            return 7 * 5
        }
        if  total < 60 * 13 {
            return 7 * 4
        }
        if  total < 60 * 14 {
            return 7 * 3
        }
        if  total < 60 * 15 {
            return 7 * 2
        }
        
        if  total <= 60 * 16 {
            return 7
        }
        
        return 0
    }
    
    /// 获取天睡眠总时长提示(描述)文案
    class func getDaySleepTotalDurationTip(_ total: Int) -> String {
        if total < 60 * 6 {
            return R.string.xwhHealthyText.您的睡眠时长不足()
        }
        
        if total <= 60 * 10 {
            return R.string.xwhHealthyText.您的睡眠时长非常标准()
        }
        
        return R.string.xwhHealthyText.您的睡眠时长超过了推荐时长的标准()
    }
    
    /// 获取天的入睡时间得分
    class func getDayBeginSleepTimeScore(_ bTime: String) -> Int {
        guard let bDate = bTime.date(withFormat: XWHDate.standardTimeAllFormat) else {
            return 1
        }

        let h = bDate.hour
        if h > 12 {
            return 5
        } else {
            if h > 3 {
                return 1
            }
            
            if h > 1 {
                return 2
            }
            
            return 4
        }
    }
    
    /// 获取天入睡时间提示(描述)文案
    class func getDayBeginSleepTimeTip(_ bsScore: Int) -> String {
        if bsScore >= 5 {
            return R.string.xwhHealthyText.入睡时间合理()
        }
        
        if bsScore >= 4 {
            return R.string.xwhHealthyText.入睡时间较晚()
        }
        
        return R.string.xwhHealthyText.入睡时间过晚()
    }
    
    /// 获取天的入睡时长得分
    class func getDayBeginSleepDurationScore(_ bDuration: Int) -> Int {
        if bDuration <= 5 {
            return 15
        }
        if bDuration <= 10 {
            return 14
        }
        if bDuration <= 15 {
            return 13
        }
        if bDuration <= 20 {
            return 12
        }
        if bDuration <= 30 {
            return 11
        }
        
        if bDuration <= 60 {
            return 10
        }
        if bDuration <= 60 * 2 {
            return 8
        }
        
        if bDuration <= 60 * 3 {
            return 6
        }
        if bDuration <= 60 * 4 {
            return 4
        }
        if bDuration <= 60 * 5 {
            return 3
        }
        return 0
    }
    
    /// 获取天入睡时长提示(描述)文案
    class func getDayBeginSleepDurationTip(_ bsDurationScore: Int) -> String {
        if bsDurationScore >= 11 {
            return R.string.xwhHealthyText.入睡速度正常()
        }
        
        if bsDurationScore >= 8 {
            return R.string.xwhHealthyText.入睡速度较慢()
        }
        
        return R.string.xwhHealthyText.入睡速度困难()
    }
    
    /// 获取天深睡时长得分
    class func getDayDeepSleepDurationScore(_ value: Int) -> Int {
        if value <= 0 {
            return 0
        }
        
        if value < 15 {
            return 1
        }
        
        if value < 30 {
            return 2
        }
        
        if value < 40 {
            return 3
        }
        
        if value < 60 {
            return 4
        }
        
        return 5
    }
    
    /// 获取天深睡时长提示(描述)文案
    class func getDayDeepSleepDurationTip(_ dsDurationScore: Int) -> String {
        if dsDurationScore >= 5 {
            return R.string.xwhHealthyText.深睡充足()
        }
        
        return R.string.xwhHealthyText.深睡不足()
    }
    
    /// 获取天的夜醒时长评分
    class func getDayAwakeInNightScore(_ awakeDuration: Int) -> Int {
        if awakeDuration <= 5 {
            return 15
        }
        if awakeDuration <= 15 {
            return 14
        }
        if awakeDuration <= 30{
            return 13
        }
        
        if awakeDuration <= 60 {
            return 12
        }
        if awakeDuration <= 60 * 2 {
            return 9
        }
        if awakeDuration <= 60 * 3 {
            return 6
        }
        
        if awakeDuration <= 60 * 5 {
            return 3
        }
        
        return 0
    }
    
    /// 获取天的夜醒时长提示(描述)文案
    class func getDayAwakeInNightTip(_ dsDurationScore: Int) -> String {
        if dsDurationScore >= 13 {
            return R.string.xwhHealthyText.睡眠很稳定()
        }
        
        if dsDurationScore >= 6 {
            return R.string.xwhHealthyText.夜里醒来时间较多()
        }
        
        return R.string.xwhHealthyText.夜里醒来时间过多()
    }
    
    /// 获取天的起床稳定性评分
    class func getDayWakeupStabilityScore(_ wakeupDuration: Int) -> Int {
        if wakeupDuration < 5 {
            return 10
        }
        
        if wakeupDuration < 15 {
            return 8
        }
        
        if wakeupDuration < 30 {
            return 6
        }
        
        if wakeupDuration < 60 {
            return 4
        }
        
        if wakeupDuration <= 60 * 5 {
            return 2
        }
        
        return 0
    }
    
    /// 获取周月年睡眠总时长得分
    class func getWeekMonthYearSleepTotalDurationScore(_ total: Int) -> Int {
        return getDaySleepTotalDurationScore(total) * 2
    }
    

    /// 获取睡眠质量文案
    class func getSleepQualityString(_ score: Int) -> String {
        if score <= 39 {
            return R.string.xwhHealthyText.很差()
        }
        
        if score <= 59 {
            return R.string.xwhHealthyText.较差()
        }
        
        if score <= 79 {
            return R.string.xwhHealthyText.一般()
        }
        
        if score <= 89 {
            return R.string.xwhHealthyText.较好()
        }
        
        return R.string.xwhHealthyText.很好()
    }
    
    /// 获取周月年的睡眠提示描述文案
    class func getWeekMonthYearSleepTipString(_ total: Int) -> String {
        if total < 60 * 6 {
            return R.string.xwhHealthyText.您的睡眠时长不足睡眠充足是最基本的健康保障()
        }
        
        if total <= 60 * 10 {
            return R.string.xwhHealthyText.您的睡眠时长非常标准睡眠充足是最基本的健康保障()
        }
        
        return R.string.xwhHealthyText.您的睡眠时长超过了推荐时长的标准睡眠充足是最基本的健康保障()
    }
    
}
