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
            return m.string + " " + R.string.xwhHealthyText.分()
        } else if m == 0 {
            return h.string + " " + R.string.xwhDeviceText.小时()
        } else {
            return h.string + " " + R.string.xwhDeviceText.小时() + " " + m.string + " " + R.string.xwhHealthyText.分()
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
    
}
