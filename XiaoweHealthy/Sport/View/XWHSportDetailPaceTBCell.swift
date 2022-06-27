//
//  XWHSportDetailPaceTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/27.
//

import UIKit

class XWHSportDetailPaceTBCell: XWHBaseTBCell {
    
    lazy var distanceTitleLb = UILabel()
    lazy var paceTitleLb = UILabel()
    lazy var averagePaceLb = UILabel()
    
    lazy var progressView = XWHLinearProgressView()
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(distanceTitleLb)
        contentView.addSubview(paceTitleLb)
        contentView.addSubview(averagePaceLb)
        
        contentView.addSubview(progressView)
        
        iconView.image = R.image.sport_pace_icon()
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        titleLb.textColor = fontDarkColor
        
        titleLb.text = "平均配速"
        
        distanceTitleLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
        paceTitleLb.font = distanceTitleLb.font
        averagePaceLb.font = distanceTitleLb.font
        
        distanceTitleLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        paceTitleLb.textColor = distanceTitleLb.textColor
        averagePaceLb.textColor = fontDarkColor
        
        distanceTitleLb.textAlignment = .center
        paceTitleLb.textAlignment = .left
        averagePaceLb.textAlignment = .right
        
        distanceTitleLb.text = "公里"
        paceTitleLb.text = "配速(/km)"
    }
    
    override func relayoutSubViews() {
        iconView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.size.equalTo(32)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(iconView)
            make.height.equalTo(23)
        }
        
        distanceTitleLb.snp.makeConstraints { make in
            make.left.equalTo(iconView)
            make.width.lessThanOrEqualTo(30)
            make.top.equalTo(iconView.snp.bottom).offset(12)
            make.height.equalTo(20)
        }
        
        paceTitleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(62)
            make.width.lessThanOrEqualTo(80)
            make.centerY.height.equalTo(distanceTitleLb)
        }
        
        averagePaceLb.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(paceTitleLb.snp.right).offset(2)
            make.centerY.height.equalTo(paceTitleLb)
        }
        
        progressView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(distanceTitleLb.snp.bottom).offset(5)
            make.height.equalTo(34)
        }
    }
    
    func update() {
        averagePaceLb.text = "平均配速：6’23”"
        
//        progressView.progressView.progressValue = 60
        progressView.update(value: 60)
    }

}
