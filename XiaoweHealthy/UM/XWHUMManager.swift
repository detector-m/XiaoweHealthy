//
//  XWHUMManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/24.
//

import Foundation
import UIKit


class XWHUMManager {
    
    /// 是否安装了 微信
    static var isWeixinInstalled: Bool {
        return UMSocialManager.default().isInstall(.wechatSession)
    }
    
    /// 是否安装了 QQ
    static var isQQInstalled: Bool {
        return UMSocialManager.default().isInstall(.QQ)
    }
    
    // 配置友盟
    class func configUMCommon() {
        UMConfigure.initWithAppkey(kUMAppKey, channel: kUMChannel)
    }
    
    // 配置友盟分享
    class func configShare() {
        UMSocialGlobal.shareInstance().universalLinkDic = [UMSocialPlatformType.wechatSession.rawValue: kWechatUniversalLink, UMSocialPlatformType.QQ.rawValue: kQQUniversalLink]
        
        // U-Share 平台设置
        /*
         设置微信的appKey和appSecret
         [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
         */
        UMSocialManager.default().setPlaform(.wechatSession, appKey: kWechatAppKey, appSecret: kWechatAppSecret, redirectURL: kRedirectURL)

        
        /* 设置分享到QQ互联的appID
         * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
         100424468.no permission of union id
         [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
         */
        UMSocialManager.default().setPlaform(.QQ, appKey: kQQAppKey, appSecret: kQQAppSecret, redirectURL: kRedirectURL)
    }
    
    // 获取用户资料
    class func getUserInfo(pType: UMSocialPlatformType, vc: UIViewController?, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        UMShareSwiftInterface.getUserInfo(plattype: pType, viewController: vc) { data, error in
            let retIdStr = "thirdLogin-getUserInfo"
            var retError = XWHError()
            retError.identifier = retIdStr
            
            if let cError = error {
                retError.message = cError.localizedDescription
                log.error("第三方获取用户资料 error: \(retError)")
                
                failureHandler?(retError)
                return
            }
            
            guard let userInfo = data as? UMSocialUserInfoResponse else {
                retError.message = "返回的数据格式不对"
                log.error("第三方获取用户资料 error: \(retError)")
                
                failureHandler?(retError)
                return
            }
            
            let retResponse = XWHResponse()
            retResponse.identifier = retIdStr
            retResponse.data = userInfo
            successHandler?(retResponse)
        }
    }
    
    /// 分享一张图片
    class func share(plattype: UMSocialPlatformType, aImage: UIImage, viewController: UIViewController?, completion: @escaping (Bool) -> Void) {
        let imageObject = UMShareImageObject.shareObject(withTitle: "运动报告", descr: "我的运动详情", thumImage: nil)
        imageObject?.shareImage = aImage
        guard let messageObject = UMSocialMessageObject(mediaObject: imageObject) else {
            completion(false)
            return
        }
        UMShareSwiftInterface.share(plattype: plattype, messageObject: messageObject, viewController: viewController) { result, error in
            var isOk = true
            if error != nil {
                log.error(error!)
                isOk = false
            }
            
            completion(isOk)
        }
    }
    
    
    // 打开回调
    class func handleOpen(url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
        let result = UMSocialManager.default().handleOpen(url, options: options)
        if !result {
            
        }
        
        return result;
    }
    
    class func handleOpen(url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let result = UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        
        if !result {
        }
        
        return result
    }
    
    class func handleOpen(url: URL) -> Bool {
        let result = UMSocialManager.default().handleOpen(url)
        
        if !result {
        }
        
        return result
    }
    
    @discardableResult
    class func handleUniversalLink(userActivity: NSUserActivity) -> Bool {
        return UMSocialManager.default().handleUniversalLink(userActivity, options: nil)
    }
    
}
