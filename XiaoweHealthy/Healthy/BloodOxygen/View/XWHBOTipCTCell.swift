//
//  XWHBOTipCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/21.
//

import UIKit

class XWHBOTipCTCell: XWHBOCommonCTCell {
    
    lazy var tipLb = UILabel()
    lazy var legendImageView = UIImageView()
    
    override func addSubViews() {
        super.addSubViews()
                
        let cFont = XWHFont.harmonyOSSans(ofSize: 14)
        tipLb.font = cFont
        tipLb.textColor = fontDarkColor.withAlphaComponent(0.35)
        tipLb.textAlignment = .left
        tipLb.numberOfLines = 0
        tipLb.adjustsFontSizeToFitWidth = true
        contentView.addSubview(tipLb)
        
        contentView.addSubview(legendImageView)
        
        let radius: CGFloat = 4
        imageView.isHidden = false
        imageView.layer.cornerRadius = radius
        imageView.layer.backgroundColor = UIColor(hex: 0x6CD267)?.cgColor
        
        legendImageView.layer.cornerRadius = radius
        legendImageView.layer.backgroundColor = UIColor(hex: 0xF0B36D)?.cgColor
        
        textLb.font = cFont
        textLb.textColor = fontDarkColor
        detailLb.font = cFont
        detailLb.textColor = fontDarkColor
        
        update()
    }
    
    override func relayoutSubViews() {
        tipLb.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(16)
            make.height.equalTo(64)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(10)
            make.top.equalTo(tipLb.snp.bottom).offset(16)
            make.left.equalTo(tipLb)
        }
        textLb.snp.makeConstraints { make in
            make.centerY.equalTo(imageView)
            make.height.equalTo(19)
            make.left.equalTo(imageView.snp.right).offset(4)
            make.right.equalTo(tipLb)
        }
        
        legendImageView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.left.size.equalTo(imageView)
        }
        detailLb.snp.makeConstraints { make in
            make.top.left.right.equalTo(textLb)
            make.centerY.equalTo(legendImageView)
        }
    }
    
    func update() {
        tipLb.text = R.string.xwhHealthyText.血氧饱和度是身体健康的重要指标之一正常人的血氧水平介于90100之间低于90就进入了低血氧范围()
        textLb.text = R.string.xwhHealthyText.正常血氧90()
        detailLb.text = R.string.xwhHealthyText.低血氧7089()
    }
    
}
