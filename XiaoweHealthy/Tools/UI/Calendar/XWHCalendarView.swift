//
//  XWHCalendarView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/25.
//

import UIKit

class XWHCalendarView: RLPopupContentBaseView {
    
    lazy var dateSegment = XWHDateSegmentView()
    var dateType: XWHHealthyDateSegmentType {
        dateSegment.selectedType
    }
//    var dateFormat: String {
//        switch dateType {
//        case .day:
//            return XWHDate.yearMonthDayFormat
//        case .week:
//            return XWHDate.yearMonthDayFormat
//
//        case .month:
//            return XWHDate.yearMonthFormat
//
//        case .year:
//            return XWHDate.yearFormat
//        }
//    }

    lazy var preBtn = UIButton()
    lazy var nextBtn = UIButton()
    
    lazy var weekView = XWHCalendarWeekView(config: .init())
    
    override func addSubViews() {
        super.addSubViews()
        
        detailLb.isHidden = true
        cancelBtn.isHidden = true
        confirmBtn.isHidden = true
        
        addSubview(dateSegment)
        
        let preImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowLeft.rawValue, size: 17, color: fontDarkColor)
        let preDisableImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowLeft.rawValue, size: 17, color: fontLightColor)
        preBtn.setImage(preImage, for: .normal)
        preBtn.setImage(preDisableImage, for: .disabled)
        addSubview(preBtn)
        
        let nextImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 17, color: fontDarkColor)
        let nextDisableImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 17, color: fontLightColor)
        nextBtn.setImage(nextImage, for: .normal)
        nextBtn.setImage(nextDisableImage, for: .disabled)
        addSubview(nextBtn)
        
        addSubview(weekView)
        
        nextBtn.addTarget(self, action: #selector(clickPreNextAction(_:)), for: .touchUpInside)
        preBtn.addTarget(self, action: #selector(clickPreNextAction(_:)), for: .touchUpInside)
        
        titleLb.isHidden = false
        titleLb.textColor = fontDarkColor
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 18, weight: .medium)
        titleLb.textAlignment = .center
        
        titleLb.text = Date().localizedString(withFormat: XWHDate.yearMonthFormat)
    }
    
    override func relayoutSubViews() {
        relayoutDateSegment()
        relayoutDateTitle()
        
        weekView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(24)
            make.top.equalTo(titleLb.snp.bottom).offset(22)
        }
    }
    
    @objc final func relayoutDateSegment() {
        dateSegment.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(18)
            make.top.equalToSuperview().offset(24)
            make.height.equalTo(32)
        }
    }
    
    @objc final func relayoutDateTitle() {
        titleLb.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(25)
            make.top.equalTo(dateSegment.snp.bottom).offset(31)
        }
        
        preBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLb)
            make.size.equalTo(17)
            make.left.greaterThanOrEqualTo(dateSegment)
            make.right.equalTo(titleLb.snp.left).offset(-11)
        }
        nextBtn.snp.makeConstraints { make in
            make.centerY.size.equalTo(preBtn)
            make.left.equalTo(titleLb.snp.right).offset(11)
            make.right.lessThanOrEqualTo(dateSegment)
        }
    }
    
}

// MARK: - Action
extension XWHCalendarView {
    
    @objc private func clickPreNextAction(_ sender: UIButton) {
        
    }
    
}
