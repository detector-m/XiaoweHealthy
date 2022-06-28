//
//  XWHSportControlPanel.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/28.
//

import UIKit

class XWHSportControlPanel: XWHBaseView {
        
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
    
    lazy var pauseBtn = UIButton()
    
    lazy var stopBtn = LongPressButton(frame: CGRect(x: 0, y: 0, width: longPressBtnSize, height: longPressBtnSize))
    
    var stopCompletion: (() -> Void)?
    
    private var longPressBtnSize: CGFloat {
        return 112
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
        
        settingBtn.setImage(R.image.sport_setting(), for: .normal)
        
        foldBtn.setImage(openImage, for: .normal)
        foldBtn.setImage(closeImage, for: .selected)
        
        valueLb.textAlignment = .center
        
        timeIcon.image = R.image.sport_time_icon()
        calIcon.image = R.image.sport_cal_icon()
        paceIcon.image = R.image.sport_pace_icon()
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
        
        pauseBtn.setTitleColor(.white, for: .normal)
        pauseBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 15, weight: .regular)
        pauseBtn.adjustsImageWhenHighlighted  = false
        pauseBtn.size = CGSize(width: 94, height: 94)
        pauseBtn.set(image: R.image.sport_pause_icon(), title: "暂停", titlePosition: .bottom, additionalSpacing: 2, state: .normal)
        pauseBtn.layer.cornerRadius = 47
        pauseBtn.layer.backgroundColor = btnBgColor.cgColor
        
        lockBtn.addTarget(self, action: #selector(clickLockBtn), for: .touchUpInside)
        voiceBtn.addTarget(self, action: #selector(clickVoiceBtn), for: .touchUpInside)
        pauseBtn.addTarget(self, action: #selector(clickPauseBtn), for: .touchUpInside)
        
        pauseBtn.isHidden = true
        
        config(stopBtn: stopBtn)
    }
    
    override func relayoutSubViews() {
        foldBtn.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(16)
        }
        
        gpsSignalView.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(16)
            make.height.equalTo(24)
            make.width.lessThanOrEqualTo(60)
        }
        
        settingBtn.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.centerY.equalTo(foldBtn)
            make.right.equalToSuperview().inset(16)
        }
        
        valueLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(44)
            make.height.equalTo(84)
        }
        
        
        timeValueLb.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(57)
            make.width.equalTo(120)
            make.top.equalToSuperview().offset(153)
            make.height.equalTo(40)
        }
        timeIcon.snp.makeConstraints { make in
            make.left.equalTo(timeValueLb)
            make.top.equalTo(timeValueLb.snp.bottom).offset(11)
            make.size.equalTo(13)
        }
        timeTitleLb.snp.makeConstraints { make in
            make.left.equalTo(timeIcon.snp.right).offset(2)
            make.right.equalTo(timeValueLb)
            make.height.equalTo(18)
            make.centerY.equalTo(timeIcon)
        }
        
        
        calValueLb.snp.makeConstraints { make in
            make.left.equalTo(self.snp.centerX).offset(50)
            make.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(153)
            make.height.equalTo(40)
        }
        calIcon.snp.makeConstraints { make in
            make.left.equalTo(calValueLb)
            make.top.equalTo(calValueLb.snp.bottom).offset(11)
            make.size.equalTo(13)
        }
        calTitleLb.snp.makeConstraints { make in
            make.left.equalTo(calIcon.snp.right).offset(2)
            make.right.equalTo(calValueLb)
            make.height.equalTo(18)
            make.centerY.equalTo(calIcon)
        }
        
        
        paceValueLb.snp.makeConstraints { make in
            make.left.right.height.equalTo(timeValueLb)
            make.top.equalTo(timeTitleLb.snp.bottom).offset(8)
        }
        paceIcon.snp.makeConstraints { make in
            make.left.equalTo(paceValueLb)
            make.top.equalTo(paceValueLb.snp.bottom).offset(11)
            make.size.equalTo(13)
        }
        paceTitleLb.snp.makeConstraints { make in
            make.left.equalTo(paceIcon.snp.right).offset(2)
            make.right.equalTo(paceValueLb)
            make.height.equalTo(18)
            make.centerY.equalTo(paceIcon)
        }
        
        heartValueLb.snp.makeConstraints { make in
            make.left.right.height.equalTo(calValueLb)
            make.top.equalTo(paceValueLb)
        }
        heartIcon.snp.makeConstraints { make in
            make.left.equalTo(heartValueLb)
            make.top.equalTo(heartValueLb.snp.bottom).offset(11)
            make.size.equalTo(13)
        }
        heartTitleLb.snp.makeConstraints { make in
            make.left.equalTo(heartIcon.snp.right).offset(2)
            make.right.equalTo(heartValueLb)
            make.height.equalTo(18)
            make.centerY.equalTo(heartIcon)
        }
        
        lockBtn.snp.makeConstraints { make in
            make.size.equalTo(46)
            make.top.equalToSuperview().offset(365)
            make.right.equalTo(self.snp.centerX).offset(-38 - 37)
        }
        
        voiceBtn.snp.makeConstraints { make in
            make.size.equalTo(46)
            make.top.equalToSuperview().offset(365)
            make.left.equalTo(self.snp.centerX).offset(38 + 37)
        }
        
        pauseBtn.snp.makeConstraints { make in
            make.size.equalTo(94)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(lockBtn)
        }
        
        stopBtn.snp.makeConstraints { make in
            make.size.equalTo(longPressBtnSize)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(340 - 9)
        }
    }
    
    @objc private func clickLockBtn() {
        
    }
    
    @objc private func clickVoiceBtn() {
        
    }
    
    @objc private func clickPauseBtn() {
        
    }
    
    func update() {
        let value = "12.98"
        let unit = " 公里"
        let text = value + unit
        valueLb.attributedText = text.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 60, weight: .bold)], toOccurrencesOf: value).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)], toOccurrencesOf: unit)
        
        timeValueLb.text = "00:00:45"
        calValueLb.text = "111"
        paceValueLb.text = "8'88\""
        heartValueLb.text = "122"
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
    
    private func config(stopBtn: LongPressButton) {
//        let cSize = CGSize(width: 94, height: 94)
        let color = UIColor(hex: 0xE35E2C)!

        stopBtn.innerButn.setTitleColor(.white, for: .normal)
        stopBtn.innerButn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 15, weight: .regular)
        stopBtn.innerButn.adjustsImageWhenHighlighted  = false
        stopBtn.innerButn.set(image: R.image.sport_pause_icon(), title: "长按结束", titlePosition: .bottom, additionalSpacing: 2, state: .normal)
        stopBtn.innerButn.layer.cornerRadius = longPressBtnSize / 2 * 0.8
        stopBtn.innerButn.layer.backgroundColor = color.cgColor
        
        stopBtn.progressView.trackColor = color.withAlphaComponent(0.1)
        stopBtn.progressView.set(colors: color)
        
        stopBtn.completion = { [unowned self] in
            self.stopCompletion?()
        }
        
//        stopBtn.progressView.size = cSize
    }
    
}
