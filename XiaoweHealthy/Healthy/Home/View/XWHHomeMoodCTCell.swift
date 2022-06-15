//
//  XWHHomeMoodCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/13.
//

import UIKit

class XWHHomeMoodCTCell: XWHCommonBaseCTCell {
    
    lazy var levelChartView1 = UIView()
    lazy var levelLb1 = UILabel()
    
    lazy var levelChartView2 = UIView()
    lazy var levelLb2 = UILabel()
    
    lazy var levelChartView3 = UIView()
    lazy var levelLb3 = UILabel()
    
    lazy var curLevelLine = UIView()
    lazy var curLevelDot = UIView()
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(imageView)
        
        contentView.addSubview(levelChartView1)
        contentView.addSubview(levelLb1)
        
        contentView.addSubview(levelChartView2)
        contentView.addSubview(levelLb2)
        
        contentView.addSubview(levelChartView3)
        contentView.addSubview(levelLb3)
        
        contentView.addSubview(curLevelLine)
        contentView.addSubview(curLevelDot)

        layer.cornerRadius = 16
        layer.backgroundColor = contentBgColor.cgColor
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        
        detailLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        
        imageView.layer.cornerRadius = 16
        imageView.layer.backgroundColor = fontDarkColor.withAlphaComponent(0.4).cgColor
        imageView.contentMode = .center
        imageView.image = R.image.moodIcon()
        
        levelLb1.textAlignment = .left
        levelLb2.textAlignment = .center
        levelLb3.textAlignment = .right
        
        levelLb1.font = XWHFont.harmonyOSSans(ofSize: 10, weight: .regular)
        levelLb2.font = levelLb1.font
        levelLb3.font = levelLb1.font
        
        levelLb1.textColor = fontDarkColor.withAlphaComponent(0.25)
        levelLb2.textColor = levelLb1.textColor
        levelLb3.textColor = levelLb1.textColor
        
        levelLb1.text = R.string.xwhHealthyText.积极()
        levelLb2.text = R.string.xwhHealthyText.平和()
        levelLb3.text = R.string.xwhHealthyText.消极()
        
        levelChartView1.layer.cornerRadius = 8
        levelChartView1.layer.backgroundColor = UIColor(hex: 0xFFB25A)!.withAlphaComponent(0.1).cgColor
        
        levelChartView2.layer.cornerRadius = 8
        levelChartView2.layer.backgroundColor = UIColor(hex: 0xFFD978)!.withAlphaComponent(0.15).cgColor
        
        levelChartView3.layer.cornerRadius = 8
        levelChartView3.layer.backgroundColor = UIColor(hex: 0x8391F3)!.withAlphaComponent(0.1).cgColor
        
        curLevelLine.backgroundColor = UIColor(hex: 0xFFB25A)
        curLevelDot.layer.cornerRadius = 2
        curLevelDot.layer.backgroundColor = curLevelLine.backgroundColor?.cgColor
        
        detailLb.text = R.string.xwhHealthyText.暂无数据()
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
        
        let allPadding = 2 * 2 + 32
        let chartViewOffset = ceil((allPadding.cgFloat / 3)).int
        
        levelChartView1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.333).offset(-chartViewOffset)
            make.top.equalTo(detailLb.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        levelLb1.snp.makeConstraints { make in
            make.centerX.width.equalTo(levelChartView1)
            make.top.equalTo(levelChartView1.snp.bottom).offset(4)
            make.height.equalTo(16)
        }
        
        levelChartView2.snp.makeConstraints { make in
            make.left.equalTo(levelChartView1.snp.right).offset(2)
            make.width.top.height.equalTo(levelChartView1)
        }
        
        levelLb2.snp.makeConstraints { make in
            make.centerX.width.equalTo(levelChartView2)
            make.top.height.equalTo(levelLb1)
        }
        
        levelChartView3.snp.makeConstraints { make in
            make.left.equalTo(levelChartView2.snp.right).offset(2)
            make.width.top.height.equalTo(levelChartView1)
        }
        
        levelLb3.snp.makeConstraints { make in
            make.centerX.width.equalTo(levelChartView3)
            make.top.height.equalTo(levelLb1)
        }
        
        curLevelLine.snp.makeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(45)
            make.bottom.centerX.equalTo(levelChartView3)
        }
        
        curLevelDot.snp.makeConstraints { make in
            make.size.equalTo(4)
            make.centerX.equalTo(curLevelLine)
            make.bottom.equalTo(curLevelLine.snp.top)
        }
    }
    
    func relayoutCurLevel(level: Int) {
        let targetView: UIView

        if level == 0 {
            targetView = levelChartView1
        } else if level == 1 {
            targetView = levelChartView2
        } else {
            targetView = levelChartView3
        }
        
        curLevelLine.snp.remakeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(45)
            make.bottom.centerX.equalTo(targetView)
        }
    }
    
    func update(moodUIModel: XWHMoodUIMoodModel?) {
        guard let moodUIModel = moodUIModel else {
            curLevelLine.isHidden = true
            curLevelDot.isHidden = true
            
            return
        }
        
        curLevelLine.isHidden = false
        curLevelDot.isHidden = false
        
        relayoutCurLevel(level: moodUIModel.mood)
    }
    
}
