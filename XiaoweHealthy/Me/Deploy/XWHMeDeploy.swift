//
//  XWHMeDeploy.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/7.
//

import Foundation


// MARK: - Me item 的类型
enum XWHMeDeployType: Int {
    
    /// 登录
    case login = 0
    
    /// 个人描述
    case profile
    
    /// 我的数据
    case data
    
    /// 个人资料
    case info

    /// 设置
    case settings
    
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
     
    lazy var loginDeploy: [XWHMeDeployType] = [.login]
    
    lazy var profileDeploy: [XWHMeDeployType] = [.profile]
    
    lazy var commonDeploy1: [XWHMeDeployType] = [.data, .info]
    lazy var commonDeploy2: [XWHMeDeployType] = [.settings]
    
    // 获取配置数据
    func loadDeploys(isLogin: Bool) -> [[XWHMeDeployItemModel]] {
        let deployTypes = loadDeployTypes(isLogin: isLogin)

        return loadDeployItems(deployTypes: deployTypes)
    }
    
    // 获取配置类型
    private func loadDeployTypes(isLogin: Bool) -> [[XWHMeDeployType]] {
        var deployTypes = [[XWHMeDeployType]]()
        
        if !isLogin {
            deployTypes.append(loginDeploy)
            
            return deployTypes
        }
        
        deployTypes.append(profileDeploy)
        
        deployTypes.append(commonDeploy1)
        deployTypes.append(commonDeploy2)

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
        case .login:
            break
        
        case .profile:
            break
            
        case .data:
            item.title = R.string.xwhDisplayText.我的数据()
//            item.iconBgColor = UIColor(hex: 0x6AACF7)
//            item.iconImageName = "DeviceGuide"
            
        case .info:
            item.title = R.string.xwhDisplayText.个人资料()
//            item.iconBgColor = UIColor(hex: 0x6AACF7)
//            item.iconImageName = "DeviceGuide"
            
        case .settings:
            item.title = R.string.xwhDisplayText.设置()
//            item.iconBgColor = UIColor(hex: 0x8389F3)
//            item.iconImageName = "DeviceRecover"
        }
        
        return item
    }
    
}
