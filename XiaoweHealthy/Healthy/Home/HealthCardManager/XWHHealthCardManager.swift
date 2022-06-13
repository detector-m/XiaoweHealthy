//
//  XWHHealthCardManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/10.
//

import Foundation
import HandyJSON

/// 健康卡片管理器
class XWHHealthCardManager {
    
    private static let kHealthCardKeyPrefix = "HealthCard+"
    
    func loadShowCards(userId: String) -> [XWHHealthCardModel] {
        let cards = loadCards(userId: userId)
        
        let showCares = cards.filter({ !$0.isHidden })
        
        return showCares
    }
    
    func loadCards(userId: String) -> [XWHHealthCardModel] {
        if userId.isEmpty {
            return loadDefaultCards()
        }
        
        let kCardKey = getCardKey(userId: userId)
        if let jsonCards = UserDefaults.standard[kCardKey] as? String {
            if let cards = [XWHHealthCardModel].deserialize(from: jsonCards) as? [XWHHealthCardModel], !cards.isEmpty {
                return cards
            }
            
            return loadDefaultCards()
        } else {
            return loadDefaultCards()
        }
    }
    
    func saveCards(userId: String, cards: [XWHHealthCardModel]) {
        if userId.isEmpty {
            return
        }
        
        if cards.isEmpty {
            return
        }
        
        let kCardKey = getCardKey(userId: userId)

        if let jsonCards = cards.toJSONString(prettyPrint: false), !jsonCards.isEmpty {
            UserDefaults.standard[kCardKey] = jsonCards
        }
    }
    
    private func getCardKey(userId: String) -> String {
        "\(Self.kHealthCardKeyPrefix)\(userId)"
    }
    
    /// 加载默认卡片
    fileprivate func loadDefaultCards() -> [XWHHealthCardModel] {
        var cards: [XWHHealthCardModel] = []
        
        // 心率
        var iCard = XWHHealthCardModel()
        iCard.isHidden = false
        iCard.type = XWHHealthyType.heart.rawValue
        cards.append(iCard)
         
        // 睡眠
        iCard = XWHHealthCardModel()
        iCard.isHidden = false
        iCard.type = XWHHealthyType.sleep.rawValue
        cards.append(iCard)

        // 血氧
        iCard = XWHHealthCardModel()
        iCard.isHidden = false
        iCard.type = XWHHealthyType.bloodOxygen.rawValue
        cards.append(iCard)
        
        // 压力
        iCard = XWHHealthCardModel()
        iCard.isHidden = false
        iCard.type = XWHHealthyType.mentalStress.rawValue
        cards.append(iCard)
        
        // 情绪
        iCard = XWHHealthCardModel()
        iCard.isHidden = false
        iCard.type = XWHHealthyType.mood.rawValue
        cards.append(iCard)
        
        return cards
    }
    
}
