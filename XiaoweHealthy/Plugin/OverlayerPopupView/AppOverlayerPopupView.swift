//
//  AppOverlayerPopupView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/19.
//

import Foundation
import UIKit

class AppOverlayerPopupView: UIView {
    
    lazy var overlayMaskView = AppOverlayerMaskView()
    
    private lazy var _contentView = UIView()
    var contentView: UIView {
        _contentView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
        configMaskView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func addSubViews() {
        addSubview(overlayMaskView)
        addSubview(contentView)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.backgroundColor = UIColor.white.cgColor
    }
    
    @objc func relayoutSubViews() {
        overlayMaskView.frame = bounds
    }
    
    @objc func configMaskView() {
        overlayMaskView.style = .solidColor
    }
    
    @objc func show() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.overlayMaskView.alpha = 1
            self.contentView.alpha = 1
        } completion: { _ in }
    }
    
    @objc func hide() {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut) {
            self.overlayMaskView.alpha = 0
            self.contentView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
}
