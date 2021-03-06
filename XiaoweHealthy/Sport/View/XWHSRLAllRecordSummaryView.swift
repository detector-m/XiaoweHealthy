//
//  XWHSRLAllRecordSummaryView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/25.
//

import UIKit

class XWHSRLAllRecordSummaryView: XWHBaseView {
    
    lazy var titleValueView1 = XWHTitleValueView()
    lazy var titleValueView2 = XWHTitleValueView()
    lazy var titleValueView3 = XWHTitleValueView()
    lazy var titleValueView4 = XWHTitleValueView()

    override func addSubViews() {
        super.addSubViews()
        
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.backgroundColor = UIColor(hex: 0x354152)!.cgColor
        
        addSubview(titleValueView1)
        addSubview(titleValueView2)
        addSubview(titleValueView3)
        addSubview(titleValueView4)

        titleValueView1.type = .titleUp
        titleValueView2.type = .titleUp
        titleValueView3.type = .titleUp
        titleValueView4.type = .titleUp
        
        titleValueView1.titleLb.font = XWHFont.harmonyOSSans(ofSize: 11)
        titleValueView2.titleLb.font = titleValueView1.titleLb.font
        titleValueView3.titleLb.font = titleValueView1.titleLb.font
        titleValueView4.titleLb.font = titleValueView1.titleLb.font
        
        titleValueView1.titleLb.textColor = .white
        titleValueView2.titleLb.textColor = .white
        titleValueView3.titleLb.textColor = .white
        titleValueView4.titleLb.textColor = .white
        
        titleValueView2.valueLb.font = XWHFont.harmonyOSSans(ofSize: 20, weight: .medium)
        titleValueView3.valueLb.font = titleValueView2.valueLb.font
        titleValueView4.valueLb.font = titleValueView2.valueLb.font
        
        titleValueView2.valueLb.textColor = .white
        titleValueView3.valueLb.textColor = .white
        titleValueView4.valueLb.textColor = .white
        
        titleValueView1.titleLb.textAlignment = .left
        titleValueView1.valueLb.textAlignment = .left
        
        titleValueView2.titleLb.textAlignment = .left
        titleValueView2.valueLb.textAlignment = .left
        
        titleValueView3.titleLb.textAlignment = .center
        titleValueView3.valueLb.textAlignment = .center
        
        titleValueView4.titleLb.textAlignment = .right
        titleValueView4.valueLb.textAlignment = .right
        
        updateTitles()
    }
    
    override func relayoutSubViews() {
        
    }
    
    func relayoutSubViews(topInset: CGFloat) {
        titleValueView1.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(topInset + 7)
            make.height.equalTo(85)
            make.left.right.equalToSuperview().inset(16)
        }
        
        titleValueView2.snp.makeConstraints { make in
            make.top.equalTo(titleValueView1.snp.bottom).offset(18)
            make.height.equalTo(48)
            make.left.equalTo(titleValueView1)
            make.width.equalTo(titleValueView1).multipliedBy(0.33)
        }
        
        titleValueView3.snp.makeConstraints { make in
            make.centerX.equalTo(titleValueView1)
            make.top.size.equalTo(titleValueView2)
        }

        titleValueView4.snp.makeConstraints { make in
            make.right.equalTo(titleValueView1)
            make.top.size.equalTo(titleValueView2)
        }
    }
    
    func update(sTotalRecord: XWHSportTotalRecordModel?) {
        let value = XWHSportDataHelper.mToKm(sTotalRecord?.distance ?? 0).string
        let unit = " ??????"
        let text = value + unit
        let valueFont = XWHFont.harmonyOSSans(ofSize: 50, weight: .medium)
        let unitFont = XWHFont.harmonyOSSans(ofSize: 15, weight: .regular)
        titleValueView1.valueLb.attributedText = text.colored(with: .white).applying(attributes: [.font: valueFont], toOccurrencesOf: value).applying(attributes: [.font: unitFont], toOccurrencesOf: unit)
    
        var t: Double = sTotalRecord?.totalMinutes.double ?? 0
        t = t / 3600
        titleValueView2.valueLb.text = (sTotalRecord?.times ?? 0).string
        titleValueView3.valueLb.text = t.rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrAwayFromZero).string
        titleValueView4.valueLb.text = XWHSportHelper.getPaceString(sTotalRecord?.averagePace ?? 0)
    }
    
    private func updateTitles() {
        titleValueView1.titleLb.text = "?????????????????????"
        titleValueView2.titleLb.text = "??????(??????)"
        titleValueView3.titleLb.text = "??????(??????)"
        titleValueView4.titleLb.text = "????????????"
    }

}
