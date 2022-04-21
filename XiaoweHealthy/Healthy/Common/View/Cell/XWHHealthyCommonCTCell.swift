//
//  XWHHealthyCommonCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/20.
//

import UIKit

class XWHHealthyCommonCTCell: XWHCommonBaseCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.layer.cornerRadius = 12
        contentView.layer.backgroundColor = healthContentBgColor.cgColor
        
        contentView.addSubview(imageView)
        imageView.isHidden = true
    }
    
    override func relayoutSubViews() {
        relayoutTextLeftRight()
    }
    
    @objc func relayoutTextLeftRight() {
        textLb.textAlignment = .left
        detailLb.textAlignment = .right
        
        textLb.snp.remakeConstraints { make in
            make.height.equalTo(19)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(126)
        }
        
        detailLb.snp.remakeConstraints { make in
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(textLb.snp.right).offset(6)
        }
    }
    
//    @objc func relayoutTextUpDown() {
//        textLb.textAlignment = .left
//        detailLb.textAlignment = .left
//        
//        textLb.snp.remakeConstraints { make in
//            make.height.equalTo(19)
//            make.left.top.right.equalToSuperview().offset(16)
//        }
//        
//        detailLb.snp.remakeConstraints { make in
//            make.left.right.equalTo(textLb)
//            make.top.equalTo(textLb.snp.bottom).offset(4)
//            make.height.equalTo(16)
//        }
//    }
    
}
