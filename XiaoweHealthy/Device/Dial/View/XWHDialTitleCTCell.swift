//
//  XWHDialTitleCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit

class XWHDialTitleCTCell: XWHBaseCTCell {
    
    lazy var button = UIButton()
    
    var clickAction: (() -> Void)?
    
    override func addSubViews() {
        super.addSubViews()
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        contentView.addSubview(textLb)
    
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 12)
        button.setTitleColor(fontLightColor, for: .normal)
        button.setTitle(R.string.xwhDeviceText.更多(), for: .normal)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        contentView.addSubview(button)
        
        imageView.image = UIImage.iconFont(text: XWHIconFontOcticons.cellArrowRight.rawValue, size: 18, color: fontLightColor)
        contentView.addSubview(imageView)
    }
    
    override func relayoutSubViews() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.right.equalTo(imageView.snp.left)
            make.left.greaterThanOrEqualTo(textLb.snp.right).offset(10)
            make.centerY.equalToSuperview()
            make.height.equalTo(16)
        }
        
        textLb.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }
    }
    
    @objc private func clickButton() {
        clickAction?()
    }
    
    func update(_ category: XWHDialCategoryModel) {
        textLb.text = category.name
    }
    
}
