//
//  XWHAlert.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/22.
//

import Foundation
import UIKit


class XWHAlert {
    
    class func show(text: String) {
//        let contentView = XWHAlertContentView()
//        contentView.textLb.text = text
//        contentView.layer.cornerRadius = 16
//        contentView.layer.backgroundColor = UIColor.white.cgColor
//

//
//        let layout: RLBaseAnimator.Layout = .bottom(.init(bottomMargin: 34, width: window.width - 24))
//
//        let animator = RLFadeInOutAnimator(layout: layout)
//        let popupView = RLPopupView(containerView: window, contentView: contentView, animator: animator)
//
//        popupView.isDismissible = false
//        popupView.isInteractive = false
//        //可以设置为false，再点击弹框中的button试试？
////        popupView.isInteractive = false
//        popupView.isPenetrable = false
//        //- 配置背景
//        popupView.backgroundView.style = .solidColor
//        popupView.backgroundView.blurEffectStyle = UIBlurEffect.Style.light
//        popupView.backgroundView.color = UIColor.black.withAlphaComponent(0.3)
//        popupView.display(animated: true, completion: nil)
        
        let window = UIApplication.shared.keyWindow!
        let alertView = XWHAlertView(frame: window.bounds)
        window.addSubview(alertView)
        
        alertView.show()
    }
    
    class func hide() {
        
    }
    
}

class XWHAlertView: XWHBaseView {
    
    lazy var overlayView = RLOverlayerBgView()
    lazy var contentView = XWHAlertContentView()
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(overlayView)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.backgroundColor = UIColor.white.cgColor
        addSubview(contentView)
        
        contentView.clickCallback = { [weak self] actionType in
            self?.hide()
        }
    }
    
    override func relayoutSubViews() {
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().offset(500)
            make.height.greaterThanOrEqualTo(100)
//            make.height.lessThanOrEqualTo(300)
            make.top.greaterThanOrEqualToSuperview().offset(100)
        }
        
        self.layoutIfNeeded()
    }
    
    func show() {
        UIView.animate(withDuration: 0.5) {
            self.contentView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().inset(12)
                make.bottom.equalToSuperview().inset(70)
                make.height.greaterThanOrEqualTo(100)
    //            make.height.lessThanOrEqualTo(300)
                make.top.greaterThanOrEqualToSuperview().offset(100)
            }
            self.layoutIfNeeded()
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.5) {
            self.contentView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().inset(12)
                make.bottom.equalToSuperview().offset(500)
                make.height.greaterThanOrEqualTo(100)
    //            make.height.lessThanOrEqualTo(300)
                make.top.greaterThanOrEqualToSuperview().offset(100)
            }
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
}

class XWHAlertContentView: XWHBaseView {
    
    enum ActionType {
        case cancel
        case confirm
    }

    lazy var titleLb = UILabel()
    lazy var messageLb = UILabel()
    
    lazy var cancelBtn = UIButton()
    lazy var confirmBtn = UIButton()
    
    var clickCallback: ((ActionType) -> Void)?
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        titleLb.font = R.font.harmonyOS_Sans_Medium(size: 20)
        titleLb.textAlignment = .center
        addSubview(titleLb)
        
        titleLb.text = "ABC"
        
        messageLb.font = R.font.harmonyOS_Sans(size: 16)
        messageLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        messageLb.numberOfLines = 0
        messageLb.text = "ETFETFETFETFETFETFETFETFETFETFETFETETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFETFF"
        addSubview(messageLb)
        
        cancelBtn.setTitle(R.string.xwhDisplayText.取消(), for: .normal)
        cancelBtn.titleLabel?.font = R.font.harmonyOS_Sans_Medium(size: 16)
        cancelBtn.setTitleColor(UIColor(hex: 0x000000, transparency: 0.9), for: .normal)
        cancelBtn.layer.cornerRadius = 24
        cancelBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.05)?.cgColor
        cancelBtn.addTarget(self, action: #selector(clickCancelBtn), for: .touchUpInside)
        addSubview(cancelBtn)
        
        confirmBtn.setTitle(R.string.xwhDisplayText.确定(), for: .normal)
        confirmBtn.titleLabel?.font = R.font.harmonyOS_Sans_Medium(size: 16)
        confirmBtn.layer.cornerRadius = 24
        confirmBtn.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        confirmBtn.addTarget(self, action: #selector(clickConfirmBtn), for: .touchUpInside)
        addSubview(confirmBtn)
    }
    
    override func relayoutSubViews() {
        relayoutForNormal()
    }
    
    func relayoutForNormal() {
        titleLb.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(20)
            make.height.lessThanOrEqualTo(30)
        }
        
        messageLb.snp.remakeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-90)
        }
        
        cancelBtn.snp.remakeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(snp.centerX).offset(-6)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-28)
        }
        
        confirmBtn.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-28)
            make.bottom.height.width.equalTo(cancelBtn)
        }
        
    }
    
    func relayoutForNoTitle() {
        
    }
    
    func relayoutForNoTitleCancel() {
        
    }
    
    @objc func clickCancelBtn() {
        if let callback = clickCallback {
            callback(.cancel)
        }
    }
    
    @objc func clickConfirmBtn() {
        if let callback = clickCallback {
            callback(.confirm)
        }
    }
    
//    override var intrinsicContentSize: CGSize {
//        let window = UIApplication.shared.keyWindow!
//
//        return CGSize(width: window.width - 24, height: 172)
//    }

}
