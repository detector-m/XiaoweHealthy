//
//  XWHHealthyHelper.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import Foundation


class XWHHealthyHelper {
    
    /// 获取压力区间
    class func getPressureRangeString(_ value: Int) -> String {
        switch value {
        case 0...29:
            return R.string.xwhHealthyText.放松()
            
        case 30...59:
            return R.string.xwhHealthyText.正常()
            
        case 60...79:
            return R.string.xwhHealthyText.中等()
        
        default:
            return R.string.xwhHealthyText.偏高()
        }
    }
    
}
