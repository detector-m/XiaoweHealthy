//
//  XWHCalendarPreNextBtnView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/26.
//

import UIKit

class XWHCalendarPreNextBtnView: UIView {
    
    enum PreNextBtnActionType {
        case pre
        case next
    }
    
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
            tDate = now.monthBegin
        
        case .month, .year:
            tDate = now.yearBegin
        }
        
        return tDate
    }() {
        didSet {
            updateUI()
        }
    }
    
    private lazy var _minBeginDate: Date = {
        var now = Date()
        var retDate = now
        retDate.year = 1970
        retDate = retDate.yearBegin
        
        return retDate
    }()
    var minBeginDate: Date {
        get {
            _minBeginDate
        }
        set {
            var tDate: Date

            switch dateType {
            case .day, .week:
                tDate = newValue.monthBegin
            
            case .month, .year:
                tDate = newValue.yearBegin
            }
            
            _minBeginDate = tDate
        }
    }
    
    private lazy var _maxBeginDate: Date = {
        var now = Date()
        var tDate: Date
        switch dateType {
        case .day, .week:
            tDate = now.monthBegin
        
        case .month, .year:
            tDate = now.yearBegin
        }
        
        return tDate
    }()
    
    var maxBeginDate: Date {
        get {
            _maxBeginDate
        }
        set {
            var tDate: Date

            switch dateType {
            case .day, .week:
                tDate = newValue.monthBegin
            
            case .month, .year:
                tDate = newValue.yearBegin
            }
            
            _maxBeginDate = tDate
        }
    }
    
    var selectHandler: ((Date, PreNextBtnActionType) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubViews()
        relayoutSubViews()
    }
    
    convenience init(dateType: XWHHealthyDateSegmentType) {
        self.init(frame: .zero)
        self.dateType = dateType
        maxBeginDate = Date()
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
        var actionType: PreNextBtnActionType = .pre
        if sender == preBtn {
            actionType = .pre
        
            switch dateType {
            case .day, .week:
                curBeginDate.add(.month, value: -1)
            case .month, .year:
                curBeginDate.add(.year, value: -1)
            }
        } else {
            actionType = .next
            
            switch dateType {
            case .day, .week:
                curBeginDate.add(.month, value: 1)
            case .month, .year:
                curBeginDate.add(.year, value: 1)
            }
        }
        updateUI()
        
        selectHandler?(curBeginDate, actionType)
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

