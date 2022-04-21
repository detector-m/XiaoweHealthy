//
//  XWHHeartRangeCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/21.
//

import UIKit

class XWHHeartRangeCTCell: XWHHeartCommonCTCell {
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(imageView)
        
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
    
    func update(_ index: Int, _ value: String) {
        var cValue = value
        if cValue.isEmpty {
            cValue = "--"
        }
        cValue += " "
        
        var cColor = UIColor.white
        
        switch index {
        case 0:
            cColor = UIColor(hex: 0x49CE64)!
            detailLb.text = R.string.xwhHealthyText.燃脂心率()
            
        case 1:
            cColor = UIColor(hex: 0x76D4EA)!
            detailLb.text = R.string.xwhHealthyText.减压心率()
            
        case 2:
            cColor = UIColor(hex: 0xF0B36D)!
            detailLb.text = R.string.xwhHealthyText.无氧心率()
            
        case 3:
            cColor = UIColor(hex: 0xED7135)!
            detailLb.text = R.string.xwhHealthyText.心肺心率()

            
        default:
            cColor = UIColor(hex: 0xEB5763)!
            detailLb.text = R.string.xwhHealthyText.极限心率()

        }
        
        let unit = R.string.xwhDeviceText.次分钟()
        let cText = cValue + unit
        imageView.layer.backgroundColor = cColor.cgColor
        textLb.attributedText = cText.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)], toOccurrencesOf: cValue).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 12)], toOccurrencesOf: unit)
    }
    
}
