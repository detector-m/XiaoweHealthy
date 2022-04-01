//
//  XWHDevSetUpdateHeaderView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/1.
//

import UIKit

class XWHDevSetUpdateHeaderView: XWHTBHeaderFooterBaseView {
    
    lazy var iconView = UIImageView()

    override func addSubViews() {
        super.addSubViews()
        
        iconView.image = UIImage.iconFont(text: XWHIconFontOcticons.update.rawValue, size: 80, color: btnBgColor)
        contentView.addSubview(iconView)
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        titleLb.textColor = fontDarkColor
        titleLb.numberOfLines = 0
        titleLb.textAlignment = .center
        
        titleLb.text = "V1.3.606 \n发现新版本"
    }
    
    override func relayoutSubViews() {
        iconView.snp.makeConstraints { make in
            make.size.equalTo(80)
            make.top.equalTo(0)
            make.centerX.equalToSuperview()
        }
        
        titleLb.snp.makeConstraints { make in
            make.top.equalTo(iconView.snp.bottom).offset(6)
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(48)
        }
    }

}
