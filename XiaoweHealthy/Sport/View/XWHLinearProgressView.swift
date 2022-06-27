//
//  XWHLinearProgressView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/27.
//

import UIKit
import LinearProgressBar

class XWHLinearProgressView: XWHBaseView {

    lazy var progressView = LinearProgressBar()
    
//    lazy var distanceTitleLb = UILabel()
    
    lazy var titleLb = UILabel()
    lazy var valueLb = UILabel()

    override func addSubViews() {
        super.addSubViews()
        
        addSubview(progressView)
        addSubview(titleLb)
        addSubview(valueLb)
        
        progressView.isUserInteractionEnabled = false
        progressView.trackPadding = 0
        progressView.backgroundColor = .clear
        
//        distanceTitleLb.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .regular)
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .bold)
        valueLb.font = XWHFont.harmonyOSSans(ofSize: 10, weight: .regular)
        
//        distanceTitleLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        titleLb.textColor = fontDarkColor
        valueLb.textColor = .white
        
//        distanceTitleLb.textAlignment = .center
        titleLb.textAlignment = .center
        valueLb.textAlignment = .right
        
//        distanceTitleLb.text = "公里"
        
//        distanceTitleLb.isHidden = true
        
        progressView.capType = 1
        progressView.trackColor = btnBgColor.withAlphaComponent(0.07)
        progressView.barColor = btnBgColor
    }
    
    override func relayoutSubViews() {
        titleLb.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.width.lessThanOrEqualTo(30)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        progressView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(62)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
        }
    }
    
    func update(value: Int) {
        titleLb.text = "1"
        valueLb.text = "6'22\""
        
        let doubleValue = value.double
        progressView.progressValue = doubleValue
        let rate = doubleValue / 100
        valueLb.snp.remakeConstraints { make in
            make.left.height.centerY.equalTo(progressView)
            make.width.greaterThanOrEqualTo(30).priority(.medium)
            make.width.equalTo(progressView).multipliedBy(rate).priority(.required)
        }
    }
    
}
