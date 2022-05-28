//
//  SignInWithApple.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/26.
//

import Foundation
import AuthenticationServices

/// 苹果登录用户模型
struct SignInWithAppleUserModel {
    
    // 用户id
    var userid = ""
    
    // 昵称
    var nickname = ""
    
    // 头像
    var avatar = ""
    
    // 密码
    var password = ""
    
}

/// 苹果登录
class SignInWithApple: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let shared: SignInWithApple = SignInWithApple()
    
    private var failureHandler: FailureHandler?
    private var successHandler: SuccessHandler?
    
    private override init() {
        
    }
    
    /// 去授权并获取用户信息
    func getUserInfo(at vc: UIViewController? = nil, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        self.failureHandler = failureHandler
        self.successHandler = successHandler
        
        if #available(iOS 13.0, *) {
            // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
            let appleIDProvider = ASAuthorizationAppleIDProvider()

            // 创建新的AppleID 授权请求
            let appleIDRequest = appleIDProvider.createRequest()
            
            // 在用户授权期间请求的联系信息
            appleIDRequest.requestedScopes = [.fullName, .email]

            // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
            let authorizationController = ASAuthorizationController(authorizationRequests: [appleIDRequest])
            
            // 设置授权控制器通知授权请求的成功与失败的代理
            authorizationController.delegate = self
            
            // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
            authorizationController.presentationContextProvider = self
            
            // 在控制器初始化期间启动授权流
            authorizationController.performRequests()
        } else {
            // 处理不支持系统版本
            let error = XWHError(message: "该系统版本不可用 Apple 登录")
            log.error(error)
            
            failureHandler?(error)
            
            self.failureHandler = nil
            self.successHandler = nil
        }
    }
    
    /// 如果存在iCloud Keychain 凭证或者AppleID 凭证提示用户
    func performExistingAccountSetupFlows(at vc: UIViewController? = nil, failureHandler: FailureHandler? = nil, successHandler: SuccessHandler? = nil) {
        self.failureHandler = failureHandler
        self.successHandler = successHandler
        
        if #available(iOS 13.0, *) {
            // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            // 授权请求AppleID
            let appleIDRequest = appleIDProvider.createRequest()
            
            // 为了执行钥匙串凭证分享生成请求的一种机制
            let passwordProvider = ASAuthorizationPasswordProvider()
            let passwordRequest = passwordProvider.createRequest()
            
            // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
            let authorizationController = ASAuthorizationController(authorizationRequests: [appleIDRequest, passwordRequest])
            
            // 设置授权控制器通知授权请求的成功与失败的代理
            authorizationController.delegate = self
            // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
            authorizationController.presentationContextProvider = self
            
            // 在控制器初始化期间启动授权流
            authorizationController.performRequests()
        } else {
            // 处理不支持系统版本
            let error = XWHError(message: "该系统版本不可用 Apple 登录")
            log.error(error)
            
            failureHandler?(error)
            
            self.failureHandler = nil
            self.successHandler = nil
        }
    }
    
    // MARK: - ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding
    /// 授权成功地回调
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        log.debug("授权完成::: credential = \(authorization.credential), controller = \(controller), authorization = \(authorization)")
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // 用户登录使用ASAuthorizationAppleIDCredential
            
            var userModel = SignInWithAppleUserModel()
            
            // 苹果用户唯一标识符，该值在同一个开发者账号下的所有 App 下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来。
            let appleIdUserStr = appleIDCredential.user
            
            userModel.userid = appleIdUserStr
            
            // 使用过授权的，可能获取不到以下三个参数
//            let familyName = appleIDCredential.fullName?.familyName
            let givenName = appleIDCredential.fullName?.givenName
//            let email = appleIDCredential.email
            
            userModel.nickname = givenName ?? ""
            
            guard let identityToken = appleIDCredential.identityToken, let authorizationCode = appleIDCredential.authorizationCode else {
                log.error("未获取到 identityToken, authorizationCode")
                
                return
            }
            
            // 服务器验证需要使用的参数
            guard let identityTokenStr = identityToken.string(encoding: .utf8), let authorizationCodeStr = authorizationCode.string(encoding: .utf8) else {
                log.error("未获取到 identityTokenStr, authorizationCodeStr")

                return
            }
            
            log.debug("identityTokenStr = \(identityTokenStr), authorizationCodeStr = \(authorizationCodeStr)")
            
            log.debug("appleIdUserStr = \(appleIdUserStr)")
            
            // Create an account in your system.
            // For the purpose of this demo app, store the userIdentifier in the keychain.
            
            //  需要使用钥匙串的方式保存用户的唯一信息
    //        [YostarKeychain save:KEYCHAIN_IDENTIFIER(@"userIdentifier") data:user];
            
            let ret = XWHResponse()
            ret.data = userModel
            successHandler?(ret)
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
            // Sign in using an existing iCloud Keychain credential.
            // 用户登录使用现有的密码凭证
            
            var userModel = SignInWithAppleUserModel()
            
            // 密码凭证对象的用户标识 用户的唯一标识
            let userStr = passwordCredential.user
            // 密码凭证对象的密码
            let passwordStr = passwordCredential.password
            
            userModel.userid = userStr
            userModel.password = passwordStr
            
            let ret = XWHResponse()
            ret.data = userModel
            successHandler?(ret)
        } else {
            let error = XWHError(message: "授权信息均不符")
            log.error(error)
            
            failureHandler?(error)
        }
        
        failureHandler = nil
        successHandler = nil
    }
    
    /// 授权失败的回调
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        log.error("Handle error：\(error)")
        
        guard let cError = error as? ASAuthorizationError else {
            let error = XWHError(message: error.localizedDescription)
            failureHandler?(error)
            
            failureHandler = nil
            successHandler = nil
            
            return
        }
        
        var errorMsg = ""
        
        switch cError.code {
        case .unknown:
            errorMsg = "授权请求失败未知原因"
        case .canceled:
            errorMsg = "用户取消了授权请求"
        case .invalidResponse:
            errorMsg = "授权请求响应无效"
        case .notHandled:
            errorMsg = "未能处理授权请求"
        case .failed:
            errorMsg = "授权请求失败"
        default:
            errorMsg = "授权请求失败其他原因"
        }
        
        let error = XWHError(message: errorMsg)
        log.error(error)
        
        failureHandler?(error)
        
        failureHandler = nil
        successHandler = nil
    }
    
    /// 告诉代理应该在哪个window 展示内容给用户
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow!
    }
    
}
