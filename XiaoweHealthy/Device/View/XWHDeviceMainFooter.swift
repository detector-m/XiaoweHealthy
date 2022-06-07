//
//  XWHDeviceMainFooter.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/30.
//

import UIKit

class XWHDeviceMainFooter: XWHTBButtonFooter {
    
    override func addSubViews() {
        super.addSubViews()
        
        button.removeTarget(self, action: nil, for: .touchUpInside)
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor(hex: 0xffffff, transparency: 0.9), for: .normal)
        button.layer.backgroundColor = UIColor(hex: 0x2DC84D)?.cgColor
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        
        button.setTitle(R.string.xwhDeviceText.解除绑定(), for: .normal)
    }
    
    override func relayoutSubViews() {
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(48)
        }
    }
    
    @objc override func clickButton() {
        clickCallback?()
    }

}
