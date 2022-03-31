//
//  XWHAlert.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/22.
//

import Foundation
import UIKit


class XWHAlert {
    
    class func show(title: String? = nil, message: String?, cancelTitle: String? = R.string.xwhDisplayText.取消(), confirmTitle: String? = R.string.xwhDisplayText.确定(), action: ((XWHAlertContentView.ActionType) -> Void)? = nil) {
        let window = UIApplication.shared.keyWindow!
        let alertView = XWHAlertView(frame: window.bounds)
        window.addSubview(alertView)

        alertView.show(title: title, message: message, cancelTitle: cancelTitle, confirmTitle: confirmTitle, action: action)
    }
    
}

class XWHAlertView: XWHBaseView {
    
    lazy var overlayView = RLOverlayerBgView()
    lazy var contentView = XWHAlertContentView()
    
    var contentCenterY: CGFloat = 0
    
    private var clickCallback: ((XWHAlertContentView.ActionType) -> Void)?
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(overlayView)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.backgroundColor = UIColor.white.cgColor
        addSubview(contentView)
    }
    
    override func relayoutSubViews() {
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func show(title: String? = nil, message: String?, cancelTitle: String? = R.string.xwhDisplayText.取消(), confirmTitle: String? = R.string.xwhDisplayText.确定(), action: ((XWHAlertContentView.ActionType) -> Void)? = nil) {
        contentView.titleLb.text = title
        contentView.messageLb.text = message
        contentView.cancelBtn.setTitle(cancelTitle, for: .normal)
        contentView.confirmBtn.setTitle(confirmTitle, for: .normal)
        clickCallback = action
        contentView.clickCallback = { [weak self] actionType in
            self?.clickCallback?(actionType)
            
            self?.hideAnimation()
        }
        
        if title != nil, message != nil, cancelTitle != nil, confirmTitle != nil {
            contentView.relayoutForNormal()
        } else if title == nil, cancelTitle == nil {
            contentView.relayoutForNoTitleCancel()
        } else if title == nil {
            contentView.relayoutForNoTitle()
        } else {
            
        }
        
        contentView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(70)
            make.height.greaterThanOrEqualTo(100)
//            make.height.lessThanOrEqualTo(300)
            make.top.greaterThanOrEqualToSuperview().offset(100)
        }
        
        layoutIfNeeded()
        contentCenterY = contentView.center.y
        
        showAnimation()
    }
    
    func showAnimation() {
        contentView.center.y = contentCenterY + 500
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.contentView.center.y = self.contentCenterY
        } completion: { _ in }
    }
    
    func hideAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.contentView.center.y = self.contentCenterY + 500
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
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)
        titleLb.textAlignment = .center
        addSubview(titleLb)
        
        messageLb.font = XWHFont.harmonyOSSans(ofSize: 16)
        messageLb.textColor = UIColor(hex: 0x000000, transparency: 0.9)
        messageLb.numberOfLines = 0
        addSubview(messageLb)
        
        cancelBtn.setTitle(R.string.xwhDisplayText.取消(), for: .normal)
        cancelBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        cancelBtn.setTitleColor(UIColor(hex: 0x000000, transparency: 0.9), for: .normal)
        cancelBtn.layer.cornerRadius = 24
        cancelBtn.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.05)?.cgColor
        cancelBtn.addTarget(self, action: #selector(clickCancelBtn), for: .touchUpInside)
        addSubview(cancelBtn)
        
        confirmBtn.setTitle(R.string.xwhDisplayText.确定(), for: .normal)
        confirmBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        confirmBtn.layer.cornerRadius = 24
        confirmBtn.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        confirmBtn.addTarget(self, action: #selector(clickConfirmBtn), for: .touchUpInside)
        addSubview(confirmBtn)
    }
    
    override func relayoutSubViews() {
//        relayoutForNormal()
        
//        relayoutForNoTitle()
        
//        relayoutForNoTitleCancel()
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
        titleLb.isHidden = true
        
        messageLb.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(24)
            make.bottom.equalToSuperview().offset(-90)
        }
        
        cancelBtn.snp.remakeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(snp.centerX).offset(-6)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-28)
        }
        
        confirmBtn.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.bottom.height.width.equalTo(cancelBtn)
        }
    }
    
    func relayoutForNoTitleCancel() {
        titleLb.isHidden = true
        cancelBtn.isHidden = true
        
        messageLb.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(24)
            make.bottom.equalToSuperview().offset(-90)
        }
        
        confirmBtn.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-28)
        }
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
