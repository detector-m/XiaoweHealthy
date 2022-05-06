//
//  XWHHealthyHelper.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import Foundation
import UIKit


class XWHHealthyHelper {
    
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
    
}
