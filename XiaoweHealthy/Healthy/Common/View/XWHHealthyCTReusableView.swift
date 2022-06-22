//
//  XWHHealthyCTReusableView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/21.
//

import UIKit

class XWHHealthyCTReusableView: XWHBaseCTReusableView {
        
    override func addSubViews() {
        super.addSubViews()
    }
    
    @objc func setDetailButton(title: String) {
        let btnFontColor = fontDarkColor.withAlphaComponent(0.3)
        button.setTitleColor(btnFontColor, for: .normal)

        let image = UIImage.iconFont(text: XWHIconFontOcticons.infoBg.rawValue, size: 18, color: btnFontColor)
        button.set(image: image, title: title, titlePosition: .left, additionalSpacing: 2, state: .normal)
    }
    
}
