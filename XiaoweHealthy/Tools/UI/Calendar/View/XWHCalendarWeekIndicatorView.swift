//
//  XWHCalendarWeekIndicatorView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/25.
//

import UIKit
import JTAppleCalendar

class XWHCalendarWeekIndicatorView: UIView {
    
    // MARK: - Outlets
    public lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()
    
    var indicatorDate: Date? {
        didSet {
            reloadIndicatorData()
        }
    }
    var curWeekDates: [Date] = [] {
        didSet {
            reloadIndicatorData()
        }
    }
    private var indicatorIndex: Int? {
        guard var inDate = indicatorDate else {
            return nil
        }
        
        inDate = inDate.dayBegin
        
        for (i, iDate) in curWeekDates.enumerated() {
            if iDate.dayBegin == inDate {
                return i
            }
        }
        
        return nil
    }
    
    private var contentHeight: CGFloat {
        32
    }

    // MARK: - Variables
    private let config: XWHCalendarWeekIndicatorView.WeekIndicatorConfig

    // MARK: - Lifecycle
    init(config: XWHCalendarWeekIndicatorView.WeekIndicatorConfig) {
        self.config = config
        super.init(frame: .zero)
        self.configureUI()
        self.configureSubviews()
        self.configureConstaints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reloadIndicatorData() {
        if stackView.arrangedSubviews.count != curWeekDates.count {
            return
        }
        
        let inIndex = indicatorIndex
        let cr = contentHeight / 2
        
        let norFont = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        let norColor = fontDarkColor
        
        let inFont = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        
        let futureColor = fontDarkColor.withAlphaComponent(0.35)
        for (i, iView) in stackView.arrangedSubviews.enumerated() {
            guard let iLabel = iView as? UILabel else {
                return
            }
            
            let iDate = curWeekDates[i]
            
            if let iIndex = inIndex, iIndex == i {
                iLabel.font = inFont
                if iDate.isInFuture {
                    iLabel.textColor = futureColor
                } else {
                    iLabel.textColor = norColor
                }
                iView.layer.cornerRadius = cr
                iView.layer.backgroundColor = UIColor.white.cgColor
            } else {
                iLabel.font = norFont
                if iDate.isInFuture {
                    iLabel.textColor = futureColor
                } else {
                    iLabel.textColor = norColor
                }
                iView.layer.cornerRadius = 0
                iView.layer.backgroundColor = nil
            }
        }
    }

    // MARK: - Configuration
    private func configureUI() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
    }

    private func configureSubviews() {
        let weekDays = getWeekDays()
        for weekdaySimbol in weekDays {
            let cLabel = makeWeekLabel(for: weekdaySimbol)
            self.stackView.addArrangedSubview(cLabel)
            cLabel.snp.makeConstraints { make in
                make.height.equalTo(contentHeight)
            }
        }
        self.addSubview(self.stackView)
    }

    func makeWeekLabel(for simbol: String) -> UILabel {
        let label = UILabel()
        label.text = self.config.uppercaseWeekName ? simbol.uppercased() : simbol
        label.font = self.config.textFont
        label.textColor = self.config.textColor
        label.textAlignment = .center
        return label
    }

    private func configureConstaints() {
        self.stackView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.left.right.equalToSuperview()
        }
    }
    
    private func getWeekDays() -> [String] {
        let weekDays = [R.string.xwhHealthyText.日(), R.string.xwhHealthyText.一(), R.string.xwhHealthyText.二(), R.string.xwhHealthyText.三(), R.string.xwhHealthyText.四(), R.string.xwhHealthyText.五(), R.string.xwhHealthyText.六()]
        
        let weekRawValue = config.firstDayOfWeek.rawValue - 1
        var nextWeekDays = weekDays[weekRawValue...]
        let preWeekDays = weekDays[0..<weekRawValue]
        nextWeekDays.append(contentsOf: preWeekDays)
        
        return [String](nextWeekDays)
    }

}


extension XWHCalendarWeekIndicatorView {
    
    public struct WeekIndicatorConfig {
        public var firstDayOfWeek: DaysOfWeek = .monday
        public var backgroundColor: UIColor = bgColor
        public var textColor: UIColor = fontLightColor
        public var textFont: UIFont = XWHFont.harmonyOSSans(ofSize: 13, weight: .regular)
//        public var height: CGFloat = 20
        public var cornerRadius: CGFloat = 0
        public var uppercaseWeekName: Bool = true
    }
    
}
