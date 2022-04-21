//
//  XWHCommonBaseCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/20.
//

import UIKit

class XWHCommonBaseCTCell: XWHBaseCTCell {
    
    lazy var detailLb = UILabel()

    override func addSubViews() {
        super.addSubViews()
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        contentView.addSubview(textLb)
        
        detailLb.textColor = fontDarkColor
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 24, weight: .bold)
        contentView.addSubview(detailLb)
    }
    
    override func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.height.equalTo(19)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalTo(126)
        }
        
        detailLb.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(textLb.snp.right).offset(6)
        }
    }
    
}
