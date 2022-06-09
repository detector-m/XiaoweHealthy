//
//  XWHSportRecordListDeploy.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/9.
//

import Foundation


// MARK: -  item 的类型
enum XWHSRListDeployType: Int {
    
    /// 区块头
    case sectionHeader
    
    /// 运动头部
    case sportRecordHeader
    
    /// 运动记录
    case sportRecord
    
}

// MARK: - 运动记录列表(SportRecordList)部署的模型
struct XWHSRListDeployItemModel {
    
    var type: XWHSRListDeployType
    var items: [XWHSRListDeployItemModel] = []
    
    var rawData: Any?
    
    init(type: XWHSRListDeployType) {
        self.type = type
    }
    
}

class XWHSportRecordListDeploy {
    
    // 获取配置数据
    func loadDeploys(rawData: [String]) -> [XWHSRListDeployItemModel] {
        var deploys = [XWHSRListDeployItemModel]()
        
        var sectionItem = XWHSRListDeployItemModel(type: .sectionHeader)

        var srSectionItems = [XWHSRListDeployItemModel]()
        var iItem: XWHSRListDeployItemModel

        for _ in 0 ..< 5 {
            iItem = XWHSRListDeployItemModel(type: .sportRecordHeader)
            srSectionItems.append(iItem)
            
            for _ in 0 ..< 4 {
                iItem = XWHSRListDeployItemModel(type: .sportRecord)
                srSectionItems.append(iItem)
            }
        }
        
        sectionItem.items = srSectionItems
        deploys.append(sectionItem)
        
        return deploys
    }
    
}
