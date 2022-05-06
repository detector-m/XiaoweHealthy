//
//  XWHSleepCommonCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHSleepCommonCTCell: XWHHealthyCommonCTCell {
    
    lazy var tipLb = UILabel()
    
    override func addSubViews() {
        super.addSubViews()

        tipLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        tipLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        tipLb.textAlignment = .left
        contentView.addSubview(tipLb)
        
        imageView.isHidden = false
        
        imageView.layer.cornerRadius = 4
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12)
    }
    
    override func relayoutSubViews() {
        textLb.textAlignment = .left
        detailLb.textAlignment = .right
        
        textLb.snp.remakeConstraints { make in
            make.height.equalTo(27)
            make.top.equalTo(16)
            make.left.equalToSuperview().offset(13)
            make.width.lessThanOrEqualTo(120)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(10)
            make.left.equalTo(textLb)
            make.top.equalTo(textLb.snp.bottom).offset(5)
        }
        
        tipLb.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(3)
            make.right.equalTo(textLb)
            make.top.equalTo(textLb.snp.bottom).offset(2)
            make.height.equalTo(16)
        }
        
        detailLb.snp.remakeConstraints { make in
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(textLb.snp.right).offset(6)
        }
    }
    
    func update(_ title: String, _ value: String, _ tip: String, _ tipColor: UIColor) {
        textLb.text = value
        detailLb.text = title
        tipLb.text = tip
        imageView.layer.backgroundColor = tipColor.cgColor
    }
    
}
