//
//  XWHHealthyGradientCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/21.
//

import UIKit
import SwifterSwift

class XWHHealthyGradientCTCell: XWHHealthyGradientBaseCTCell {
    
    lazy var tipLb = UILabel()
    
    override func addSubViews() {
        super.addSubViews()
            
        tipLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        tipLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        tipLb.textAlignment = .left
        contentView.addSubview(tipLb)
    }
    
    override func relayoutSubViews() {
        textLb.textAlignment = .left
        detailLb.textAlignment = .right
        
        textLb.snp.remakeConstraints { make in
            make.height.equalTo(19)
            make.top.equalTo(16)
            make.left.equalToSuperview().offset(16)
            make.width.equalTo(126)
        }
        
        tipLb.snp.makeConstraints { make in
            make.left.right.equalTo(textLb)
            make.top.equalTo(textLb.snp.bottom).offset(4)
            make.height.equalTo(16)
        }
        
        detailLb.snp.remakeConstraints { make in
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(textLb.snp.right).offset(6)
        }
    }
    
    @objc func update(_ title: String, _ value: String, _ tipText: String) {
        textLb.text = title
        detailLb.text = value
        tipLb.text = tipText
    }
    
    @objc func update(_ title: String, _ value: String, _ unit: String, _ tipText: String) {
        textLb.text = title
        tipLb.text = tipText
        
        let cValue = value + " "
        let cText = cValue + unit
        
        detailLb.attributedText = cText.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 24, weight: .bold)], toOccurrencesOf: cValue).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 12)], toOccurrencesOf: unit)
    }
    
}
