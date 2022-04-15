//
//  XWHDialCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit

class XWHDialCTCell: XWHBaseCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        
        contentView.addSubview(textLb)
        
        contentView.addSubview(imageView)
    }
    
    override func relayoutSubViews() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.size.equalTo(90)
            make.centerX.equalToSuperview()
        }
        textLb.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.height.equalTo(16)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
    }
    
}
