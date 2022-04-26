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

    // MARK: - Configuration

    private func configureUI() {
        self.backgroundColor = self.config.backgroundColor
        self.layer.cornerRadius = self.config.cornerRadius
    }

    private func configureSubviews() {
        let weekDays = getWeekDays()
        for weekdaySimbol in weekDays {
            self.stackView.addArrangedSubview(self.makeWeekLabel(for: weekdaySimbol))
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
        public var firstDayOfWeek: DaysOfWeek = .sunday
        public var backgroundColor: UIColor = bgColor
        public var textColor: UIColor = fontLightColor
        public var textFont: UIFont = XWHFont.harmonyOSSans(ofSize: 13, weight: .regular)
//        public var height: CGFloat = 20
        public var cornerRadius: CGFloat = 0
        public var uppercaseWeekName: Bool = true
    }
    
}
