//
//  XWHSportShareView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/12.
//

import UIKit

class XWHSportShareView: XWHBaseView {

    lazy var overlayView = RLOverlayerBgView()
    lazy var dismissBtn = UIButton()
    
    lazy var contentView = XWHSportShareContentView()
    lazy var btnPanel = XWHSportShareBtnPanel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) + 99))
    
    var completion: ((XWHSportShareBtnType, UIImage) -> Void)?
        
    override func addSubViews() {
        super.addSubViews()
        addSubview(overlayView)
        addSubview(dismissBtn)
        
        addSubview(contentView)
        
        addSubview(btnPanel)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.backgroundColor = UIColor.white.cgColor
        
        overlayView.alpha = 0
        contentView.alpha = 0
        btnPanel.alpha = 0
        
        btnPanel.layer.cornerRadius = 16
        btnPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        btnPanel.layer.backgroundColor = UIColor.white.cgColor
        
        dismissBtn.contentHorizontalAlignment = .left
        let dismissImage = R.image.globalBack()
        dismissBtn.setImage(dismissImage, for: .normal)
        dismissBtn.addTarget(self, action: #selector(clickDismissBtn), for: .touchUpInside)
        
        btnPanel.completion = { [weak self] bType in
            guard let self = self else {
                return
            }
            
            self.contentView.getScreenshot { cImage in
                guard let image = cImage else {
                    log.error("运动分享截屏失败")
                    return
                }
                
                var plattype = UMSocialPlatformType.wechatSession
                
                if bType == .save {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    self.makeInsetToast("已保存到系统相册")
                } else if bType == .wechat {
                    plattype = .wechatSession
                    if !XWHUMManager.isWeixinInstalled {
                        self.makeInsetToast("未安装微信")
                        return
                    }
                } else if bType == .timeline {
                    plattype = .wechatTimeLine
                    if !XWHUMManager.isWeixinInstalled {
                        self.makeInsetToast("未安装微信")
                        return
                    }
                } else if bType == .qq {
                    plattype = .QQ
                    if !XWHUMManager.isQQInstalled {
                        self.makeInsetToast("未安装QQ")
                        return
                    }
                } else {
                    return
                }
                
                XWHUMManager.share(plattype: plattype, aImage: image, viewController: nil) { isOk in
                    if isOk {
                        self.makeInsetToast("分享成功")
//                        self.hide()
                    } else {
                        self.makeInsetToast("分享失败")
                    }
                }
            }
        }
    }
    
    override func relayoutSubViews() {
        overlayView.frame = bounds
        dismissBtn.frame = CGRect(x: 16, y: UIApplication.shared.statusBarFrame.height, width: 44, height: 44)
        
        let cWidth = bounds.width - 24
        let cHeight: CGFloat = 360
        contentView.frame = CGRect(x: 12, y: (bounds.size.height - cHeight) / 2, width: cWidth, height: cHeight)
        
        btnPanel.y = bounds.height - btnPanel.height
        
        overlayView.style = .blur
        overlayView.blurEffectStyle = .light
        overlayView.color = .clear
    }
    
    @objc private func clickDismissBtn() {
        hide()
    }
    
    func show() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.overlayView.alpha = 1
            self.contentView.alpha = 1
            self.btnPanel.alpha = 1
        } completion: { _ in }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.overlayView.alpha = 0
            self.contentView.alpha = 0
            self.btnPanel.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }

}

extension XWHSportShareView {
 
    class func show(sportInfo: XWHSportModel?) {
        let cView = XWHSportShareView(frame: UIScreen.main.bounds)
        UIApplication.shared.keyWindow?.addSubview(cView)
        
        cView.contentView.update(sportDetail: sportInfo)
        
        cView.show()
    }
    
    class func hide() {
        guard let subViews = UIApplication.shared.keyWindow?.subviews else {
            return
        }
        
        for iView in subViews {
            if let cView = iView as? XWHSportShareView {
                cView.hide()
                return
            }
        }
    }
    
}
