//
//  XWHMoodRangeCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/27.
//

import UIKit

class XWHMoodRangeCTCell: XWHHealthyCommonCTCell {
    
    lazy var tipLb = UILabel()
    
    override func addSubViews() {
        super.addSubViews()
        
        tipLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        tipLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        tipLb.textAlignment = .right
        contentView.addSubview(tipLb)
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.3)
        
        imageView.isHidden = false
        imageView.layer.cornerRadius = 4
    }
    
    override func relayoutSubViews() {
        textLb.textAlignment = .left
        detailLb.textAlignment = .left
        
        textLb.snp.remakeConstraints { make in
            make.height.equalTo(27)
            make.top.equalTo(16)
            make.left.equalToSuperview().offset(13)
            make.right.lessThanOrEqualTo(tipLb.snp.left).offset(-4)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(10)
            make.left.equalTo(textLb)
            make.top.equalTo(textLb.snp.bottom).offset(5)
        }
        
        detailLb.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(3)
            make.right.equalTo(textLb)
            make.top.equalTo(textLb.snp.bottom).offset(2)
            make.height.equalTo(16)
        }
        
        tipLb.snp.remakeConstraints { make in
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(120)
        }
    }
    
    func update(_ index: Int, _ value: Int, _ rate: Int) {
        let cValue = XWHUIDisplayHandler.getSleepDurationString(value)
        var cRate = ""
        
        var cColor = UIColor.white
        let colors = XWHUIDisplayHandler.getMoodRangeColors()
        if !colors.isEmpty, index < colors.count {
            cColor = colors[index]
        }
        
        if rate != 0 {
            cRate = rate.string
        }
        
        if cRate.isEmpty {
            cRate = "--"
        } else {
            cRate += "%"
        }
        
        imageView.layer.backgroundColor = cColor.cgColor
        textLb.text = cValue
        
        detailLb.text = XWHUIDisplayHandler.getMoodDurationTitles()[index]
        
        let unit = XWHUIDisplayHandler.getMoodRangeStrings()[index]
        tipLb.text = cRate + " " + unit
    }
    
}
