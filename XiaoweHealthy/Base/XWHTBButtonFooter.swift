//
//  XWHTBButtonFooter.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/7.
//

import UIKit

class XWHTBButtonFooter: XWHBaseView {
    
    lazy var button = UIButton()
    
    var clickCallback: (() -> ())?
    
    override func addSubViews() {
        super.addSubViews()
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor(hex: 0xffffff, transparency: 0.9), for: .normal)
        button.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        addSubview(button)
    }
    
    override func relayoutSubViews() {
        relayoutSubViews(leftRightInset: 0, bottomInset: 0, height: 48)
    }
    
    final func relayoutSubViews(leftRightInset: CGFloat = 0, bottomInset: CGFloat = 0, height: CGFloat = 48) {
        button.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(leftRightInset)
            make.height.equalTo(height)
            make.bottom.equalToSuperview().inset(bottomInset)
        }
    }
    
    @objc func clickButton() {
        clickCallback?()
    }

}
