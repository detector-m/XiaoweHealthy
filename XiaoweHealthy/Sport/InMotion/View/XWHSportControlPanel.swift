//
//  XWHSportControlPanel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/28.
//

import UIKit
import AMPopTip

class XWHSportControlPanel: XWHBaseView {
    
    typealias XWHActionCompletion = (() -> Void)
        
    lazy var gpsSignalView = XWHGPSSignalView()
    
    lazy var settingBtn = UIButton()
    lazy var foldBtn = UIButton()
    
    lazy var valueLb = UILabel()
    
    lazy var timeIcon = UIImageView()
    lazy var timeTitleLb = UILabel()
    lazy var timeValueLb = UILabel()
    
    lazy var calIcon = UIImageView()
    lazy var calTitleLb = UILabel()
    lazy var calValueLb = UILabel()
    
    lazy var paceIcon = UIImageView()
    lazy var paceTitleLb = UILabel()
    lazy var paceValueLb = UILabel()
    
    lazy var heartIcon = UIImageView()
    lazy var heartTitleLb = UILabel()
    lazy var heartValueLb = UILabel()
    
    lazy var lockBtn = UIButton()
    lazy var voiceBtn = UIButton()
    
    /// 暂停
    lazy var pauseBtn = UIButton()
    
    /// 停止
    lazy var stopBtn = LongPressButton(frame: CGRect(x: 0, y: 0, width: longPressBtnSize, height: longPressBtnSize))
    
    /// 继续
    lazy var continueBtn = UIButton()
    
    /// 解锁
    lazy var unlockBnt = LongPressButton(frame: CGRect(x: 0, y: 0, width: longPressBtnSize, height: longPressBtnSize))
    
    /// 弹出tip
    lazy private var popTip = PopTip()
    
    /// 设置回调
    var settingsCompletion: XWHActionCompletion?
    
    /// 折叠回调
    var foldCompletion: XWHActionCompletion?
    
    /// 停止回调
    var stopCompletion: XWHActionCompletion?
    
    /// 暂停回调
    var pauseCompletion: XWHActionCompletion?
    
    /// 继续回调
    var continueCompletion: XWHActionCompletion?
    
    /// 解锁回调
    var unlockCompletion: XWHActionCompletion?
    
    
    /// 点击声音回调
    var voiceCompletion: XWHActionCompletion?
    
    private var longPressBtnSize: CGFloat {
        return 118
    }

    private(set) lazy var openImage: UIImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowDown.rawValue, size: 24, color: fontDarkColor)
    private(set) lazy var closeImage: UIImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowUp.rawValue, size: 24, color: fontDarkColor)
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(gpsSignalView)
        addSubview(settingBtn)
        addSubview(foldBtn)
        
        addSubview(valueLb)
        
        addSubview(timeIcon)
        addSubview(timeTitleLb)
        addSubview(timeValueLb)
        
        addSubview(calIcon)
        addSubview(calTitleLb)
        addSubview(calValueLb)
        
        addSubview(paceIcon)
        addSubview(paceTitleLb)
        addSubview(paceValueLb)
        
        addSubview(heartIcon)
        addSubview(heartTitleLb)
        addSubview(heartValueLb)
        
        addSubview(lockBtn)
        addSubview(voiceBtn)
        
        addSubview(pauseBtn)
        
        addSubview(stopBtn)
        
        addSubview(continueBtn)
        addSubview(unlockBnt)
        
        settingBtn.setImage(R.image.sport_setting(), for: .normal)
        settingBtn.addTarget(self, action: #selector(clickSettingsBtn), for: .touchUpInside)
        
        foldBtn.setImage(openImage, for: .normal)
        foldBtn.setImage(closeImage, for: .selected)
        foldBtn.addTarget(self, action: #selector(clickFoldBtn), for: .touchUpInside)
        
        valueLb.textAlignment = .center
        
        timeIcon.image = R.image.sport_time_icon()
        calIcon.image = R.image.sport_cal_icon()
        paceIcon.image = R.image.sport_pace_control_icon()
        heartIcon.image = R.image.sport_heart_icon()
        
        
        config(titleLabel: timeTitleLb)
        config(valueLabel: timeValueLb)

        
        config(titleLabel: calTitleLb)
        config(valueLabel: calValueLb)
        
        
        config(titleLabel: paceTitleLb)
        config(valueLabel: paceValueLb)
        
        
        config(titleLabel: heartTitleLb)
        config(valueLabel: heartValueLb)
        
        timeTitleLb.text = "总计时长"
        calTitleLb.text = "消耗千卡"
        paceTitleLb.text = "平均配速"
        heartTitleLb.text = "心率"
        
        lockBtn.setImage(R.image.sport_lock_icon(), for: .normal)
        voiceBtn.setImage(R.image.sport_voice_icon(), for: .normal)
        voiceBtn.setImage(R.image.sport_voice_close_icon(), for: .selected)
        
        config(pauseBtn: pauseBtn)
        config(stopBtn: stopBtn)
        config(continueBtn: continueBtn)
        config(unlockBtn: unlockBnt)
        
        configNormalControlPanel()
        
        configPopTip()
        
        lockBtn.addTarget(self, action: #selector(clickLockBtn), for: .touchUpInside)
        voiceBtn.addTarget(self, action: #selector(clickVoiceBtn), for: .touchUpInside)
        pauseBtn.addTarget(self, action: #selector(clickPauseBtn), for: .touchUpInside)
        continueBtn.addTarget(self, action: #selector(clickContinueBtn), for: .touchUpInside)
        
        gpsSignalView.tapAction = { [unowned self] in
            self.showGPSTip()
        }
    }
    
    override func relayoutSubViews() {
        foldBtn.snp.remakeConstraints { make in
            make.size.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(16)
        }
        
        gpsSignalView.snp.remakeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.height.equalTo(24)
            make.width.lessThanOrEqualTo(60)
        }
        
        settingBtn.snp.remakeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalTo(foldBtn)
            make.right.equalToSuperview().inset(16)
        }
        
        valueLb.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(44)
            make.height.equalTo(84)
        }
        
        
        timeValueLb.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(57)
            make.width.equalTo(120)
            make.top.equalToSuperview().offset(153)
            make.height.equalTo(40)
        }
        timeIcon.snp.remakeConstraints { make in
            make.left.equalTo(timeValueLb)
            make.top.equalTo(timeValueLb.snp.bottom).offset(11)
            make.size.equalTo(13)
        }
        timeTitleLb.snp.remakeConstraints { make in
            make.left.equalTo(timeIcon.snp.right).offset(2)
            make.right.equalTo(timeValueLb)
            make.height.equalTo(18)
            make.centerY.equalTo(timeIcon)
        }
        
        
        calValueLb.snp.remakeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(50)
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(153)
            make.height.equalTo(40)
        }
        calIcon.snp.remakeConstraints { make in
            make.left.equalTo(calValueLb)
            make.top.equalTo(calValueLb.snp.bottom).offset(11)
            make.size.equalTo(13)
        }
        calTitleLb.snp.remakeConstraints { make in
            make.left.equalTo(calIcon.snp.right).offset(2)
            make.right.equalTo(calValueLb)
            make.height.equalTo(18)
            make.centerY.equalTo(calIcon)
        }
        
        
        paceValueLb.snp.remakeConstraints { make in
            make.left.right.height.equalTo(timeValueLb)
            make.top.equalTo(timeTitleLb.snp.bottom).offset(8)
        }
        paceIcon.snp.remakeConstraints { make in
            make.left.equalTo(paceValueLb)
            make.top.equalTo(paceValueLb.snp.bottom).offset(11)
            make.size.equalTo(13)
        }
        paceTitleLb.snp.remakeConstraints { make in
            make.left.equalTo(paceIcon.snp.right).offset(2)
            make.right.equalTo(paceValueLb)
            make.height.equalTo(18)
            make.centerY.equalTo(paceIcon)
        }
        
        heartValueLb.snp.remakeConstraints { make in
            make.left.right.height.equalTo(calValueLb)
            make.top.equalTo(paceValueLb)
        }
        heartIcon.snp.remakeConstraints { make in
            make.left.equalTo(heartValueLb)
            make.top.equalTo(heartValueLb.snp.bottom).offset(11)
            make.size.equalTo(13)
        }
        heartTitleLb.snp.remakeConstraints { make in
            make.left.equalTo(heartIcon.snp.right).offset(2)
            make.right.equalTo(heartValueLb)
            make.height.equalTo(18)
            make.centerY.equalTo(heartIcon)
        }
        
        relayoutNormalControlPanel()
        relayoutLockControlPanel()
        relayoutPauseControlPanel()
    }
    
    
    /// 正常情况控制面板
    private func relayoutNormalControlPanel() {
        pauseBtn.snp.remakeConstraints { make in
            make.size.equalTo(94)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(340)
        }
        
        lockBtn.snp.remakeConstraints { make in
            make.size.equalTo(46)
            make.centerY.equalTo(pauseBtn)
            make.right.equalTo(self.snp.centerX).offset(-38 - 37)
        }
        
        voiceBtn.snp.remakeConstraints { make in
            make.size.equalTo(46)
            make.centerY.equalTo(pauseBtn)
            make.left.equalTo(self.snp.centerX).offset(38 + 37)
        }
    }
    
    /// 锁定控制面板
    private func relayoutLockControlPanel() {
        unlockBnt.snp.remakeConstraints { make in
            make.size.equalTo(longPressBtnSize)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(340 - 12)
        }
    }
    
    ///  暂停控制面板
    private func relayoutPauseControlPanel() {
        continueBtn.snp.remakeConstraints { make in
            make.size.equalTo(94)
            make.right.equalTo(self.snp.centerX).offset(-36)
            make.top.equalToSuperview().offset(340)
        }
        
        stopBtn.snp.remakeConstraints { make in
            make.size.equalTo(longPressBtnSize)
            make.left.equalTo(self.snp.centerX).offset(36 - 12)
            make.top.equalToSuperview().offset(340 - 12)
        }
    }
    
    /// 折叠控制面板
    private func relayoutFoldControlPanel() {
        timeValueLb.snp.remakeConstraints { make in
            make.right.equalToSuperview().inset(25)
            make.width.equalTo(120)
            make.top.equalToSuperview().offset(62)
            make.height.equalTo(40)
        }
        timeIcon.snp.remakeConstraints { make in
            make.left.equalTo(timeValueLb)
            make.top.equalTo(timeValueLb.snp.bottom).offset(4)
            make.size.equalTo(13)
        }
        timeTitleLb.snp.remakeConstraints { make in
            make.left.equalTo(timeIcon.snp.right).offset(2)
            make.right.equalTo(timeValueLb)
            make.height.equalTo(18)
            make.centerY.equalTo(timeIcon)
        }
        
        valueLb.snp.remakeConstraints { make in
            make.left.equalToSuperview().inset(25)
            make.right.equalTo(timeValueLb.snp.left).offset(-15)
            make.top.equalToSuperview().offset(44)
            make.height.equalTo(84)
        }
    }
    
    // MARK: - Actions
    @objc private func clickSettingsBtn() {
        settingsCompletion?()
    }
    
    @objc private func clickFoldBtn() {
        foldBtn.isSelected = !foldBtn.isSelected
        if foldBtn.isSelected {
            relayoutFoldControlPanel()
            
            configFoldControlPanel()
        } else {
            relayoutSubViews()
            
            configNormalControlPanel()
        }
        
        foldCompletion?()
    }
    
    @objc private func clickLockBtn() {
        configLockControlPanel()
    }
    
    @objc private func clickVoiceBtn() {

    }
    
    @objc func clickPauseBtn() {
        relayoutSubViews()
        configPauseControlPanel()
        
        pauseCompletion?()
    }
    
    @objc func clickContinueBtn() {
        relayoutSubViews()

        configNormalControlPanel()
        
        continueCompletion?()
    }
    
    private func configNormalControlPanel() {
        settingBtn.isHidden = false
        foldBtn.isHidden = false
        
        pauseBtn.isHidden = false
        lockBtn.isHidden = false
        voiceBtn.isHidden = false
        
        stopBtn.isHidden = true
        continueBtn.isHidden = true
        
        unlockBnt.isHidden = true
        
        configUnfoldLbs()
    }
    
    private func configLockControlPanel() {
        settingBtn.isHidden = false
        foldBtn.isHidden = true

        pauseBtn.isHidden = true
        lockBtn.isHidden = true
        voiceBtn.isHidden = true
        
        stopBtn.isHidden = true
        continueBtn.isHidden = true
        
        unlockBnt.isHidden = false
        
        configUnfoldLbs()
    }
    
    private func configPauseControlPanel() {
        settingBtn.isHidden = false
        foldBtn.isHidden = true
        
        pauseBtn.isHidden = true
        lockBtn.isHidden = true
        voiceBtn.isHidden = true
        
        stopBtn.isHidden = false
        continueBtn.isHidden = false
        
        unlockBnt.isHidden = true
        
        configUnfoldLbs()
    }
    
    private func configFoldControlPanel() {
        settingBtn.isHidden = true
        foldBtn.isHidden = false
        
        pauseBtn.isHidden = true
        lockBtn.isHidden = true
        voiceBtn.isHidden = true
        
        stopBtn.isHidden = true
        continueBtn.isHidden = true
        
        unlockBnt.isHidden = true
        
        configFoldLbs()
    }
    
    private func configFoldLbs() {
        foldBtn.isSelected = true

        timeIcon.isHidden = false
        timeTitleLb.isHidden = false
        timeValueLb.isHidden = false
        
        calIcon.isHidden = true
        calTitleLb.isHidden = true
        calValueLb.isHidden = true
        
        paceIcon.isHidden = true
        paceTitleLb.isHidden = true
        paceValueLb.isHidden = true
        
        heartIcon.isHidden = true
        heartTitleLb.isHidden = true
        heartValueLb.isHidden = true
    }
    
    private func configUnfoldLbs() {
        foldBtn.isSelected = false
        
        timeIcon.isHidden = false
        timeTitleLb.isHidden = false
        timeValueLb.isHidden = false
        
        calIcon.isHidden = false
        calTitleLb.isHidden = false
        calValueLb.isHidden = false
        
        paceIcon.isHidden = false
        paceTitleLb.isHidden = false
        paceValueLb.isHidden = false
        
        heartIcon.isHidden = false
        heartTitleLb.isHidden = false
        heartValueLb.isHidden = false
    }
    
    func update(sportModel: XWHSportModel) {
        let value = (sportModel.distance.double / 1000).rounded(numberOfDecimalPlaces: 2, rule: .down).string
        let unit = " 公里"
        
        let text = value + unit
        valueLb.attributedText = text.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 60, weight: .bold)], toOccurrencesOf: value).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)], toOccurrencesOf: unit)
        
        
        let bDate = Date().dayBegin.adding(.second, value: sportModel.duration)
        
        timeValueLb.text = bDate.string(withFormat: XWHDate.timeAllFormat)
        calValueLb.text = sportModel.cal.string
        
        var pace: Double = 0
        if sportModel.distance > 0 {
            pace = sportModel.duration.double / sportModel.distance.double
            pace *= 1000
        }
        
        paceValueLb.text = "\(pace.int / 60)'\(pace.int % 60)\""
        
        if sportModel.heartRate > 0 {
            heartValueLb.text = sportModel.heartRate.string
        } else if sportModel.avgHeartRate > 0 {
            heartValueLb.text = sportModel.avgHeartRate.string
        } else {
            heartValueLb.text = "--"
        }
    }
    
    func updateGPSSingal(_ gpsSignal: Double) {
        gpsSignalView.update(XWHSportFunction.getGpsLevel(gpsSignal: gpsSignal))
    }

}

extension XWHSportControlPanel {
    
    private func config(titleLabel: UILabel) {
        let titleFont = XWHFont.harmonyOSSans(ofSize: 13, weight: .regular)
        let titleColor = fontDarkColor.withAlphaComponent(0.4)
                
        titleLabel.font = titleFont
        titleLabel.textColor = titleColor
        titleLabel.textAlignment = .left
    }
    
    private func config(valueLabel: UILabel) {
        let valueFont = XWHFont.harmonyOSSans(ofSize: 28, weight: .bold)
        
        valueLabel.font = valueFont
        valueLabel.textColor = fontDarkColor
        valueLabel.textAlignment = .left
    }
    
    private func config(pauseBtn: UIButton) {
        pauseBtn.setTitleColor(.white, for: .normal)
        pauseBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 15, weight: .regular)
        pauseBtn.adjustsImageWhenHighlighted  = false
        pauseBtn.size = CGSize(width: 94, height: 94)
        pauseBtn.set(image: R.image.sport_pause_icon(), title: "暂停", titlePosition: .bottom, additionalSpacing: 2, state: .normal)
        pauseBtn.layer.cornerRadius = 47
        pauseBtn.layer.backgroundColor = btnBgColor.cgColor
    }
    
    private func config(continueBtn: UIButton) {
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 15, weight: .regular)
        continueBtn.adjustsImageWhenHighlighted  = false
        continueBtn.size = CGSize(width: 94, height: 94)
        continueBtn.set(image: R.image.sport_continue_icon(), title: "继续", titlePosition: .bottom, additionalSpacing: 2, state: .normal)
        continueBtn.layer.cornerRadius = 47
        continueBtn.layer.backgroundColor = btnBgColor.cgColor
    }
    
    private func config(stopBtn: LongPressButton) {
//        let cSize = CGSize(width: 94, height: 94)
        let color = UIColor(hex: 0xE35E2C)!

        stopBtn.innerButn.setTitleColor(.white, for: .normal)
        stopBtn.innerButn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 15, weight: .regular)
        stopBtn.innerButn.adjustsImageWhenHighlighted  = false
        stopBtn.innerButn.set(image: R.image.sport_stop_icon(), title: "长按结束", titlePosition: .bottom, additionalSpacing: 2, state: .normal)
        stopBtn.innerButn.layer.cornerRadius = longPressBtnSize / 2 * 0.8
        stopBtn.innerButn.layer.backgroundColor = color.cgColor
        
        stopBtn.progressView.trackColor = color.withAlphaComponent(0.1)
        stopBtn.progressView.set(colors: color)
        
        stopBtn.completion = { [unowned self] in
            self.stopCompletion?()
        }
        
//        stopBtn.progressView.size = cSize
    }
    
    private func config(unlockBtn: LongPressButton) {
        let color = btnBgColor

        unlockBtn.innerButn.setTitleColor(.white, for: .normal)
        unlockBtn.innerButn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 15, weight: .regular)
        unlockBtn.innerButn.adjustsImageWhenHighlighted  = false
        unlockBtn.innerButn.set(image: R.image.sport_unlock_icon(), title: "长按解锁", titlePosition: .bottom, additionalSpacing: 2, state: .normal)
        unlockBtn.innerButn.layer.cornerRadius = longPressBtnSize / 2 * 0.8
        unlockBtn.innerButn.layer.backgroundColor = color.cgColor
        
        unlockBtn.progressView.trackColor = color.withAlphaComponent(0.1)
        unlockBtn.progressView.set(colors: color)
        
        unlockBtn.completion = { [unowned self] in
            self.configNormalControlPanel()
            self.unlockCompletion?()
        }
    }
    
    private func configPopTip() {
        popTip.bubbleColor = btnBgColor
        popTip.font = XWHFont.harmonyOSSans(ofSize: 8, weight: .regular)
        popTip.textColor = .white
    }
    
}

extension XWHSportControlPanel {
    
    func showGPSTip() {
        popTip.show(text: "GPS信号较弱时，将由计步器估算", direction: .down, maxWidth: 140, in: self, from: gpsSignalView.frame, duration: 10)
    }
    
}
