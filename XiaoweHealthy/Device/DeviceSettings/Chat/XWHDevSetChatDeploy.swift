//
//  XWHDevSetChatDeploy.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/31.
//

import Foundation

// MARK: - item 的类型
enum XWHDevSetChatDeployType: Int {
    
//    case none = 0 // 空
    
    case message = 1 // 信息
    
    case wechat // 微信
    case qq // qq
    
    case weibo // 微博
    
    case zhifubao // 支付宝
    
    case baiduMap // 百度地图
    case jinritoutiao // 今日头条
    case meituan // 美团
    case qiyeweixin // 企业微信
    
}

// MARK: - 设备消息通知部署的模型
class XWHDevSetChatDeployItemModel {
    
    var title = ""
    var type: XWHDevSetChatDeployType
    
    var isOn = false
    
    init(type: XWHDevSetChatDeployType) {
        self.type = type
    }
    
}

class XWHDevSetChatDeploy {
    
    // 各系列产品功能配置
    lazy var chatDeploy: [XWHDevSetChatDeployType] = [.message, .wechat, .qq]
    
    var noticeSet: XWHNoticeSetModel?
    
    // 获取配置数据
    func loadDeploys(noticeSet: XWHNoticeSetModel?) -> [XWHDevSetChatDeployItemModel] {
        self.noticeSet = noticeSet
        let deployTypes = loadDeployTypes()

        return loadDeployItems(deployTypes: deployTypes)
    }
    
    // 获取配置类型
    private func loadDeployTypes() -> [XWHDevSetChatDeployType] {
        return chatDeploy
    }
    
    // 通过配置项获取DevSetChatDeploys数组
    private func loadDeployItems(deployTypes: [XWHDevSetChatDeployType]) -> [XWHDevSetChatDeployItemModel] {
        var dataArr = [XWHDevSetChatDeployItemModel]()
        
        for deployType in deployTypes {
            dataArr.append(getDeployItem(deployType))
        }
        
        return dataArr
    }
    
    private func getDeployItem(_ type: XWHDevSetChatDeployType) -> XWHDevSetChatDeployItemModel {
        
        let item = XWHDevSetChatDeployItemModel(type: type)
        
        switch type {
        case .message:
            // 信息
            item.title = R.string.xwhDeviceText.信息()
            item.isOn = noticeSet?.isOnSms ?? false
            
        case .wechat:
            // 微信
            item.title = R.string.xwhDeviceText.微信()
            item.isOn = noticeSet?.isOnWeChat ?? false
            
        case .qq:
            // qq
            item.title = R.string.xwhDeviceText.qQ()
            item.isOn = noticeSet?.isOnQQ ?? false
        
        case .weibo:
            // 微博
            item.title = R.string.xwhDeviceText.微博()
        
        case .zhifubao:
            // 支付宝
            item.title = R.string.xwhDeviceText.支付宝()
        
        case .baiduMap:
            // 百度地图
            item.title = R.string.xwhDeviceText.百度地图()
            
        case .jinritoutiao:
            // 今日头条
            item.title = R.string.xwhDeviceText.今日头条()
            
        case .meituan:
            // 美团
            item.title = R.string.xwhDeviceText.美团()
            
        case .qiyeweixin:
            // 企业微信
            item.title = R.string.xwhDeviceText.企业微信()
        }
        
        return item
    }
    
}
