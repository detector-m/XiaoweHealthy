//
//  XWHProgressHUDViews.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/8.
//

import Foundation
import UIKit


class XWHProgressHUDView: RLPopupBaseView {

    private lazy var _contentView = XWHProgressHUDContentView()
    
    override var contentView: RLPopupContentBaseView {
        _contentView
    }
    
    override func addSubViews() {
        super.addSubViews()
        overlayView.color = .clear
        contentView.layer.cornerRadius = 0
        contentView.layer.backgroundColor = UIColor.clear.cgColor
//        contentView.layer.backgroundColor = fontDarkColor.withAlphaComponent(0.1).cgColor
    }
    
    func show(title: String? = nil) {
        if let cTitle = title {
            contentView.titleLb.text = cTitle
        }
        
        contentView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.height.greaterThanOrEqualTo(160)
        }
        
        layoutIfNeeded()
        contentCenterY = contentView.center.y
        
        showAnimation()
    }
    
    override func showAnimation() {
        contentView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: []) {
            self.contentView.alpha = 1
        } completion: { _ in }
    }

    override func hideAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: []) {
            self.contentView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
}

class XWHProgressHUDContentView: RLPopupContentBaseView {
    
    lazy var hudImageView: UIImageView = UIImageView()
    
    deinit {
        hudImageView.layer.removeAllAnimations()
    }
    
    override func addSubViews() {
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 16)
        titleLb.textColor = fontLightColor
        titleLb.numberOfLines = 1
        titleLb.textAlignment = .center
        titleLb.text = R.string.xwhDisplayText.正在加载()
        addSubview(titleLb)
        
        hudImageView.image = R.image.loading()?.tint(fontDarkColor, blendMode: .destinationIn)
        addSubview(hudImageView)
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.toValue = Double.pi * 2
        rotateAnimation.duration = 1
        rotateAnimation.repeatCount = .infinity
        hudImageView.layer.add(rotateAnimation, forKey: nil)
    }
    
    override func relayoutSubViews() {
        hudImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.centerY.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(20)
            make.top.equalTo(hudImageView.snp.bottom).offset(10)
        }
    }
    
}
