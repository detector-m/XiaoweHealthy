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
    
    /// 获取睡眠分布的颜色
    class func getSleepRangeColors() -> [UIColor] {
        return [UIColor(hex: 0x5047C4)!, UIColor(hex: 0x8389F3)!, UIColor(hex: 0xFACA79)!]
    }
    
    /// 获取睡眠分钟转换的数据
    class func getSleepDurationString(_ value: Int) -> String {
        let h = value / 60
        let m = value % 60
        
        if h == 0 {
            return m.string + " " + R.string.xwhDeviceText.分钟()
        } else if m == 0 {
            return h.string + " " + R.string.xwhDeviceText.小时()
        } else {
            return h.string + " " + R.string.xwhDeviceText.小时() + " " + m.string + " " + R.string.xwhDeviceText.分钟()
        }
    }
    
}
