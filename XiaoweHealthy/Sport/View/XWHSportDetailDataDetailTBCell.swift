//
//  XWHSportDetailDataDetailTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/27.
//

import UIKit

class XWHSportDetailDataDetailTBCell: XWHSRLSportRecordSummaryTBCell {
    
    lazy var iconView = UIImageView()
    
    lazy var titleLb = UILabel()
    lazy var valueLb = UILabel()
    
    lazy var titleValueView4 = XWHTitleValueView()
    lazy var titleValueView5 = XWHTitleValueView()
    lazy var titleValueView6 = XWHTitleValueView()
    lazy var titleValueView7 = XWHTitleValueView()
    lazy var titleValueView8 = XWHTitleValueView()
    
    lazy var hSeparateLine2 = UIView()
    lazy var hSeparateLine3 = UIView()
    
    lazy var vSeparateLine3 = UIView()
    lazy var vSeparateLine4 = UIView()

    override func getCurrentFrame(_ frame: CGRect) -> CGRect {
        return frame
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(iconView)
        
        contentView.addSubview(titleLb)
        contentView.addSubview(valueLb)
        
        contentView.addSubview(titleValueView4)
        contentView.addSubview(titleValueView5)
        contentView.addSubview(titleValueView6)
        contentView.addSubview(titleValueView7)
        contentView.addSubview(titleValueView8)
        
        contentView.addSubview(hSeparateLine2)
        contentView.addSubview(hSeparateLine3)
        contentView.addSubview(vSeparateLine3)
        contentView.addSubview(vSeparateLine4)
        
        iconView.image = R.image.sport_detail_icon()
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        titleLb.textColor = fontDarkColor
        
        config(titleValueView: titleValueView1)
        config(titleValueView: titleValueView2)
        config(titleValueView: titleValueView3)
        config(titleValueView: titleValueView4)
        config(titleValueView: titleValueView5)
        config(titleValueView: titleValueView6)
        config(titleValueView: titleValueView7)
        config(titleValueView: titleValueView8)
        
        titleLb.text = "数据详情"

        titleValueView1.titleLb.text = "总计时长"
        titleValueView2.titleLb.text = "热量(千卡)"
        
        titleValueView3.titleLb.text = "公里配速(秒)"
        titleValueView4.titleLb.text = "步数(步)"
        
        titleValueView5.titleLb.text = "平均速度(公里/小时)"
        titleValueView6.titleLb.text = "平均配速(公里)"
        
        titleValueView7.titleLb.text = "平均步频(步/分钟)"
        titleValueView8.titleLb.text = "心率"
        
        hSeparateLine2.backgroundColor = separatorColor
        hSeparateLine3.backgroundColor = separatorColor

        vSeparateLine3.backgroundColor = separatorColor
        vSeparateLine4.backgroundColor = separatorColor
    }
    
    override func relayoutSubViews() {
        iconView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(16)
            make.size.equalTo(32)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(iconView)
            make.height.equalTo(23)
        }
        
        valueLb.snp.makeConstraints { make in
            make.left.equalTo(iconView)
            make.right.equalTo(titleLb)
            make.top.equalTo(iconView.snp.bottom).offset(12)
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
        
        hSeparateLine2.snp.makeConstraints { make in
            make.left.right.height.equalTo(hSeparateLine1)
            make.top.equalTo(titleValueView3.snp.bottom).offset(9)
        }
        
        titleValueView5.snp.makeConstraints { make in
            make.left.height.width.equalTo(titleValueView1)
            make.top.equalTo(hSeparateLine2.snp.bottom).offset(9)
        }
        
        vSeparateLine3.snp.makeConstraints { make in
            make.left.equalTo(titleValueView5.snp.right)
            make.centerY.equalTo(titleValueView5)
            make.width.equalTo(0.5)
            make.height.equalTo(32)
        }
        
        titleValueView6.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.width.height.equalTo(titleValueView5)
        }
        
        hSeparateLine3.snp.makeConstraints { make in
            make.left.right.height.equalTo(hSeparateLine1)
            make.top.equalTo(titleValueView5.snp.bottom).offset(9)
        }
        
        titleValueView7.snp.makeConstraints { make in
            make.left.height.width.equalTo(titleValueView1)
            make.top.equalTo(hSeparateLine3.snp.bottom).offset(9)
        }
        
        vSeparateLine4.snp.makeConstraints { make in
            make.left.equalTo(titleValueView7.snp.right)
            make.centerY.equalTo(titleValueView7)
            make.width.equalTo(0.5)
            make.height.equalTo(32)
        }
        
        titleValueView8.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.width.height.equalTo(titleValueView7)
        }
        
    }
    
    func update() {
        let value = "12.98"
        let unit = " 公里"
        let text = value + unit
        valueLb.attributedText = text.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 40, weight: .bold)], toOccurrencesOf: value).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)], toOccurrencesOf: unit)
        
        titleValueView1.valueLb.text = "00:00:45"
        titleValueView2.valueLb.text = "100"
        
        titleValueView3.valueLb.text = "00:34:22"
        titleValueView4.valueLb.text = "34"
        
        titleValueView5.valueLb.text = "211"
        titleValueView6.valueLb.text = "8'88\""
        
        titleValueView7.valueLb.text = "122"
        titleValueView8.valueLb.text = "120"
    }

}

extension XWHSportDetailDataDetailTBCell {
    
    override func config(titleValueView: XWHTitleValueView) {
        titleValueView.type = .valueUp
        
        titleValueView.titleLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        titleValueView.titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)

        titleValueView.valueLb.font = XWHFont.harmonyOSSans(ofSize: 23, weight: .bold)
        titleValueView.valueLb.textColor = fontDarkColor
    }
    
}
