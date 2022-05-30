//
//  XWHHealthyUIManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/21.
//

import Foundation


class XWHHealthyUIManager: XWHHealthyUIItemModel {
    
    lazy var items: [XWHHealthyUIItemModel] = []
    
//    lazy var isHasLastItem: Bool = true {
//        didSet {
//
//        }
//    }
    
    // MARK: - 心率(Heart)
//    lazy var heartCardTypes: [XWHHealthyDetailUICardType] = [.chart, .curDatas, .heartRange]
    private lazy var heartCardTypes: [XWHHealthyDetailUICardType] = [.chart, .curDatas, .heartRange]
    private lazy var heartCurDataItems: [String] = [R.string.xwhHealthyText.最近一次心率(), R.string.xwhHealthyText.心率范围(), R.string.xwhHealthyText.静息心率(), R.string.xwhHealthyText.平均心率()]
    
    // MARK: - 血氧饱和度（BloodOxygen）
    private lazy var boCardTypes: [XWHHealthyDetailUICardType] = [.chart, .curDatas, .boTip]
    private lazy var boCurDataItems: [String] = [R.string.xwhHealthyText.最近一次血氧饱和度(), R.string.xwhHealthyText.血氧饱和度范围(), R.string.xwhHealthyText.平均血氧饱和度()]
    
    // MARK: - 压力 （MentalStress）
    private lazy var mentalStressCardTypes: [XWHHealthyDetailUICardType] = [.chart, .curDatas, .mentalStressRange]
    private lazy var mentalStressCurDataItems: [String] = [R.string.xwhHealthyText.最近一次压力值(), R.string.xwhHealthyText.压力范围(), R.string.xwhHealthyText.平均压力值()]
    
    // MARK: - 情绪 （Mood）
    private lazy var moodCardTypes: [XWHHealthyDetailUICardType] = [.chart, .curDatas, .moodRange]
    private lazy var moodCurDataItems: [String] = [R.string.xwhHealthyText.最近一次情绪状态()]
     
    // MARK: - 睡眠 （Sleep）
    private lazy var sleepCardTypes: [XWHHealthyDetailUICardType] = [.chart, .curDatas, .sleepRange]

    func loadItems(_ type: XWHHealthyType, isHasCurDatasItem: Bool = true) {
        switch type {
        case .heart:
            items = getUICardItems(heartCardTypes, healthyType: type)
            
        case .bloodOxygen:
            items = getUICardItems(boCardTypes, healthyType: type)
            
        case .mentalStress:
            items = getUICardItems(mentalStressCardTypes, healthyType: type)
            
        case .mood:
            if !isHasCurDatasItem {
                moodCardTypes.removeFirst(where: { $0 == .curDatas })
            }
            items = getUICardItems(moodCardTypes, healthyType: type)
            
        case .sleep:
            items = getUICardItems(sleepCardTypes, healthyType: type)

        default:
            break
        }
    }
    
    func cleanItems(without keepTypes: [XWHHealthyDetailUICardType] = []) {
        items.removeAll(where: { !keepTypes.contains($0.uiCardType) })
    }
    
    private func getUICardItems(_ cardTypes: [XWHHealthyDetailUICardType], healthyType: XWHHealthyType) -> [XWHHealthyUIItemModel] {
        let items: [XWHHealthyUIItemModel] = cardTypes.map { cardType in
            let item = getUICardItem(cardType)
            item.healthyType = healthyType
            return item
        }
        
        return items
    }
    
    private func getUICardItem(_ cardType: XWHHealthyDetailUICardType) -> XWHHealthyUIItemModel {
        let item = XWHHealthyUIItemModel()
        item.uiCardType = cardType
        
        return item
    }
    
}

// MARK: - 获取信息
extension XWHHealthyUIManager {

    func getItemTitle(_ item: XWHHealthyUIItemModel, dateSegmentType: XWHHealthyDateSegmentType) -> String {
        switch item.uiCardType {
        case .curDatas:
            switch dateSegmentType {
            case .day:
                switch item.healthyType {
                case .heart, .bloodOxygen, .mentalStress, .mood:
                    break
                    
                case .sleep:
                    return R.string.xwhHealthyText.今日睡眠()
                    
                default:
                    return ""
                }
                return R.string.xwhHealthyText.今日数据()
                
            case .week:
                switch item.healthyType {
                case .heart, .bloodOxygen, .mentalStress, .mood:
                    break
                    
                case .sleep:
                    return R.string.xwhHealthyText.本周平均睡眠()
                    
                default:
                    return ""
                }
                 return R.string.xwhHealthyText.本周数据()
                
            case .month:
                switch item.healthyType {
                case .heart, .bloodOxygen, .mentalStress, .mood:
                    break
                    
                case .sleep:
                    return R.string.xwhHealthyText.本月平均睡眠()
                    
                default:
                    return ""
                }
                
                return R.string.xwhHealthyText.本月数据()
                
            case .year:
                switch item.healthyType {
                case .heart, .bloodOxygen, .mentalStress, .mood:
                    break
                    
                case .sleep:
                    return R.string.xwhHealthyText.今年平均睡眠()
                    
                default:
                    return ""
                }
                return R.string.xwhHealthyText.本年数据()
            }
            
        case .heartRange:
            return R.string.xwhHealthyText.心率区间()
            
        case .boTip:
            return R.string.xwhHealthyText.血氧饱和度()
            
        case .mentalStressRange:
            return R.string.xwhHealthyText.压力分布()
            
        case .sleepRange:
            switch dateSegmentType {
            case .day:
                return R.string.xwhHealthyText.睡眠分布()
                
            case .week, .month, .year:
                return R.string.xwhHealthyText.平均睡眠分布()
            }
            
        case .moodRange:
            switch dateSegmentType {
            case .day:
                return R.string.xwhHealthyText.情绪分布()
                
            case .week:
                return R.string.xwhHealthyText.本周情绪分布()
                
            case .month, .year:
                return R.string.xwhHealthyText.本月情绪分布()
            }
            
        default:
            return ""
        }
    }
    
    func getItemDetailText(_ item: XWHHealthyUIItemModel) -> String? {
        switch item.uiCardType {
        case .curDatas:
            return nil
            
        case .heartRange:
            return R.string.xwhHealthyText.了解心率()
            
        case .boTip:
            return R.string.xwhHealthyText.了解血氧()
            
        case .mentalStressRange:
            return R.string.xwhHealthyText.了解压力()
            
        case .sleepRange:
            return R.string.xwhHealthyText.了解睡眠()
            
        case .moodRange:
            return R.string.xwhHealthyText.了解情绪()
            
        default:
            return nil
        }
    }
    
    func getCurDataItems(_ item: XWHHealthyUIItemModel, isHasLastItem: Bool) -> [String] {
        switch item.healthyType {
        case .heart:
            var ret = heartCurDataItems
            if !isHasLastItem {
                ret.remove(at: 0)
            }
            return ret
            
        case .bloodOxygen:
            var ret = boCurDataItems
            if !isHasLastItem {
                ret.remove(at: 0)
            }
            return ret
            
        case .mentalStress:
            var ret = mentalStressCurDataItems
            if !isHasLastItem {
                ret.remove(at: 0)
            }
            return ret
            
        case .sleep:
            return [""]
            
        case .mood:
            let ret = moodCurDataItems
            if isHasLastItem {
                return ret
            }
            
            return []
            
        default:
            return []
        }
    }

}
