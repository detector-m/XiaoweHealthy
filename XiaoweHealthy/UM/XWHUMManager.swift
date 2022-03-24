//
//  XWHUMManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/24.
//

import Foundation


class XWHUMManager {
    
    // 配置友盟
    class func configUMCommon() {
        UMConfigure.initWithAppkey(kUMAppKey, channel: kUMChannel)
    }
    
    // 配置友盟分享
    class func configShare() {
        // U-Share 平台设置
        /*
         设置微信的appKey和appSecret
         [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
         */
        UMSocialManager.default().setPlaform(.wechatSession, appKey: kWechatAppKey, appSecret: kWechatAppSecret, redirectURL: nil)

        
        /* 设置分享到QQ互联的appID
         * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
         100424468.no permission of union id
         [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
         */
        UMSocialManager.default().setPlaform(.QQ, appKey: kQQAppKey, appSecret: nil, redirectURL: nil)
    }
    
    // 获取用户资料
    class func getUserInfo(pType: UMSocialPlatformType) {
        UMShareSwiftInterface.getUserInfo(plattype: pType, viewController: nil) { data, error in
            
        }
    }
    
}
