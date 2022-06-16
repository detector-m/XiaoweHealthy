//
//  XWHHealthActivityCTCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/11.
//

import UIKit
import KDCircularProgress
import MKRingProgressView

class XWHHealthActivityCTCell: UICollectionViewCell {
    
    lazy var stepLegend = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: legendSize, height: legendSize))
    lazy var stepTitleLb = UILabel()
    lazy var stepValueLb = UILabel()
    
    lazy var calLegend = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: legendSize, height: legendSize))
    lazy var calTitleLb = UILabel()
    lazy var calValueLb = UILabel()
    
    lazy var distanceLegend = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: legendSize, height: legendSize))
    lazy var distanceTitleLb = UILabel()
    lazy var distanceValueLb = UILabel()
    
    lazy var activityRings = RingProgressGroupView(frame: CGRect(x: 0, y: 0, width: atRingSize, height: atRingSize))
    
    private var atRingSize: CGFloat {
        return 136
    }
    
    private var legendSize: CGFloat {
        return 20
    }
    
    private var titleColor: UIColor {
        return fontDarkColor.withAlphaComponent(0.4)
    }
    private var titleFont: UIFont {
        XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
    }
    private var valueFont: UIFont {
        XWHFont.harmonyOSSans(ofSize: 20, weight: .bold)
    }
    
    private var stepColor: UIColor {
        UIColor(hex: 0x3EDE69)!
    }

    private var calColor: UIColor {
        UIColor(hex: 0xFFCA4F)!
    }
    
    private var distanceColor: UIColor {
        UIColor(hex: 0x6FA9FF)!
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func addSubViews() {
        contentView.addSubview(activityRings)
        
        contentView.addSubview(stepLegend)
        contentView.addSubview(stepTitleLb)
        contentView.addSubview(stepValueLb)
        
        contentView.addSubview(calLegend)
        contentView.addSubview(calTitleLb)
        contentView.addSubview(calValueLb)

        contentView.addSubview(distanceLegend)
        contentView.addSubview(distanceTitleLb)
        contentView.addSubview(distanceValueLb)

        
        layer.cornerRadius = 16
        layer.backgroundColor = contentBgColor.cgColor
        
        config(activityRings: activityRings)
        
        config(legend: stepLegend, trackColor: stepColor.withAlphaComponent(0.2), color: stepColor)
        
        stepTitleLb.textColor = titleColor
        stepTitleLb.font = titleFont
        stepValueLb.textColor = fontDarkColor
        stepValueLb.font = valueFont
        
        config(legend: calLegend, trackColor: calColor.withAlphaComponent(0.2), color: calColor)
        calTitleLb.textColor = titleColor
        calTitleLb.font = titleFont
        calValueLb.textColor = fontDarkColor
        calValueLb.font = valueFont
        
        config(legend: distanceLegend, trackColor: distanceColor.withAlphaComponent(0.2), color: distanceColor)
        distanceTitleLb.textColor = titleColor
        distanceTitleLb.font = titleFont
        distanceValueLb.textColor = fontDarkColor
        distanceValueLb.font = valueFont
    }
    
    @objc func relayoutSubViews() {
        activityRings.snp.makeConstraints { make in
            make.size.equalTo(atRingSize)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(28)
        }
        
        stepLegend.snp.makeConstraints { make in
            make.size.equalTo(legendSize)
            make.top.equalTo(28)
            make.left.equalTo(16)
        }
        stepTitleLb.snp.makeConstraints { make in
            make.top.equalTo(stepLegend)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(56)
            make.left.equalTo(stepLegend.snp.right).offset(10)
        }
        stepValueLb.snp.makeConstraints { make in
            make.top.equalTo(stepTitleLb.snp.bottom)
            make.height.equalTo(27)
            make.left.equalTo(stepTitleLb)
            make.right.lessThanOrEqualTo(activityRings.snp.left).offset(-2)
        }
        
        calLegend.snp.makeConstraints { make in
            make.size.equalTo(legendSize)
            make.top.equalTo(stepValueLb.snp.bottom).offset(8)
            make.left.equalTo(stepLegend)
        }
        calTitleLb.snp.makeConstraints { make in
            make.top.equalTo(calLegend)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(56)
            make.left.equalTo(calLegend.snp.right).offset(10)
        }
        calValueLb.snp.makeConstraints { make in
            make.top.equalTo(calTitleLb.snp.bottom)
            make.height.equalTo(27)
            make.left.equalTo(calTitleLb)
            make.right.lessThanOrEqualTo(activityRings.snp.left).offset(-2)
        }
        
        distanceLegend.snp.makeConstraints { make in
            make.size.equalTo(legendSize)
            make.top.equalTo(calValueLb.snp.bottom).offset(8)
            make.left.equalTo(stepLegend)
        }
        distanceTitleLb.snp.makeConstraints { make in
            make.top.equalTo(distanceLegend)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(56)
            make.left.equalTo(distanceLegend.snp.right).offset(10)
        }
        distanceValueLb.snp.makeConstraints { make in
            make.top.equalTo(distanceTitleLb.snp.bottom)
            make.height.equalTo(27)
            make.left.equalTo(distanceTitleLb)
            make.right.lessThanOrEqualTo(activityRings.snp.left).offset(-2)
        }
    }
    
    func update(atSumUIModel: XWHActivitySumUIModel?) {
        stepTitleLb.text = R.string.xwhHealthyText.步数()
        calTitleLb.text = R.string.xwhHealthyText.消耗()
        distanceTitleLb.text = R.string.xwhHealthyText.距离()

        stepValueLb.text = "0"
        calValueLb.text = "0"
        distanceValueLb.text = "0"
        
        guard let atSumUIModel = atSumUIModel else {
            return
        }
        
        let stepGoal = atSumUIModel.stepGoal > 0 ? atSumUIModel.stepGoal : 8000
        let calGoal = atSumUIModel.caloriesGoal > 0 ? atSumUIModel.caloriesGoal : 300
        let distanceGoal = (atSumUIModel.distanceGoal > 0 ? atSumUIModel.distanceGoal : 3000) / 1000
        
        let stepValue = atSumUIModel.totalSteps
        var valueString = stepValue.string
        var targetString = " /" + stepGoal.string + R.string.xwhHealthyText.步()
        var text = valueString + targetString
        stepValueLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: valueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: titleFont, .foregroundColor: titleColor], toOccurrencesOf: targetString)
        

        valueString = atSumUIModel.totalCalories.string
        targetString = " /" + calGoal.string + R.string.xwhHealthyText.千卡()
        text = valueString + targetString
        calValueLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: valueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: titleFont, .foregroundColor: titleColor], toOccurrencesOf: targetString)
        

        let distance = (atSumUIModel.totalDistance.double / 1000).rounded(numberOfDecimalPlaces: 2, rule: .toNearestOrAwayFromZero)
        valueString = distance.string
        targetString = " /" + distanceGoal.string + R.string.xwhHealthyText.公里()
        text = valueString + targetString
        distanceValueLb.attributedText = NSAttributedString(string: text).applying(attributes: [.font: valueFont, .foregroundColor: fontDarkColor], toOccurrencesOf: valueString).applying(attributes: [.font: titleFont, .foregroundColor: titleColor], toOccurrencesOf: targetString)
        
        activityRings.ring1.progress = atSumUIModel.totalSteps.double / stepGoal.double
        activityRings.ring2.progress = atSumUIModel.totalCalories.double / calGoal.double
        activityRings.ring3.progress = (atSumUIModel.totalDistance.double) / 1000 / distanceGoal.double
    }
    
}

private extension XWHHealthActivityCTCell {
    
    func config(legend: KDCircularProgress, trackColor: UIColor, color: UIColor) {
        legend.startAngle = -90
        legend.progressThickness = 1
        legend.trackThickness = 1
        legend.clockwise = false
        legend.gradientRotateSpeed = 0
        legend.roundedCorners = true
        legend.glowMode = .noGlow
        legend.glowAmount = 0
        legend.progress = 0.5
        legend.trackColor = trackColor
        legend.set(colors: color)
    }
    
    func config(activityRings: RingProgressGroupView) {
        activityRings.ringWidth = 16
        activityRings.ringSpacing = 6
        activityRings.ring1StartColor = stepColor
        activityRings.ring1EndColor = activityRings.ring1StartColor
        activityRings.ring2StartColor = calColor
        activityRings.ring2EndColor = activityRings.ring2StartColor
        activityRings.ring3StartColor = distanceColor
        activityRings.ring3EndColor = activityRings.ring3StartColor
        
        activityRings.ring1.hidesRingForZeroProgress = true
        activityRings.ring2.hidesRingForZeroProgress = true
        activityRings.ring3.hidesRingForZeroProgress = true
        
        
        if let progressLayer = activityRings.ring1.layer as? RingProgressLayer {
            progressLayer.endShadowOpacity = 0
        }
        if let progressLayer = activityRings.ring2.layer as? RingProgressLayer {
            progressLayer.endShadowOpacity = 0
        }
        if let progressLayer = activityRings.ring3.layer as? RingProgressLayer {
            progressLayer.endShadowOpacity = 0
        }
    }
    
}
