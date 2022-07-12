//
//  SportCountdownView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/11.
//

import UIKit

class SportCountdownView: UIView {
    
    lazy var beginNum = 3
    
    lazy var numLbl: UILabel = {
        
        let label = UILabel()
        
        label.font = XWHFont.harmonyOSSans(ofSize: 160, weight: .bold)
        
        label.text = beginNum.string
        
        label.textColor = .white
        
        label.textAlignment = .center
        
        addSubview(label)
        
        return label
    }()
    
    var closure:(() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        countdown()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
        countdown()
    }
    
}

// MARK: - UI
extension SportCountdownView {
    
    func configUI() {
        
        backgroundColor = btnBgColor
        
        numLbl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}


// MARK: - Method
extension SportCountdownView {
    
    func countdown() {
        //语音播报开关
//        let isVoice = mmkv?.bool(forKey: voiceBroadcastKey, defaultValue: true) ?? true
//
//        HFTTSPlayer.shared.needActive = true

        var num = beginNum
        
        // 在global线程里创建一个时间源
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        // 设定这个时间源是每秒循环一次，立即开始
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        // 设定时间源的触发事件
        timer.setEventHandler(handler: {
            // 返回主线程处理一些事件，更新UI等等
            DispatchQueue.main.async {
                // 时间到了取消时间源
                if num <= 0 {
//                    if isVoice {
//                        HFTTSPlayer.shared.speak(content: R.string.ropeSkipping.开始())
//                    }
                    
                    timer.cancel()
                    
                    DispatchQueue.main.async {
                        self.numLbl.text = "GO"
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.numLbl.text = ""
                        self.stopAnimation()
                        self.stopCountdown()
                        //                        HFTTSPlayer.shared.needActive = false
                    }
                } else {
//                    if isVoice {
//                        HFTTSPlayer.shared.speak(content: num.string)
//                    }
                    self.numLbl.text = num.string
//                    self.numLbl.font = R.font.fitdockfontRegular(size: 200)
                }
                // 每秒计时一次
                num -= 1
            }
        })
        
        // 启动时间源
        timer.resume()
        
        startAnimation()
    }
    
    /// 放大动画
    func startAnimation() {
        let duration: CFTimeInterval = 1
        
        // Scale animation
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        
        scaleAnimation.keyTimes = [0, 0.5, 1]
        scaleAnimation.values = [1, 1.5, 2]
        scaleAnimation.duration = duration
        
        // Opacity animation
        let opacityAnimaton = CAKeyframeAnimation(keyPath: "opacity")
        
        opacityAnimaton.keyTimes = [0, 0.5, 1]
        opacityAnimaton.values = [1, 0.5, 0]
        opacityAnimaton.duration = duration
        
        // Animation
        let animation = CAAnimationGroup()
        
        animation.animations = [scaleAnimation, opacityAnimaton]
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = duration
        animation.repeatCount = HUGE
        animation.isRemovedOnCompletion = false
        
        numLbl.layer.add(animation, forKey: "animation")
    }
    
    
    func stopAnimation() {
        numLbl.layer.removeAnimation(forKey: "animation")
    }
    
    func stopCountdown() {
        removeFromSuperview()
        closure?()
    }
    
}

