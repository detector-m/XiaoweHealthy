//
//  RLPopupBaseView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/1.
//

import UIKit

class RLPopupBaseView: UIView {
    
    lazy var overlayView = RLOverlayerBgView()
    
    private lazy var _contentView = RLPopupContentBaseView()
    var contentView: RLPopupContentBaseView {
        get {
            _contentView
        }
//        set {
//            _contentView = newValue
//        }
    }
    
    var contentCenterY: CGFloat = 0
    
    var clickCallback: ((RLPopupContentBaseView.ActionType) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    func addSubViews() {
        overlayView.alpha = 0
        addSubview(overlayView)
        
        contentView.layer.cornerRadius = 16
        contentView.layer.backgroundColor = UIColor.white.cgColor
        addSubview(contentView)
    }
    
    func relayoutSubViews() {
        relayoutOverlayView()
    }
    
    func relayoutOverlayView() {
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func showAnimation() {
        contentView.center.y = contentCenterY + 500
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.overlayView.alpha = 1

            self.contentView.center.y = self.contentCenterY
        } completion: { _ in }
    }
    
    func hideAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.overlayView.alpha = 0

            self.contentView.center.y = self.contentCenterY + 500
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
}
