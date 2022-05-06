//
//  XWHHealthyGradientCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/21.
//

import UIKit
import SwifterSwift

class XWHHealthyGradientCTCell: XWHHealthyCommonCTCell {
    
    lazy var tipLb = UILabel()
    lazy var gradientColors: [UIColor] = [UIColor(hex: 0xFFE0E2)!, UIColor(hex: 0xFFFFFF)!] {
        didSet {
            gradientLayer.colors = gradientColors.map({ $0.cgColor })
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors.map({ $0.cgColor })
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1)
        gradientLayer.type = .axial
        gradientLayer.cornerRadius = 12
        return gradientLayer
    }()
    
    override func addSubViews() {
        super.addSubViews()
    
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
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
