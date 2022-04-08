//
//  XWHProgressHUD.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/21.
//

import UIKit


class XWHProgressHUD {
    
    class func showLogin(text: String) {
        let contentView = XWHLoginProgressHUDContentView()
        contentView.textLb.text = text
        contentView.layer.cornerRadius = 16
        contentView.layer.backgroundColor = UIColor.white.cgColor
        
        let window = UIApplication.shared.keyWindow!
//        contentView.size = CGSize(width: window.width - 24, height: 70)
        
        let layout: RLBaseAnimator.Layout = .bottom(.init(bottomMargin: 34))
        
        let animator = RLFadeInOutAnimator(layout: layout)
        let popupView = RLPopupView(containerView: window, contentView: contentView, animator: animator)

        popupView.isDismissible = false
        popupView.isInteractive = false
        //可以设置为false，再点击弹框中的button试试？
//        popupView.isInteractive = false
        popupView.isPenetrable = false
        //- 配置背景
        popupView.backgroundView.style = .solidColor
        popupView.backgroundView.blurEffectStyle = UIBlurEffect.Style.light
        popupView.backgroundView.color = UIColor.black.withAlphaComponent(0.3)
        popupView.display(animated: false, completion: nil)
    }
    
    class func hideLogin() {
        UIApplication.shared.keyWindow?.popupView()?.dismiss(animated: true, completion: nil)
    }
    
    class func show(title: String? = nil) {
        let window = UIApplication.shared.keyWindow!
        let hud = XWHProgressHUDView(frame: window.bounds)
        window.addSubview(hud)

        hud.show(title: title)
    }
    
    class func hide() {
        let window = UIApplication.shared.keyWindow!
        for v in window.subviews {
            if let hud = v as? XWHProgressHUDView {
                hud.hideAnimation()
                return
            }
        }
    }
    
}
