//
//  XWHHealthyConstant.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/20.
//

import Foundation
import UIKit


// MARK: - 运动健康的类型
/// 运动健康的类型
enum XWHHealthyType: String {
    
    case none = ""
    
    case heart = "心率"
    case bloodOxygen = "血氧饱和度"
    
    case mentalStress = "压力"
    
    case sleep = "睡眠"
    
    // Test
    case test = "测试"
    
    case post = "上传心率血氧测试数据"
    case sync = "同步"
    
    case login = "登录"
    
}

/// 日期分段控件 分段的类型
enum XWHHealthyDateSegmentType: String {
    
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
    
    /// 压力区间
    case mentalStressRange
    
    /// 睡眠分布 (睡眠区间)
    case sleepRange
}


/// 睡眠状态
enum XWHHealthySleepState {
    
    case deep
    case light
    case awake
    
    var name: String {
        switch self {
        case .deep:
            return R.string.xwhHealthyText.深睡()
            
        case .light:
            return R.string.xwhHealthyText.浅睡()
            
        case .awake:
            return R.string.xwhHealthyText.清醒()
        }
    }
    
    var color: UIColor {
        switch self {
        case .deep:
            return UIColor(hex: 0x5047C4)!
            
        case .light:
            return UIColor(hex: 0x8389F3)!
            
        case .awake:
            return UIColor(hex: 0xFACA79)!
        }
    }
    
}
