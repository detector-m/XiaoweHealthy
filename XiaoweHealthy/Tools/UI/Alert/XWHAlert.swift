//
//  XWHAlert.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/22.
//

import Foundation
import UIKit


class XWHAlert {
    
    class func show(title: String? = nil, message: String?, cancelTitle: String? = R.string.xwhDisplayText.取消(), confirmTitle: String? = R.string.xwhDisplayText.确定(), action: ((RLPopupContentBaseView.ActionType) -> Void)? = nil) {
        let window = UIApplication.shared.keyWindow!
        let alertView = XWHAlertView(frame: window.bounds)
        window.addSubview(alertView)

        alertView.show(title: title, message: message, cancelTitle: cancelTitle, confirmTitle: confirmTitle, action: action)
    }
    
}

class XWHAlertView: RLPopupBaseView {

    private lazy var _contentView = XWHAlertContentView()
    
    override var contentView: RLPopupContentBaseView {
        _contentView
    }
    
    override func addSubViews() {
        super.addSubViews()
        
//        addSubview(overlayView)
        
//        contentView.layer.cornerRadius = 16
//        contentView.layer.backgroundColor = UIColor.white.cgColor
//        addSubview(contentView)
    }
    
//    override func relayoutSubViews() {
//        overlayView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
    
    func show(title: String? = nil, message: String?, cancelTitle: String? = R.string.xwhDisplayText.取消(), confirmTitle: String? = R.string.xwhDisplayText.确定(), action: ((RLPopupContentBaseView.ActionType) -> Void)? = nil) {
        contentView.titleLb.text = title
        contentView.detailLb.text = message
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
    
//    func showAnimation() {
//        contentView.center.y = contentCenterY + 500
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
//            self.contentView.center.y = self.contentCenterY
//        } completion: { _ in }
//    }
//    
//    func hideAnimation() {
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
//            self.contentView.center.y = self.contentCenterY + 500
//        } completion: { _ in
//            self.removeFromSuperview()
//        }
//    }
    
}

class XWHAlertContentView: RLPopupContentBaseView {
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.isHidden = false
        detailLb.isHidden = false
    }
    
}
