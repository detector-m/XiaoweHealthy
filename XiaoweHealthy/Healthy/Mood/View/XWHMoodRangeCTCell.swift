//
//  XWHMoodRangeCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/27.
//

import UIKit

class XWHMoodRangeCTCell: XWHHealthyCommonCTCell {
    
//    lazy var tipLb = UILabel()
    
    override func addSubViews() {
        super.addSubViews()
        
//        tipLb.font = XWHFont.harmonyOSSans(ofSize: 12)
//        tipLb.textColor = fontDarkColor.withAlphaComponent(0.5)
//        tipLb.textAlignment = .right
//        contentView.addSubview(tipLb)
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
        textLb.textColor = fontDarkColor.withAlphaComponent(0.5)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)
        detailLb.textColor = fontDarkColor
        
        imageView.isHidden = false
        imageView.layer.cornerRadius = 4
    }
    
    override func relayoutSubViews() {
        textLb.textAlignment = .left
        detailLb.textAlignment = .left
        
        detailLb.snp.remakeConstraints { make in
            make.height.equalTo(32)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(120)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(10)
            make.left.equalToSuperview().inset(16)
//            make.top.equalTo(textLb.snp.bottom).offset(5)
            make.centerY.equalToSuperview()
        }
        
        textLb.snp.remakeConstraints { make in
            make.height.equalTo(19)
            make.centerY.equalToSuperview()
            make.left.equalTo(imageView.snp.right).offset(4)
            make.right.lessThanOrEqualTo(detailLb.snp.left).offset(-4)
        }
        
//        tipLb.snp.remakeConstraints { make in
//            make.height.equalTo(32)
//            make.centerY.equalToSuperview()
//            make.right.equalToSuperview().inset(16)
//            make.width.lessThanOrEqualTo(120)
//        }
    }
    
    func update(_ index: Int, _ rate: Int) {
//        let cValue = XWHUIDisplayHandler.getSleepDurationString(value)
        var cRate = ""
        
        var cColor = UIColor.white
        let colors = XWHUIDisplayHandler.getMoodRangeColors()
        if !colors.isEmpty, index < colors.count {
            cColor = colors[index]
        }
        
        if rate != 0 {
            cRate = rate.string
        }
        
//        if cRate.isEmpty {
//            cRate = "--"
//        } else {
//            cRate += "%"
//        }
        
        cRate = rate.string
        cRate += "%"
        
        imageView.layer.backgroundColor = cColor.cgColor
        textLb.text = XWHUIDisplayHandler.getMoodDurationTitles()[index]
        
        detailLb.text = cRate
    }
    
}
