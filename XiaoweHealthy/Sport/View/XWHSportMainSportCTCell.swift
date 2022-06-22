//
//  XWHSportMainSportCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/22.
//

import UIKit

class XWHSportMainSportCTCell: XWHCommonBaseCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(imageView)
        
        layer.cornerRadius = 16
        layer.backgroundColor = UIColor.white.cgColor
        
        imageView.layer.cornerRadius = 16
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 17, weight: .medium)
        
        detailLb.textColor = fontDarkColor
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .medium)
        detailLb.textAlignment = .center
        
        detailLb.layer.cornerRadius = 13.5
        detailLb.text = "GO"
    }
    
    override func relayoutSubViews() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.left.equalToSuperview().inset(16)
        }
        
        detailLb.snp.makeConstraints { make in
            make.size.equalTo(27)
            make.centerY.equalTo(imageView)
            make.right.equalToSuperview().inset(16)
        }
        
        textLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(24)
        }
    }
    
}
