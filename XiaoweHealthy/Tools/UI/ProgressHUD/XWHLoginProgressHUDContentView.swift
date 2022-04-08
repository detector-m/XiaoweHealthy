//
//  XWHProgressHUDContentView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/8.
//

import Foundation

class XWHLoginProgressHUDContentView: XWHBaseView {

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
