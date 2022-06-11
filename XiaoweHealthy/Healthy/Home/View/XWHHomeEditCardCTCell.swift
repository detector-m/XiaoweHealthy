//
//  XWHHomeEditCardCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/11.
//

import UIKit

class XWHHomeEditCardCTCell: XWHBaseCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        layer.cornerRadius = 24
        layer.backgroundColor = UIColor.white.cgColor
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        textLb.textAlignment = .center
        
        textLb.text = R.string.xwhHealthyText.编辑健康卡片()

        contentView.addSubview(textLb)
    }
    
    override func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
    
}
