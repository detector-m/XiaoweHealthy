//
//  XWHCodeView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/17.
//

import UIKit

class XWHCodeView: XWHTextFieldBaseView {
    
    var clickBtnCallback: (() -> Void)?
    private let countDownTimer: RLCountDownTimer = RLCountDownTimer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        countDownTimer.createTimer { [weak self] in
            guard let self = self else {
                return
            }
            
            if self.countDownTimer.curCount <= 0 {
                self.button.isEnabled = true
                self.button.setTitleColor(UIColor(hex: 0x000000, transparency: 0.6), for: .normal)
                self.button.setTitle(R.string.xwhDisplayText.获取验证码(), for: .normal)
            } else {
                self.button.isEnabled = false
                self.button.setTitleColor(UIColor(hex: 0x000000, transparency: 0.24), for: .normal)
                self.button.setTitle("\(self.countDownTimer.curCount)s", for: .normal)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        titleLb.isEnabled = true
        button.setTitle(R.string.xwhDisplayText.获取验证码(), for: .normal)
        button.titleLabel?.font = R.font.harmonyOS_Sans(size: 14)
        button.layer.cornerRadius = 14
        button.layer.backgroundColor = UIColor(hex: 0x000000, transparency: 0.04)?.cgColor
        button.setTitleColor(UIColor(hex: 0x000000, transparency: 0.6), for: .normal)
        
        textFiled.placeholder = R.string.xwhDisplayText.请输入验证码()
        textFiled.clearButtonMode = .never
        textFiled.keyboardType = .numberPad
    }
    
    override func relayoutSubViews() {
        button.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.width.equalTo(98)
            make.height.equalTo(28)
            make.centerY.equalToSuperview()
        }
        
        textFiled.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.right.equalTo(button.snp.left).offset(-8)
            make.centerY.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    @objc override func clickButton() {
        button.isEnabled = false
        countDownTimer.timer?.start()
        
        clickBtnCallback?()
    }

}
