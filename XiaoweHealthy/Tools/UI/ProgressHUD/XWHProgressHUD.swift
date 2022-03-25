//
//  XWHProgressHUD.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/21.
//

import UIKit


class XWHProgressHUD {
    
    class func show(text: String) {
        let contentView = XWHProgressHUDContentView()
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
    
    class func hide() {
        UIApplication.shared.keyWindow?.popupView()?.dismiss(animated: true, completion: nil)
    }
    
}

class XWHProgressHUDContentView: XWHBaseView {

    lazy var loadingView: UIImageView = UIImageView()
    lazy var textLb = UILabel()
    
    deinit {
        layer.removeAllAnimations()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        loadingView.image = R.image.loading()
        addSubview(loadingView)
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.toValue = Double.pi * 2
        rotateAnimation.duration = 1
        rotateAnimation.repeatCount = .infinity
        loadingView.layer.add(rotateAnimation, forKey: nil)
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 16)
        textLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        textLb.numberOfLines = 0
        addSubview(textLb)
    }
    
    override func relayoutSubViews() {
        loadingView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(24)
        }
        
        textLb.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
            make.left.equalTo(loadingView.snp.right).offset(12)
            make.right.equalToSuperview().offset(-24)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let window = UIApplication.shared.keyWindow!

        return CGSize(width: window.width - 24, height: 70)
    }

}
