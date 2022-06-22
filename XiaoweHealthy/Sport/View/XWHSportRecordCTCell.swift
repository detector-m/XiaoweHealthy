//
//  XWHSportRecordCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/22.
//

import UIKit

class XWHSportRecordCTCell: XWHCommonBaseCTCell {
    
    lazy var subImageView = UIImageView()
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(subImageView)
        contentView.addSubview(imageView)
        
        layer.cornerRadius = 16
        layer.backgroundColor = UIColor.white.cgColor
        
//        subImageView.layer.cornerRadius = 22
        subImageView.image = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 22, color: fontDarkColor.withAlphaComponent(0.2))
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 17, weight: .bold)
        
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
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
    }
    
    func update() {
        imageView.image = R.image.sport_climb()
        textLb.text = R.string.xwhSportText.爬山()
        detailLb.text = Date().localizedString(withFormat: XWHDate.YearMonthDayHourMinuteFormat)
    }
    
}
