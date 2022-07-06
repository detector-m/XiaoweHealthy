//
//  XWHSportDetailPaceTBCell.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/27.
//

import UIKit

class XWHSportDetailPaceTBCell: XWHBaseTBCell {
    
    lazy var distanceTitleLb = UILabel()
    lazy var paceTitleLb = UILabel()
    lazy var averagePaceLb = UILabel()
    
    override func addSubViews() {
        super.addSubViews()
        
        contentView.addSubview(distanceTitleLb)
        contentView.addSubview(paceTitleLb)
        contentView.addSubview(averagePaceLb)
        
        iconView.image = R.image.sport_pace_icon()
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        titleLb.textColor = fontDarkColor
        
        titleLb.text = "平均配速"
        
        distanceTitleLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
        paceTitleLb.font = distanceTitleLb.font
        averagePaceLb.font = distanceTitleLb.font
        
        distanceTitleLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        paceTitleLb.textColor = distanceTitleLb.textColor
        averagePaceLb.textColor = fontDarkColor
        
        distanceTitleLb.textAlignment = .center
        paceTitleLb.textAlignment = .left
        averagePaceLb.textAlignment = .right
        
        distanceTitleLb.text = "公里"
        paceTitleLb.text = "配速(/km)"
    }
    
    override func relayoutSubViews() {
        iconView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.size.equalTo(32)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(12)
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(iconView)
            make.height.equalTo(23)
        }
        
        distanceTitleLb.snp.makeConstraints { make in
            make.left.equalTo(iconView)
            make.width.equalTo(30)
            make.top.equalTo(iconView.snp.bottom).offset(12)
            make.height.equalTo(20)
        }
        
        paceTitleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(62)
            make.width.lessThanOrEqualTo(80)
            make.centerY.height.equalTo(distanceTitleLb)
        }
        
        averagePaceLb.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.left.equalTo(paceTitleLb.snp.right).offset(2)
            make.centerY.height.equalTo(paceTitleLb)
        }
    }
    
    func update(sportDetail: XWHSportModel?) {
        let avgPace = XWHSportHelper.getPaceString(sportDetail?.pace ?? 0)
        averagePaceLb.text = "平均配速：\(avgPace)"
        
//        progressView.progressView.progressValue = 60
        
        createProgressView(sportDetail: sportDetail)
    }

}

extension XWHSportDetailPaceTBCell {
    
    private func createProgressView(sportDetail: XWHSportModel?) {
        contentView.subviews.forEach { cView in
            if let progress = cView as? XWHLinearProgressView {
                progress.removeFromSuperview()
            }
        }
        
        guard let sDetail = sportDetail, sDetail.pace > 0 else {
            return
        }
        
        let paceArray: [Int] = sDetail.eachPartItems.map({ $0.pace })
        let minPace = paceArray.min()
        for i in 0 ..< sDetail.eachPartItems.count {
            let iItem = sDetail.eachPartItems[i]
            
            let progress = XWHLinearProgressView()
            contentView.addSubview(progress)
            
            let offsetY = 5 + i * (34 + 5)
            progress.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(distanceTitleLb.snp.bottom).offset(offsetY)
                make.height.equalTo(34)
            }
            
            let value = (iItem.pace.double / sDetail.pace.double * 100).int
            
            if iItem.endMileage - iItem.startMileage < 1000 {
                config(progressView: progress, isFast: false, isOneKm: false, index: i, value: sDetail.duration)
            } else if minPace == iItem.pace {
                config(progressView: progress, isFast: true, isOneKm: true, index: i, value: value)
            } else {
                config(progressView: progress, isFast: false, isOneKm: true, index: i, value: value)
            }
        }
    }
    
    private func config(progressView: XWHLinearProgressView, isFast: Bool, isOneKm: Bool, index: Int, value: Int) {
        let paceString = XWHSportHelper.getPaceString(value)
        if !isOneKm {
            progressView.titleLb.text = ""
            progressView.valueLb.text = "不足一公里，用时 \(paceString)"
            progressView.valueLb.textColor = fontDarkColor
            
            progressView.progressView.trackColor = btnBgColor.withAlphaComponent(0.07)
            progressView.progressView.barColor = btnBgColor
            
            progressView.update(value: 0)
            
            return
        }
        
        if isFast {
            progressView.titleLb.text = "\(index + 1)"
            progressView.valueLb.text = paceString
            progressView.valueLb.textColor = UIColor.white
            
            let fastColor = UIColor(hex: 0xF8CA52)!
            progressView.progressView.trackColor = fastColor.withAlphaComponent(0.07)
            progressView.progressView.barColor = fastColor
            
            progressView.update(value: value)
            
            return
        }
        
        progressView.titleLb.text = "\(index)"
        progressView.valueLb.text = paceString
        progressView.valueLb.textColor = UIColor.white
        
        progressView.progressView.trackColor = btnBgColor.withAlphaComponent(0.07)
        progressView.progressView.barColor = btnBgColor
        
        progressView.update(value: value)
    }
    
}
