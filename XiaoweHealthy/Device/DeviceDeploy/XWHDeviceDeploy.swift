//
//  XWHDeviceDeploy.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/30.
//

import Foundation


// MARK: - item 的类型
enum XWHDeviceDeployType: Int {
    
    case info = 0 // 设备信息
    
    case guide = 100 // 使用指南
    case recover = 101 // 恢复出厂
    case update = 102 // 检查更新
    
    case dialMarket = 200 // 表盘市场
    
    case chat = 300 // 消息通知
    case call = 301 // 来电提醒
    case user = 302 // 通讯录（联系人）
    case heart = 303 // 心率设置
    case oxygen = 304 // 血氧饱和度设置
    case pressure = 305 // 压力设置
    case stand = 306 // 久坐提醒
    case weather = 307 // 天气推送
    case schedule = 308 // 日程设置
    case wrist = 309 // 抬腕亮屏
    case disturb = 310 // 勿扰模式
    
}

// MARK: - cell 的类型
enum XWHDeployCellType: Int {
    
    case nomal = 0
    case `switch` = 1
    case explanation = 2
    case dial = 3
    case info = 4
    
}

// MARK: - 设备部署的模型
struct XWHDeployItemModel {
    
    var title = ""
    var subTitle = ""
    
    var iconBgColor: UIColor? 
    var iconImageName = ""
    
    var type: XWHDeviceDeployType
    var cellType: XWHDeployCellType = .nomal
    
    init(type: XWHDeviceDeployType) {
        self.type = type
    }
    
}

class XWHDeviceDeploy {
    
    // 各系列产品功能配置
    lazy var deviceInfoDeploy: [XWHDeviceDeployType] = [.info]
    
    lazy var commonDeploy1: [XWHDeviceDeployType] = [.chat, .call, .user]
    lazy var commonDeploy2: [XWHDeviceDeployType] = [.heart, .oxygen, .pressure, .stand]
    lazy var commonDeploy3: [XWHDeviceDeployType] = [.weather, .wrist, .disturb]

    // 表盘市场
    lazy var dialCommonDeploy: [XWHDeviceDeployType] = [.dialMarket]
    
    lazy var deviceCommonDeploy: [XWHDeviceDeployType] = [.guide, .recover, .update]
    
    // 获取配置数据
    func loadDeploys() -> [[XWHDeployItemModel]] {
        let deployTypes = loadDeployTypes()

        return loadDeployItems(deployTypes: deployTypes)
    }
    
    // 获取配置类型
    private func loadDeployTypes() -> [[XWHDeviceDeployType]] {
        var deployTypes = [[XWHDeviceDeployType]]()
        
        deployTypes.append(deviceInfoDeploy)
        
        deployTypes.append(dialCommonDeploy)
        
        deployTypes.append(commonDeploy1)
        deployTypes.append(commonDeploy2)
        deployTypes.append(commonDeploy3)
        
        deployTypes.append(deviceCommonDeploy)

        return deployTypes
    }
    
    // 通过配置项获取DeviceDeploys数组
    private func loadDeployItems(deployTypes: [[XWHDeviceDeployType]]) -> [[XWHDeployItemModel]] {
        var dataArr = [[XWHDeployItemModel]]()
        
        for item in deployTypes {
            var source = [XWHDeployItemModel]()
            
            item.forEach { deployType in
                source.append(getDeployItem(deployType))
            }
            
            dataArr.append(source)
        }
        
        return dataArr
    }
    
    private func getDeployItem(_ type: XWHDeviceDeployType) -> XWHDeployItemModel {
        
        var item = XWHDeployItemModel(type: type)
        
        switch type {
        case .info:
            item.cellType = .info
            
        case .guide:
            item.title = R.string.xwhDeviceText.使用指南()
            item.iconBgColor = UIColor(hex: 0x6AACF7)
            item.iconImageName = "DeviceGuide"
            
        case .recover:
            item.title = R.string.xwhDeviceText.恢复出厂设置()
            item.iconBgColor = UIColor(hex: 0x8389F3)
            item.iconImageName = "DeviceRecover"
            
        case .update:
            item.title = R.string.xwhDeviceText.检查更新()
            item.iconBgColor = UIColor(hex: 0x6AACF7)
            item.iconImageName = "DeviceUpdate"
            
            
        case .dialMarket:
            item.title = R.string.xwhDialText.表盘市场()
            item.subTitle = R.string.xwhDeviceText.更多()
            item.cellType = .dial
//            item.iconBgColor = UIColor(hex: 0x6AACF7)
//            item.iconImageName = "DeviceUpdate"
            
            
        case .chat:
            let isOn = ddManager.getCurrentNoticeSet()?.isOn ?? false
            
            item.title = R.string.xwhDeviceText.消息通知()
            item.subTitle = isOn ? R.string.xwhDeviceText.开启() : R.string.xwhDeviceText.未开启()
            item.iconBgColor = UIColor(hex: 0x49CE64)
            item.iconImageName = "DeviceChat"
            
        case .call: // 来电提醒
            let isOn = ddManager.getCurrentNoticeSet()?.isOnCall ?? false

            item.title = R.string.xwhDeviceText.来电提醒()
            item.subTitle = isOn ? R.string.xwhDeviceText.开启() : R.string.xwhDeviceText.未开启()
            item.iconBgColor = UIColor(hex: 0x6AACF7)
            item.iconImageName = "DeviceCall"
            
        case .user: // 通讯录（联系人）
            item.title = R.string.xwhDeviceText.通讯录()
            item.iconBgColor = UIColor(hex: 0x49CE64)
            item.iconImageName = "DeviceUser"

            
        case .heart: // 心率设置
            item.title = R.string.xwhDeviceText.心率设置()
            item.iconBgColor = UIColor(hex: 0xEB5763)
            item.iconImageName = "DeviceHeart"

        case .oxygen: // 血氧饱和度设置
            item.title = R.string.xwhDeviceText.血氧饱和度设置()
            item.iconBgColor = UIColor(hex: 0x6CD267)
            item.iconImageName = "DeviceOxygen"

        case .pressure: // 压力设置
            item.title = R.string.xwhDeviceText.压力设置()
            item.iconBgColor = UIColor(hex: 0x76D4EA)
            item.iconImageName = "DevicePressure"

        case .stand: // 久坐提醒
            item.title = R.string.xwhDeviceText.久坐提醒()
            item.iconBgColor = UIColor(hex: 0x49CE64)
            item.iconImageName = "DeviceStand"
            
        case .weather: // 天气推送
            item.title = R.string.xwhDeviceText.天气推送()
            item.iconBgColor = UIColor(hex: 0x6AACF7)
            item.iconImageName = "DeviceWeather"
            
        case .schedule: // 日程设置
            item.title = R.string.xwhDeviceText.日程设置()
            item.iconBgColor = UIColor(hex: 0x6CD267)
            item.iconImageName = "DeviceSchedule"
            
        case .wrist: // 抬腕亮屏
            item.title = R.string.xwhDeviceText.抬腕亮屏()
            item.iconBgColor = UIColor.orange
            item.iconImageName = "DeviceWrist"
            
        case .disturb: // 勿扰模式
            item.title = R.string.xwhDeviceText.勿扰模式()
            item.iconBgColor = UIColor(hex: 0x6CD267)
            item.iconImageName = "DeviceDisturb"
        }
        
        return item
    }
    
}
