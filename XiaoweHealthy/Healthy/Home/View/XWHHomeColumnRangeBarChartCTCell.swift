//
//  XWHHomeColumnRangeBarChartCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/13.
//

import UIKit

class XWHHomeColumnRangeBarChartCTCell: XWHColumnRangeBarChartBaseCTCell {
    
    lazy var emptyChartView = UIView()
    lazy var emptyBLb = UILabel()
    lazy var emptyELb = UILabel()
    
    override func addSubViews() {
        super.addSubViews()
        
        gradientColors = [UIColor.clear, UIColor.clear]
        
        contentView.addSubview(imageView)
        
        contentView.addSubview(emptyChartView)
        contentView.addSubview(emptyBLb)
        contentView.addSubview(emptyELb)

        layer.cornerRadius = 16
        layer.backgroundColor = contentBgColor.cgColor
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        
        imageView.layer.cornerRadius = 16
        imageView.layer.backgroundColor = fontDarkColor.withAlphaComponent(0.4).cgColor
        imageView.contentMode = .center
//        imageView.image = R.image.moodIcon()
        
        emptyChartView.layer.cornerRadius = 8

        emptyBLb.font = XWHFont.harmonyOSSans(ofSize: 10, weight: .regular)
        emptyBLb.textColor = fontDarkColor.withAlphaComponent(0.25)
        emptyBLb.textAlignment = .left
        
        emptyELb.font = emptyBLb.font
        emptyELb.textColor = emptyBLb.textColor
        emptyELb.textAlignment = .right
        
        showEmptyView()
    }
    
    override func relayoutSubViews() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(32)
            make.left.top.equalTo(16)
        }
        
        textLb.snp.makeConstraints { make in
            make.left.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.height.equalTo(22)
        }
        
        detailLb.snp.makeConstraints { make in
            make.left.right.equalTo(textLb)
            make.height.equalTo(16)
            make.top.equalTo(textLb.snp.bottom).offset(4)
        }
        
        emptyChartView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.top.equalTo(detailLb.snp.bottom).offset(24)
        }
        
        emptyBLb.snp.makeConstraints { make in
            make.left.equalTo(emptyChartView)
            make.right.equalTo(contentView.snp.centerX).offset(-1)
            make.height.equalTo(14)
            make.top.equalTo(emptyChartView.snp.bottom).offset(4)
        }
        
        emptyELb.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).offset(2)
            make.right.equalTo(emptyChartView)
            make.height.top.equalTo(emptyBLb)
        }
    }
    
    
    func showEmptyView() {
        detailLb.text = R.string.xwhHealthyText.暂无数据()
        
        emptyChartView.isHidden = false
        emptyBLb.isHidden = false
        emptyBLb.isHidden = false
        
        emptyBLb.text = "00:00"
        emptyELb.text = "12:00"
    }
    
    func hideEmptyView() {
        emptyChartView.isHidden = true
        emptyBLb.isHidden = true
        emptyBLb.isHidden = true
    }
    
}
