//
//  XWHHealthyUIManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/21.
//

import Foundation


class XWHHealthyUIManager: XWHHealthyUIItemModel {
    
    lazy var items: [XWHHealthyUIItemModel] = []
    
    // MARK: - 心率(Heart)
//    lazy var heartCardTypes: [XWHHealthyDetailUICardType] = [.chart, .curDatas, .heartRange]
    lazy var heartCardTypes: [XWHHealthyDetailUICardType] = [.curDatas, .heartRange]
    lazy var heartCurDataItems: [String] = [R.string.xwhHealthyText.最近一次心率(), R.string.xwhHealthyText.心率范围(), R.string.xwhHealthyText.静息心率(), R.string.xwhHealthyText.平均心率()]
    
    func loadItems(_ type: XWHHealthyType) {
        switch type {
        case .heart:
            items = getUICardItems(heartCardTypes, healthyType: type)
            
        case .bloodOxygen:
            break
            
        default:
            break
        }
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
                case .heart, .bloodOxygen:
                    break
                    
                default:
                    return ""
                }
                return R.string.xwhHealthyText.今日数据()
                
            case .week:
                switch item.healthyType {
                case .heart, .bloodOxygen:
                    break
                    
                default:
                    return ""
                }
                 return R.string.xwhHealthyText.本周数据()
                
            case .month:
                switch item.healthyType {
                case .heart, .bloodOxygen:
                    break
                    
                default:
                    return ""
                }
                
                return R.string.xwhHealthyText.本月数据()
                
            case .year:
                switch item.healthyType {
                case .heart, .bloodOxygen:
                    break
                    
                default:
                    return ""
                }
                return R.string.xwhHealthyText.本年数据()
            }
            
            return ""
            
        case .heartRange:
            return R.string.xwhHealthyText.心率区间()
            
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
            
        default:
            return nil
        }
    }

}
