//
//  XWHSRLSportRecordSummaryTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/24.
//

import UIKit

class XWHSRLSportRecordSummaryTBCell: UITableViewCell {
    
    lazy var hSeparateLine1 = UIView()
    
    lazy var vSeparateLine1 = UIView()
    lazy var vSeparateLine2 = UIView()
    
    lazy var titleValueView1 = XWHTitleValueView()
    lazy var titleValueView2 = XWHTitleValueView()
    lazy var titleValueView3 = XWHTitleValueView()
    
    var separatorColor: UIColor {
        UIColor(hex: 0x979797).withAlphaComponent(0.2)
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        
        set {
            super.frame = getCurrentFrame(newValue)
        }
    }


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func getCurrentFrame(_ frame: CGRect) -> CGRect {
        var newFrame = frame
        newFrame.origin.x = 16
        newFrame.size.width -= 32
        
        return newFrame
    }
    
    func addSubViews() {
        contentView.addSubview(hSeparateLine1)
        
        contentView.addSubview(vSeparateLine1)
        contentView.addSubview(vSeparateLine2)
        
        contentView.addSubview(titleValueView1)
        contentView.addSubview(titleValueView2)
        contentView.addSubview(titleValueView3)
        
        hSeparateLine1.backgroundColor = separatorColor
        vSeparateLine1.backgroundColor = separatorColor
        vSeparateLine2.backgroundColor = separatorColor

        config(titleValueView: titleValueView1)
        config(titleValueView: titleValueView2)
        config(titleValueView: titleValueView3)

        titleValueView1.titleLb.text = "运动(公里)"
        titleValueView2.titleLb.text = "热量(千卡)"
        titleValueView3.titleLb.text = "运动(次数)"
    }
    
    func relayoutSubViews() {
        hSeparateLine1.snp.makeConstraints { make in
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
        
        vSeparateLine1.snp.makeConstraints { make in
            make.left.equalTo(titleValueView1.snp.right)
            make.centerY.equalTo(titleValueView1)
            make.width.equalTo(0.5)
            make.height.equalTo(32)
        }
        
        titleValueView2.snp.makeConstraints { make in
            make.left.equalTo(vSeparateLine1.snp.right)
            make.width.height.centerY.equalTo(titleValueView1)
        }
        
        vSeparateLine2.snp.makeConstraints { make in
            make.left.equalTo(titleValueView2.snp.right)
            make.centerY.equalTo(titleValueView1)
            make.width.equalTo(0.5)
            make.height.equalTo(32)
        }
        
        titleValueView3.snp.makeConstraints { make in
            make.left.equalTo(vSeparateLine2.snp.right)
            make.width.height.centerY.equalTo(titleValueView1)
        }
    }
    
    func update() {
        titleValueView1.valueLb.text = "20.12"
        titleValueView2.valueLb.text = "120"
        titleValueView3.valueLb.text = "2"
    }

}

extension XWHSRLSportRecordSummaryTBCell {
    
    @objc func config(titleValueView: XWHTitleValueView) {
        titleValueView.type = .titleUp
        
        titleValueView.titleLb.font = XWHFont.harmonyOSSans(ofSize: 12)
        titleValueView.titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)

        titleValueView.valueLb.font = XWHFont.harmonyOSSans(ofSize: 17, weight: .bold)
        titleValueView.valueLb.textColor = fontDarkColor
    }
    
}
