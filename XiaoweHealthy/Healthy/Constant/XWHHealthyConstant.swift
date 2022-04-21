//
//  XWHHealthyConstant.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/20.
//

import Foundation


// MARK: - 运动健康的类型
/// 运动健康的类型
enum XWHHealthyType: String {
    
    case none = ""
    
    // Test
    case test = "测试"
    case login = "登录"
    
    case heart = "心率"
    case bloodOxygen = "血氧饱和度"
    
}

/// 日期分段控件 分段的类型
enum XWHHealthyDateSegmentType {
    
    case day
    case week
    case month
    case year
    
    var name: String {
        switch self {
        case .day:
            return R.string.xwhHealthyText.日()
            
        case .week:
            return R.string.xwhHealthyText.周()
            
        case .month:
            return R.string.xwhHealthyText.月()
            
        case .year:
            return R.string.xwhHealthyText.年()
        }
    }
    
}

/// 运动健康详情 的UI 段落卡片类型
enum XWHHealthyDetailUICardType {

    case none
    
    /// 图表
    case chart
    
    /// 当前数据
    case curDatas
    
    /// 心率区间
    case heartRange
    
    /// 血氧饱和度 （提示信息）
    case boTip
    
}
