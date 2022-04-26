//
//  XWHCalendarPreNextBtnView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/26.
//

import UIKit

class XWHCalendarPreNextBtnView: UIView {
    
    lazy var preBtn = UIButton()
    lazy var nextBtn = UIButton()
    
    lazy var textLb = UILabel()
    
    /// 日期类型
    var dateType: XWHHealthyDateSegmentType = .year {
        didSet {
            updateUI()
        }
    }
    
    /// 当前的开始日期
    lazy var curBeginDate: Date = {
        var now = Date()
        var tDate: Date
        switch dateType {
        case .day, .week:
            tDate = now.beginning(of: .month) ?? now
        
        case .month, .year:
            tDate = now.beginning(of: .year) ?? now
        }
        
        return tDate
    }() {
        didSet {
            updateUI()
        }
    }
    
    lazy var minBeginDate: Date = {
        var now = Date()
        var retDate = now
        retDate.year = 1970
        retDate = retDate.beginning(of: .year) ?? retDate
        
        return retDate
    }() {
        didSet {
            var tDate: Date

            switch dateType {
            case .day, .week:
                tDate = minBeginDate.beginning(of: .month) ?? minBeginDate
            
            case .month, .year:
                tDate = minBeginDate.beginning(of: .year) ?? minBeginDate
            }
            
            minBeginDate = tDate
        }
    }
    
    lazy var maxBeginDate: Date = {
        var now = Date()
        var tDate: Date
        switch dateType {
        case .day, .week:
            tDate = now.beginning(of: .month) ?? now
        
        case .month, .year:
            tDate = now.beginning(of: .year) ?? now
        }
        
        return tDate
    }() {
        didSet {
            var tDate: Date

            switch dateType {
            case .day, .week:
                tDate = maxBeginDate.beginning(of: .month) ?? maxBeginDate
            
            case .month, .year:
                tDate = maxBeginDate.beginning(of: .year) ?? maxBeginDate
            }
            
            maxBeginDate = tDate
        }
    }
    
    var selectHandler: XWHCalendarSelectDateHandler?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
    }
    
    convenience init(dateType: XWHHealthyDateSegmentType) {
        self.init(frame: .zero)
        self.dateType = dateType
        
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func addSubViews() {
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
        
        textLb.textColor = fontDarkColor
        textLb.font = XWHFont.harmonyOSSans(ofSize: 18, weight: .medium)
        textLb.textAlignment = .center
        
        textLb.text = Date().localizedString(withFormat: XWHDate.yearMonthFormat)
        
        addSubview(textLb)
        
        nextBtn.addTarget(self, action: #selector(clickPreNextAction(_:)), for: .touchUpInside)
        preBtn.addTarget(self, action: #selector(clickPreNextAction(_:)), for: .touchUpInside)
        
        updateUI()
    }
    
    @objc func relayoutSubViews() {
        textLb.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.equalTo(25)
        }
        
        preBtn.snp.makeConstraints { make in
            make.centerY.equalTo(textLb)
            make.size.equalTo(17)
            make.left.greaterThanOrEqualToSuperview()
            make.right.equalTo(textLb.snp.left).offset(-11)
        }
        nextBtn.snp.makeConstraints { make in
            make.centerY.size.equalTo(preBtn)
            make.left.equalTo(textLb.snp.right).offset(11)
            make.right.lessThanOrEqualToSuperview()
        }
    }

}

// MARK: - Action
extension XWHCalendarPreNextBtnView {
    
    @objc private func clickPreNextAction(_ sender: UIButton) {
        if sender == preBtn {
            switch dateType {
            case .day, .week:
                curBeginDate.add(.month, value: -1)
            case .month, .year:
                curBeginDate.add(.year, value: -1)
            }
        } else {
            switch dateType {
            case .day, .week:
                curBeginDate.add(.month, value: 1)
            case .month, .year:
                curBeginDate.add(.year, value: 1)
            }
        }
        updateUI()
        
        selectHandler?(curBeginDate)
    }

}

// MARK: -
extension XWHCalendarPreNextBtnView {
    
    private func updateUI() {
        if curBeginDate > minBeginDate {
            preBtn.isEnabled = true
        } else {
            preBtn.isEnabled = false
        }
        
        if curBeginDate < maxBeginDate {
            nextBtn.isEnabled = true
        } else  {
            nextBtn.isEnabled = false
        }
        
        switch dateType {
        case .day, .week:
            textLb.text = curBeginDate.localizedString(withFormat: XWHDate.yearMonthFormat)
        
        case .month, .year:
            textLb.text = curBeginDate.localizedString(withFormat: XWHDate.yearFormat)
        }
    }
    
}

