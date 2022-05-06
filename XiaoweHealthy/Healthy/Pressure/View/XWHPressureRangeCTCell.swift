//
//  XWHPressureRangeCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit

class XWHPressureRangeCTCell: XWHPressureCommonCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.3)
        
        imageView.isHidden = false
        imageView.cornerRadius = 4
    }
    
    override func relayoutSubViews() {
        textLb.textAlignment = .left
        detailLb.textAlignment = .left
        
        textLb.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.height.equalTo(27)
            make.left.right.equalToSuperview().offset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(10)
            make.left.equalTo(textLb)
            make.top.equalTo(textLb.snp.bottom).offset(5)
        }
        
        detailLb.snp.remakeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(3)
            make.right.equalTo(textLb)
            make.centerY.equalTo(imageView)
            make.height.equalTo(16)
        }
    }
    
    func update(_ index: Int, _ rate: Int) {
        var cValue = ""
        
        var cColor = UIColor.white
        let colors = XWHHealthyHelper.getPressureRangeColors()
        if !colors.isEmpty, index < colors.count {
            cColor = colors[index]
        }
        
        if rate != 0 {
            cValue = rate.string
        }
        
        if cValue.isEmpty {
            cValue = "--"
        } else {
            cValue += "%"
        }
        
        imageView.layer.backgroundColor = cColor.cgColor
        textLb.text = cValue
        
//        let unit = ""
//        let cText = cValue + unit
//        imageView.layer.backgroundColor = cColor.cgColor
//        textLb.attributedText = cText.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)], toOccurrencesOf: cValue).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 12)], toOccurrencesOf: unit)
    }
    
}
