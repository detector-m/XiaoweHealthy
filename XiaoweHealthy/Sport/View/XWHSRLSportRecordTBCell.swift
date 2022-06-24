//
//  XWHSRLSportRecordTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/9.
//

import UIKit


/// 运动记录列表运动记录 cell
class XWHSRLSportRecordTBCell: XWHCommonBaseTBCell {
    
    lazy var sportTimeIcon = UIImageView()
    lazy var sportTimeLb = UILabel()
    
    lazy var paceIcon = UIImageView()
    lazy var paceLb = UILabel()
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(sportTimeIcon)
        contentView.addSubview(sportTimeLb)
        contentView.addSubview(paceIcon)
        contentView.addSubview(paceLb)
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 9, weight: .regular)
        
        subTitleLb.textAlignment = .left
        
        sportTimeLb.textColor = fontDarkColor.withAlphaComponent(0.6)
        paceLb.textColor = fontDarkColor.withAlphaComponent(0.6)
        paceLb.font = XWHFont.harmonyOSSans(ofSize: 9)
        sportTimeLb.font = paceLb.font
        
        sportTimeIcon.image = R.image.duration_icon()
        paceIcon.image = R.image.pace_icon()
        
        subIconView.image = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 22, color: fontDarkColor.withAlphaComponent(0.2))
    }
    
    override func relayoutSubViews() {
        iconView.snp.makeConstraints { make in
            make.size.equalTo(54)
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
        subIconView.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(10)
            make.right.lessThanOrEqualTo(subIconView.snp.left).offset(-6)
            make.top.equalToSuperview().offset(8)
            make.height.equalTo(13)
        }
        
        subTitleLb.snp.makeConstraints { make in
            make.left.right.equalTo(titleLb)
            make.top.equalTo(titleLb.snp.bottom)
            make.height.equalTo(28)
        }
        
        sportTimeIcon.snp.makeConstraints { make in
            make.size.equalTo(8)
            make.left.equalTo(titleLb)
            make.top.equalTo(subTitleLb.snp.bottom).offset(2)
        }
        sportTimeLb.snp.makeConstraints { make in
            make.left.equalTo(sportTimeIcon.snp.right).offset(2)
            make.centerY.equalTo(sportTimeIcon)
            make.height.equalTo(13)
            make.width.lessThanOrEqualTo(60)
        }
        
        paceIcon.snp.makeConstraints { make in
            make.size.centerY.equalTo(sportTimeIcon)
            make.left.equalTo(sportTimeLb.snp.right).offset(9)
        }
        
        paceLb.snp.makeConstraints { make in
            make.left.equalTo(paceIcon.snp.right).offset(2)
            make.centerY.height.equalTo(sportTimeLb)
            make.right.equalTo(titleLb)
        }
    }
    
    func update() {
        titleLb.text = "今天  跑步"
        let value = "0.90"
        let unit = " 公里"
        let text = value + unit
        subTitleLb.attributedText = text.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)], toOccurrencesOf: value).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 10)], toOccurrencesOf: unit)
        
        iconView.image = R.image.sport_run()
        
        sportTimeLb.text = "00:03:23"
        paceLb.text = "23'34\""
    }

}
