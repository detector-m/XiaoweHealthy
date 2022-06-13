//
//  XWHHealthyMainCommonCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/28.
//

import UIKit

class XWHHealthyMainCommonCTCell: XWHCommonBaseCTCell {
    
    lazy var subImageView = UIImageView()
    
    override func addSubViews() {
        super.addSubViews()
        layer.cornerRadius = 16
        layer.backgroundColor = contentBgColor.cgColor
        
        contentView.addSubview(imageView)
        contentView.addSubview(subImageView)
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        
        imageView.layer.cornerRadius = 14
        imageView.layer.backgroundColor = fontDarkColor.withAlphaComponent(0.4).cgColor
        imageView.contentMode = .center
        
        subImageView.image = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 18, color: fontDarkColor.withAlphaComponent(0.4))
    }
    
    override func relayoutSubViews() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(28)
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        
        subImageView.snp.makeConstraints { make in
            make.size.equalTo(18)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        textLb.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(7)
            make.right.equalTo(subImageView.snp.left).offset(-7)
            make.top.equalTo(16)
            make.height.equalTo(22)
        }
        
        detailLb.snp.makeConstraints { make in
            make.left.right.equalTo(textLb)
            make.height.equalTo(16)
            make.top.equalTo(textLb.snp.bottom).offset(4)
        }
    }
    
}
