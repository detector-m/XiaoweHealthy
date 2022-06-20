//
//  XWHHomeWeatherCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/20.
//

import UIKit

class XWHHomeWeatherCTCell: XWHBaseCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(imageView)
        contentView.addSubview(textLb)
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
        
//        imageView.layer.cornerRadius = 14
//        imageView.layer.backgroundColor = fontDarkColor.withAlphaComponent(0.4).cgColor
//        imageView.contentMode = .center
        
        imageView.image = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 14, color: fontDarkColor)
    }
    
    override func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
//            make.right.equalTo(subImageView.snp.left).offset(-7)
            make.top.equalTo(6)
            make.height.equalTo(19)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(14)
            make.left.equalTo(textLb.snp.right).offset(2)
            make.centerY.equalTo(textLb)
        }
    }
}
