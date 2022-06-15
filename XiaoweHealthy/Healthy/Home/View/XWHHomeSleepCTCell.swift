//
//  XWHHomeSleepCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/13.
//

import UIKit

class XWHHomeSleepCTCell: XWHCommonBaseCTCell {
    
    lazy var levelChartView1 = UIView()
    lazy var levelLb1 = UILabel()
    
    lazy var levelChartView2 = UIView()
    lazy var levelLb2 = UILabel()
    
    lazy var levelChartView3 = UIView()
    lazy var levelLb3 = UILabel()
    
    lazy var levelChartView4 = UIView()
    lazy var levelLb4 = UILabel()
    
    lazy var levelChartView5 = UIView()
    lazy var levelLb5 = UILabel()
    
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
        
        contentView.addSubview(levelChartView4)
        contentView.addSubview(levelLb4)
        
        contentView.addSubview(levelChartView5)
        contentView.addSubview(levelLb5)
        
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
        imageView.image = R.image.sleepIcon()
        
        levelLb1.textAlignment = .center
        levelLb2.textAlignment = .center
        levelLb3.textAlignment = .center
        levelLb4.textAlignment = .center
        levelLb5.textAlignment = .center
        
        levelLb1.font = XWHFont.harmonyOSSans(ofSize: 10, weight: .regular)
        levelLb2.font = levelLb1.font
        levelLb3.font = levelLb1.font
        levelLb4.font = levelLb1.font
        levelLb5.font = levelLb1.font
        
        levelLb1.textColor = fontDarkColor.withAlphaComponent(0.25)
        levelLb2.textColor = levelLb1.textColor
        levelLb3.textColor = levelLb1.textColor
        levelLb4.textColor = levelLb1.textColor
        levelLb5.textColor = levelLb1.textColor
        
        levelLb1.text = R.string.xwhHealthyText.很差()
        levelLb2.text = R.string.xwhHealthyText.较差()
        levelLb3.text = R.string.xwhHealthyText.一般()
        levelLb4.text = R.string.xwhHealthyText.较好()
        levelLb5.text = R.string.xwhHealthyText.很好()
        
        levelChartView1.layer.cornerRadius = 8
        levelChartView1.layer.backgroundColor = UIColor(hex: 0x8389F3)!.withAlphaComponent(0.1).cgColor
        
        levelChartView2.layer.cornerRadius = 8
        levelChartView2.layer.backgroundColor = UIColor(hex: 0x8389F3)!.withAlphaComponent(0.1).cgColor
        
        levelChartView3.layer.cornerRadius = 8
        levelChartView3.layer.backgroundColor = UIColor(hex: 0x8389F3)!.withAlphaComponent(0.1).cgColor
        
        levelChartView4.layer.cornerRadius = 8
        levelChartView4.layer.backgroundColor = UIColor(hex: 0x8389F3)!.withAlphaComponent(0.1).cgColor
        
        levelChartView5.layer.cornerRadius = 8
        levelChartView5.layer.backgroundColor = UIColor(hex: 0x8389F3)!.withAlphaComponent(0.1).cgColor
        
        curLevelLine.backgroundColor = UIColor(hex: 0x5047C4)
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
        
        let allPadding = 4 * 2 + 32
        let chartViewOffset = ceil((allPadding.cgFloat / 5)).int
        
        levelChartView1.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.2).offset(-chartViewOffset)
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
        
        levelChartView4.snp.makeConstraints { make in
            make.left.equalTo(levelChartView3.snp.right).offset(2)
            make.width.top.height.equalTo(levelChartView1)
        }
        
        levelLb4.snp.makeConstraints { make in
            make.centerX.width.equalTo(levelChartView4)
            make.top.height.equalTo(levelLb1)
        }
        
        levelChartView5.snp.makeConstraints { make in
            make.left.equalTo(levelChartView4.snp.right).offset(2)
            make.width.top.height.equalTo(levelChartView1)
        }
        
        levelLb5.snp.makeConstraints { make in
            make.centerX.width.equalTo(levelChartView5)
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
    
    func relayoutForCurLevel(sLevel: Int) {
        let targetView: UIView
        if sLevel == 0 {
            targetView = levelChartView1
        } else if sLevel == 1 {
            targetView = levelChartView2
        } else if sLevel == 2 {
            targetView = levelChartView3
        } else if sLevel == 3 {
            targetView = levelChartView4
        } else {
            targetView = levelChartView5
        }
        
        curLevelLine.snp.remakeConstraints { make in
            make.width.equalTo(2)
            make.height.equalTo(45)
            make.bottom.centerX.equalTo(targetView)
        }
    }
    
    func update(sleepUIModel: XWHHealthySleepUISleepModel?) {
        guard let sleepUIModel = sleepUIModel else {
            curLevelLine.isHidden = true
            curLevelDot.isHidden = true
            return
        }
        
        curLevelLine.isHidden = false
        curLevelDot.isHidden = false
        
        let totalDuration = sleepUIModel.totalSleepDuration
        let score = XWHUIDisplayHandler.getWeekMonthYearSleepTotalDurationScore(totalDuration)
        let sLevel = XWHUIDisplayHandler.getSleepQualityLevel(score)
        
        
        relayoutForCurLevel(sLevel: sLevel)
    }
    
}
