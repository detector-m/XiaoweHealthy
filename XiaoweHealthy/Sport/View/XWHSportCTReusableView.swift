//
//  XWHSportCTReusableView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/22.
//

import UIKit

class XWHSportCTReusableView: XWHBaseCTReusableView {
        
    override func addSubViews() {
        super.addSubViews()
        
        let image = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 18, color: fontDarkColor.withAlphaComponent(0.2))
        button.setImage(image, for: .normal)
        
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .right
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 17, weight: .medium)
        textLb.textColor = fontDarkColor
    }
    
    override func relayoutSubViews() {
        button.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            
//            make.size.equalTo(18)
            make.width.equalTo(100)
            make.height.equalTo(40)
            make.right.equalToSuperview()
        }
        textLb.snp.remakeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.lessThanOrEqualTo(button.snp.left).offset(-10)
        }
    }
    
}
