//
//  XWHSportRecordCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/22.
//

import UIKit

class XWHSportRecordCTCell: XWHCommonBaseCTCell {
    
    lazy var subImageView = UIImageView()
    
    lazy var titleValueView1 = XWHTitleValueView()
    lazy var titleValueView2 = XWHTitleValueView()
    lazy var titleValueView3 = XWHTitleValueView()
    lazy var titleValueView4 = XWHTitleValueView()
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(subImageView)
        contentView.addSubview(imageView)
        
        contentView.addSubview(titleValueView1)
        contentView.addSubview(titleValueView2)
        contentView.addSubview(titleValueView3)
        contentView.addSubview(titleValueView4)
        
        layer.cornerRadius = 16
        layer.backgroundColor = UIColor.white.cgColor
        
//        subImageView.layer.cornerRadius = 22
        subImageView.image = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 22, color: fontDarkColor.withAlphaComponent(0.2))
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 17, weight: .bold)
        
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
        
        titleValueView1.type = .valueUp
        titleValueView2.type = .valueUp
        titleValueView3.type = .valueUp
        titleValueView4.type = .valueUp
    }
    
    override func relayoutSubViews() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.top.left.equalToSuperview().inset(16)
        }
        
        subImageView.snp.makeConstraints { make in
            make.size.equalTo(22)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(imageView)
        }
        
        textLb.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(21)
            make.left.equalTo(imageView.snp.right).offset(12)
            make.right.equalTo(subImageView.snp.left).offset(-12)
        }
        
        detailLb.snp.makeConstraints { make in
            make.top.equalTo(textLb.snp.bottom).offset(2)
            make.height.equalTo(21)
            make.left.right.equalTo(textLb)
        }
        
        titleValueView1.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.25)
            make.bottom.equalToSuperview().inset(6)
            make.height.equalTo(64)
        }
        
        titleValueView2.snp.makeConstraints { make in
            make.left.equalTo(titleValueView1.snp.right)
            make.width.height.centerY.equalTo(titleValueView1)
        }
        
        titleValueView3.snp.makeConstraints { make in
            make.left.equalTo(titleValueView2.snp.right)
            make.width.height.centerY.equalTo(titleValueView1)
        }
        
        titleValueView4.snp.makeConstraints { make in
            make.left.equalTo(titleValueView3.snp.right)
            make.width.height.centerY.equalTo(titleValueView1)
        }
    }
    
    func update() {
        imageView.image = R.image.sport_climb()
        textLb.text = R.string.xwhSportText.爬山()
        detailLb.text = Date().localizedString(withFormat: XWHDate.yearMonthDayHourMinuteFormat)
        
        titleValueView1.titleLb.text = "公里"
        titleValueView1.valueLb.text = "--"
        
        titleValueView2.titleLb.text = "时长(分)"
        titleValueView2.valueLb.text = "--"
        
        titleValueView3.titleLb.text = "千卡"
        titleValueView3.valueLb.text = "--"
        
        titleValueView4.titleLb.text = "心率"
        titleValueView4.valueLb.text = "--"
    }
    
}
