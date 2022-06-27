//
//  XWHSportDetailSummaryTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/27.
//

import UIKit

class XWHSportDetailSummaryTBCell: XWHSRLSportRecordSummaryTBCell {
    
    lazy var titleLb = UILabel()
    lazy var valueLb = UILabel()
    lazy var timeLb = UILabel()
    
    lazy var avatar = UIImageView()
    lazy var nicknameLb = UILabel()
    
    private(set) lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors.map({ $0.cgColor })
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.type = .axial
        gradientLayer.cornerRadius = 12
        return gradientLayer
    }()
    
    lazy var gradientColors: [UIColor] = [UIColor(hex: 0x2DC84D)!, UIColor(hex: 0xFFCA4F)!] {
        didSet {
            gradientLayer.colors = gradientColors.map({ $0.cgColor })
        }
    }
    
    lazy var titleValueView4 = XWHTitleValueView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = CGRect(x: 0, y: 116, width: width, height: 3)
    }
    
    override func getCurrentFrame(_ frame: CGRect) -> CGRect {
        return frame
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(titleLb)
        contentView.addSubview(valueLb)
        contentView.addSubview(timeLb)
        
        contentView.addSubview(avatar)
        contentView.addSubview(nicknameLb)
        
        gradientLayer.cornerRadius = 0
        contentView.layer.addSublayer(gradientLayer)
        contentView.addSubview(titleValueView4)
        
        avatar.layer.cornerRadius = 27
        avatar.layer.masksToBounds = true
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .bold)
        titleLb.textColor = fontDarkColor
        
        timeLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
        timeLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        
        nicknameLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)
        nicknameLb.textAlignment = .right
        nicknameLb.textColor = fontDarkColor
        
        config(titleValueView: titleValueView1)
        config(titleValueView: titleValueView2)
        config(titleValueView: titleValueView3)
        config(titleValueView: titleValueView4)

        titleValueView1.titleLb.text = "总计时长"
        titleValueView2.titleLb.text = "消耗热量"
        titleValueView3.titleLb.text = "跑步心率"
        titleValueView4.titleLb.text = "平均配速"
    }
    
    override func relayoutSubViews() {
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-13)
            make.size.equalTo(54)
            make.right.equalToSuperview().inset(14)
        }
        
        nicknameLb.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(1)
            make.height.equalTo(20)
            make.right.equalTo(avatar)
            make.width.lessThanOrEqualTo(100)
        }
        
        timeLb.snp.makeConstraints { make in
            make.top.equalTo(nicknameLb.snp.bottom).offset(4)
            make.height.equalTo(20)
            make.right.equalTo(nicknameLb)
            make.width.lessThanOrEqualTo(160)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(120)
            make.top.equalTo(18)
            make.height.equalTo(20)
        }
        
        valueLb.snp.makeConstraints { make in
            make.left.equalTo(titleLb)
            make.right.equalTo(timeLb.snp.left).offset(-2)
            make.top.equalTo(titleLb.snp.bottom)
            make.height.equalTo(56)
        }
        
        titleValueView1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(126 + 9)
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.5).offset(-20)
            make.height.equalTo(64)
        }
        
        vSeparateLine1.snp.makeConstraints { make in
            make.left.equalTo(titleValueView1.snp.right)
            make.centerY.equalTo(titleValueView1)
            make.width.equalTo(0.5)
            make.height.equalTo(32)
        }
        
        titleValueView2.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.width.height.equalTo(titleValueView1)
        }
        
        hSeparateLine1.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(0.5)
            make.top.equalTo(titleValueView1.snp.bottom).offset(9)
        }
        
        titleValueView3.snp.makeConstraints { make in
            make.left.height.width.equalTo(titleValueView1)
            make.top.equalTo(hSeparateLine1.snp.bottom).offset(9)
        }
        
        vSeparateLine2.snp.makeConstraints { make in
            make.left.equalTo(titleValueView3.snp.right)
            make.centerY.equalTo(titleValueView3)
            make.width.equalTo(0.5)
            make.height.equalTo(32)
        }
        
        titleValueView4.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.width.height.equalTo(titleValueView3)
        }
    }
    
    override func update() {
        titleLb.text = "小维健康·跑步"
        
        let value = "12.98"
        let unit = " 公里"
        let text = value + unit
        valueLb.attributedText = text.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 40, weight: .bold)], toOccurrencesOf: value).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)], toOccurrencesOf: unit)
        
        avatar.image = R.image.sport_avatar()
        
        nicknameLb.text = "xxxx"
        
        timeLb.text = Date().localizedString(withFormat: XWHDate.yearMonthDayHourMinuteFormat)
        
        titleValueView1.valueLb.text = "00:00:45"
        titleValueView2.valueLb.text = "100"
        titleValueView3.valueLb.text = "122"
        titleValueView4.valueLb.text = "8'88\""
    }
    
}

extension XWHSportDetailSummaryTBCell {
    
    override func config(titleValueView: XWHTitleValueView) {
        titleValueView.type = .valueUp
        
        titleValueView.titleLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        titleValueView.titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)

        titleValueView.valueLb.font = XWHFont.harmonyOSSans(ofSize: 23, weight: .bold)
        titleValueView.valueLb.textColor = fontDarkColor
    }
    
}
