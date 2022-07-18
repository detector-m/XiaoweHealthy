//
//  XWHMeDeploy.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/7.
//

import Foundation


// MARK: - Me item 的类型
enum XWHMeDeployType: Int {
    
    /// 个人描述
    case profile

    /// 设置
    case settings
    
    /// 建议反馈
    case feedback
    
    /// app update
    case appUpdate
    
    /// about
    case about
}

// MARK: - 我的(Me)部署的模型
struct XWHMeDeployItemModel {
    
    var title = ""
    var subTitle = ""
    
    var iconBgColor: UIColor?
    var iconImageName = ""
    
    var type: XWHMeDeployType
//    var cellType: XWHDeviceDeployCellType = .nomal
    
    init(type: XWHMeDeployType) {
        self.type = type
    }
    
}

class XWHMeDeploy {
    
    lazy var profileDeploy: [XWHMeDeployType] = [.profile]
    
    lazy var commonDeploy: [XWHMeDeployType] = [.settings, .feedback, .appUpdate, .about]
    
    // 获取配置数据
    func loadDeploys() -> [[XWHMeDeployItemModel]] {
        let deployTypes = loadDeployTypes()

        return loadDeployItems(deployTypes: deployTypes)
    }
    
    // 获取配置类型
    private func loadDeployTypes() -> [[XWHMeDeployType]] {
        var deployTypes = [[XWHMeDeployType]]()
        
        deployTypes.append(profileDeploy)
        deployTypes.append(commonDeploy)

        return deployTypes
    }
    
    // 通过配置项获取DeviceDeploys数组
    private func loadDeployItems(deployTypes: [[XWHMeDeployType]]) -> [[XWHMeDeployItemModel]] {
        var dataArr = [[XWHMeDeployItemModel]]()
        
        for item in deployTypes {
            var source = [XWHMeDeployItemModel]()
            
            item.forEach { deployType in
                source.append(getDeployItem(deployType))
            }
            
            dataArr.append(source)
        }
        
        return dataArr
    }
    
    private func getDeployItem(_ type: XWHMeDeployType) -> XWHMeDeployItemModel {
        
        var item = XWHMeDeployItemModel(type: type)
        
        switch type {
        case .profile:
            break
            
        case .settings:
            item.title = R.string.xwhDisplayText.设置()
            item.iconImageName = "user_settings_icon"
            
        case .feedback:
            item.title = "建议反馈"
            item.iconImageName = "feedback_icon"
            
        case .appUpdate:
            item.title = "APP检查更新"
            item.iconImageName = "app_update_icon"
        
        case .about:
            item.title = "关于"
            item.iconImageName = "about_icon"
        }
        
        return item
    }
    
}
