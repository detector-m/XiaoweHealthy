//
//  XWHSRLSportRecordSummaryTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/24.
//

import UIKit

class XWHSRLSportRecordSummaryTBCell: UITableViewCell {
    
    lazy var topLine = UIView()
    
    lazy var separateLine1 = UIView()
    lazy var separateLine2 = UIView()
    
    lazy var titleValueView1 = XWHTitleValueView()
    lazy var titleValueView2 = XWHTitleValueView()
    lazy var titleValueView3 = XWHTitleValueView()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addSubViews() {
        contentView.addSubview(topLine)
        
        contentView.addSubview(separateLine1)
        contentView.addSubview(separateLine2)
        
        contentView.addSubview(titleValueView1)
        contentView.addSubview(titleValueView2)
        contentView.addSubview(titleValueView3)
        
        topLine.backgroundColor = UIColor(hex: 0x979797).withAlphaComponent(0.2)
        separateLine1.backgroundColor = UIColor(hex: 0x979797).withAlphaComponent(0.2)
        separateLine2.backgroundColor = UIColor(hex: 0x979797).withAlphaComponent(0.2)

        titleValueView1.type = .titleUp
        titleValueView2.type = .titleUp
        titleValueView3.type = .titleUp
        
        titleValueView1.titleLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        titleValueView2.titleLb.font = titleValueView1.titleLb.font
        titleValueView3.titleLb.font = titleValueView1.titleLb.font

        titleValueView1.titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        titleValueView2.titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        titleValueView3.titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)

        
        titleValueView1.valueLb.font = XWHFont.harmonyOSSans(ofSize: 17, weight: .bold)
        titleValueView2.valueLb.font = titleValueView1.valueLb.font
        titleValueView3.valueLb.font = titleValueView1.valueLb.font
        
        titleValueView1.valueLb.textColor = fontDarkColor
        titleValueView2.valueLb.textColor = fontDarkColor
        titleValueView3.valueLb.textColor = fontDarkColor

        titleValueView1.titleLb.text = "运动(公里)"
        titleValueView2.titleLb.text = "热量(千卡)"
        titleValueView3.titleLb.text = "运动(次数)"
    }
    
    func relayoutSubViews() {
        topLine.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        titleValueView1.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.33)
            make.height.equalTo(64)
            make.centerY.equalToSuperview()
        }
        
        separateLine1.snp.makeConstraints { make in
            make.left.equalTo(titleValueView1.snp.right)
            make.centerY.equalTo(titleValueView1)
            make.width.equalTo(0.5)
            make.height.equalTo(32)
        }
        
        titleValueView2.snp.makeConstraints { make in
            make.left.equalTo(separateLine1.snp.right)
            make.width.height.centerY.equalTo(titleValueView1)
        }
        
        separateLine2.snp.makeConstraints { make in
            make.left.equalTo(titleValueView2.snp.right)
            make.centerY.equalTo(titleValueView1)
            make.width.equalTo(0.5)
            make.height.equalTo(32)
        }
        
        titleValueView3.snp.makeConstraints { make in
            make.left.equalTo(separateLine2.snp.right)
            make.width.height.centerY.equalTo(titleValueView1)
        }
        
    }
    
    func update() {
        titleValueView1.valueLb.text = "20.12"
        titleValueView2.valueLb.text = "120"
        titleValueView3.valueLb.text = "2"
    }

}
