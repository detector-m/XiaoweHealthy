//
//  XWHHomeDeploy.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/11.
//

import Foundation

// MARK: - 首页模块类型
enum XWHHomeDeployType {
    
    /// 天气
    case weather
    
    /// 活动
    case activity
    
    /// 登录
    case login
    
    /// 绑定
    case bind
    
    /// 健康
    case health
    
    /// 编辑卡片
    case editCard
    
    var name: String {
        switch self {
        case .weather:
            return "天气"
            
        case .activity:
            return "活动"
            
        case .login:
            return "登录"
            
        case .bind:
            return "绑定"
            
        case .health:
            return "健康"
            
        case .editCard:
            return "编辑卡片"
        }
    }
    
}


// MARK: - 首页(Home)部署的模型
struct XWHHomeDeployItemModel {
    
    var type: XWHHomeDeployType
    var subType: XWHHealthyType = .none

    var items: [XWHHomeDeployItemModel] = []
    
    var rawData: Any?
    
    init(type: XWHHomeDeployType) {
        self.type = type
    }
    
}

class XWHHomeDeploy {
    
    /// 获取配置数据
    func loadDeploys(rawData: [String]) -> [XWHHomeDeployItemModel] {
        var deploys = [XWHHomeDeployItemModel]()
        
        var iItem = XWHHomeDeployItemModel(type: .weather)
        deploys.append(iItem)
        
        iItem = XWHHomeDeployItemModel(type: .activity)
        deploys.append(iItem)
        
        if !XWHUser.isLogined {
            iItem = XWHHomeDeployItemModel(type: .login)
            deploys.append(iItem)
        } else {
            if ddManager.getCurrentWatch() == nil {
                iItem = XWHHomeDeployItemModel(type: .bind)
                deploys.append(iItem)
            }
        }
        
        let cardMsg = XWHHealthCardManager()
        let healthCards = cardMsg.loadShowCards(userId: XWHUserDataManager.getCurrentUser()?.mobile ?? "")
        if !healthCards.isEmpty {
            iItem = XWHHomeDeployItemModel(type: .health)
            
            var cardItems: [XWHHomeDeployItemModel] = []
            var iCardItem: XWHHomeDeployItemModel
            for iHealthCard in healthCards {
                iCardItem = XWHHomeDeployItemModel(type: .health)
                iCardItem.subType = iHealthCard.cardType
                cardItems.append(iCardItem)
            }
            
            iItem.items = cardItems
            deploys.append(iItem)
        }
        
//        if XWHUser.isLogined {
        iItem = XWHHomeDeployItemModel(type: .editCard)
        deploys.append(iItem)
//        }
        
        return deploys
    }
    
}
