//
//  XWHSleepScoreCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/5/6.
//

import UIKit
import KDCircularProgress

class XWHSleepScoreCTCell: XWHSleepCommonCTCell {
    
    private let spSize = 100
    private(set) lazy var scoreProgress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: spSize, height: spSize))
    
    lazy var bTimeTitleLb = UILabel()
    lazy var eTimeTitleLb = UILabel()
    
    lazy var bTimeValueLb = UILabel()
    lazy var eTimeValueLb = UILabel()

    override func addSubViews() {
        super.addSubViews()
        
        scoreProgress.startAngle = -90
        scoreProgress.progressThickness = 0.6
        scoreProgress.trackThickness = 0.6
        scoreProgress.clockwise = true
        scoreProgress.gradientRotateSpeed = 0
        scoreProgress.roundedCorners = true
        scoreProgress.glowMode = .noGlow
        scoreProgress.glowAmount = 1
        scoreProgress.trackColor = UIColor(hex: 0x8389F3, transparency: 0.1)!
        scoreProgress.set(colors: UIColor(hex: 0x8389F3)!)
        contentView.addSubview(scoreProgress)
        
        let ltxColor = fontDarkColor.withAlphaComponent(0.3)
        bTimeTitleLb.font = XWHFont.harmonyOSSans(ofSize: 10)
        bTimeTitleLb.textColor = ltxColor
        bTimeTitleLb.textAlignment = .center
        contentView.addSubview(bTimeTitleLb)
        
        eTimeTitleLb.font = XWHFont.harmonyOSSans(ofSize: 10)
        eTimeTitleLb.textColor = ltxColor
        eTimeTitleLb.textAlignment = .center
        contentView.addSubview(eTimeTitleLb)
        
        bTimeValueLb.font = XWHFont.harmonyOSSans(ofSize: 16)
        bTimeValueLb.textColor = fontDarkColor
        bTimeValueLb.textAlignment = .center
        contentView.addSubview(bTimeValueLb)
        
        eTimeValueLb.font = XWHFont.harmonyOSSans(ofSize: 16)
        eTimeValueLb.textColor = fontDarkColor
        eTimeValueLb.textAlignment = .center
        contentView.addSubview(eTimeValueLb)
        
        textLb.font = XWHFont.harmonyOSSans(ofSize: 24, weight: .bold)
        textLb.textAlignment = .center
        textLb.adjustsFontSizeToFitWidth = true
        
        detailLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        detailLb.textColor = fontDarkColor
        detailLb.textAlignment = .center
        
        tipLb.textColor = ltxColor
        tipLb.textAlignment = .left
        tipLb.numberOfLines = 0
        tipLb.font = XWHFont.harmonyOSSans(ofSize: 12)
    }
    
    override func relayoutSubViews() {
        scoreProgress.snp.makeConstraints { make in
            make.width.height.equalTo(spSize)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(6)
        }
        
        textLb.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(58)
            make.center.equalTo(scoreProgress)
        }
        
        detailLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(scoreProgress.snp.bottom).offset(10)
            make.height.equalTo(22)
        }
        
        tipLb.snp.makeConstraints { make in
            make.left.right.equalTo(detailLb)
            make.top.equalTo(detailLb.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-14)
        }
        
        bTimeTitleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.right.equalTo(scoreProgress.snp.left)
            make.height.equalTo(14)
            make.centerY.equalTo(scoreProgress).offset(-8)
        }
        bTimeValueLb.snp.makeConstraints { make in
            make.left.right.equalTo(bTimeTitleLb)
            make.height.equalTo(24)
            make.top.equalTo(bTimeTitleLb.snp.bottom).offset(2)
        }
        
        eTimeTitleLb.snp.makeConstraints { make in
            make.centerY.height.equalTo(bTimeTitleLb)
            make.left.equalTo(scoreProgress.snp.right)
            make.right.equalToSuperview().inset(16)
        }
        eTimeValueLb.snp.makeConstraints { make in
            make.left.right.equalTo(eTimeTitleLb)
            make.height.equalTo(24)
            make.top.equalTo(eTimeTitleLb.snp.bottom).offset(2)
        }
    }
    
    func update(score: Int, sleepQuality: String, sleepTip: String, bTime: String, eTime: String, dateType: XWHHealthyDateSegmentType) {
        
        scoreProgress.angle = score.cgFloat * 360 / 100
        textLb.text = score.string + R.string.xwhHealthyText.score分()
        detailLb.text = sleepQuality
        tipLb.text = sleepTip
        
        if dateType == .day {
            bTimeTitleLb.isHidden = false
            bTimeValueLb.isHidden = false
            
            eTimeTitleLb.isHidden = false
            eTimeValueLb.isHidden = false
            
            bTimeTitleLb.text = R.string.xwhHealthyText.入睡时间()
            bTimeValueLb.text = bTime
            
            eTimeTitleLb.text = R.string.xwhHealthyText.醒来时间()
            eTimeValueLb.text = eTime
        } else {
            bTimeTitleLb.isHidden = true
            bTimeValueLb.isHidden = true
            
            eTimeTitleLb.isHidden = true
            eTimeValueLb.isHidden = true
        }
    }
    
}
