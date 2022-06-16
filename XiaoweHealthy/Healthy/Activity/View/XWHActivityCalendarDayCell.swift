//
//  XWHActivityCalendarDayCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/16.
//

import UIKit
import JTAppleCalendar
import MKRingProgressView

class XWHActivityCalendarDayCell: JTACDayCell {
    
    lazy var textLb = UILabel()
    lazy var indicator = UIView()
    private lazy var indicatorSize: CGFloat = 28
    
    private var atRingSize: CGFloat {
        return 30
    }
    lazy var activityRings = RingProgressGroupView(frame: CGRect(x: 0, y: 0, width: atRingSize, height: atRingSize))
    
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
        indicator.layer.backgroundColor = btnBgColor.withAlphaComponent(0.12).cgColor
        indicator.layer.cornerRadius = indicatorSize / 2
        contentView.addSubview(indicator)
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        textLb.textAlignment = .center
        contentView.addSubview(textLb)
        
        contentView.addSubview(activityRings)
        
        config(activityRings: activityRings)
    }
    
    @objc func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.top.equalToSuperview().offset(4)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview()
        }
        
        indicator.snp.makeConstraints { make in
            make.size.equalTo(indicatorSize)
            make.center.equalTo(textLb)
        }
        
        activityRings.snp.makeConstraints { make in
            make.size.equalTo(atRingSize)
            make.top.equalTo(textLb.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    func updateActivityRings(atSumUIModel: XWHActivitySumUIModel?) {
        guard let atSumUIModel = atSumUIModel else {
            activityRings.ring1.progress = 0
            activityRings.ring2.progress = 0
            activityRings.ring3.progress = 0
            return
        }

        let stepGoal = atSumUIModel.stepGoal > 0 ? atSumUIModel.stepGoal : 8000
        let calGoal = atSumUIModel.caloriesGoal > 0 ? atSumUIModel.caloriesGoal : 300
        let distanceGoal = (atSumUIModel.distanceGoal > 0 ? atSumUIModel.distanceGoal : 3000) / 1000
        
        activityRings.ring1.progress = atSumUIModel.totalSteps.double / stepGoal.double
        activityRings.ring2.progress = atSumUIModel.totalCalories.double / calGoal.double
        activityRings.ring3.progress = (atSumUIModel.totalDistance.double) / 1000 / distanceGoal.double
    }
    
}

extension XWHActivityCalendarDayCell {
    
    func config(activityRings: RingProgressGroupView) {
        activityRings.ringWidth = 3
        activityRings.ringSpacing = 1
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
