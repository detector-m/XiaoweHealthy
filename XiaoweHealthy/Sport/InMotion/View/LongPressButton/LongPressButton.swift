//
//  LongPressButton.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/28.
//

import UIKit
import KDCircularProgress

class LongPressButton: UIView {
    
    let endTime: Double = 1.5
    lazy var innerButn = UIButton()
    lazy var progressView = KDCircularProgress()
    
    var completion: (() -> Void)?
    
    private lazy var curTime: Double = 0
    
    private lazy var longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(sender:)))
    private lazy var displayLink: CADisplayLink = {
        let _link = CADisplayLink(target: self, selector: #selector(runLink))
        _link.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
        _link.isPaused = true
        return _link
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let innerWidth = frame.width * 0.8
        let innerHeight = frame.height * 0.8
        innerButn.frame = CGRect(x: (frame.width - innerWidth) / 2, y: (frame.height - innerHeight) / 2, width: innerWidth, height: innerHeight)
        progressView.frame = frame
        addSubViews()
        
        self.addGestureRecognizer(longPress)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func addSubViews() {
        addSubview(progressView)
        addSubview(innerButn)
        
//        innerButn.isHidden = true
        config(progressView: progressView)
    }
    
    @objc private func longPressAction(sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            start()
            
        case .changed:
            break
            
        case .ended:
            stop()
            
        default:
            stop()
        }
    }
    
    @objc private func runLink() {
        curTime += 1 / 60
        
        let progress = 1 - (curTime / endTime)
        progressView.progress = progress
        
        if curTime >= endTime {
            stop()
            completion?()
        }
    }
    
    private func start() {
        curTime = 0
        
        progressView.progress = 1
        displayLink.isPaused = false
        
        UIView.animate(withDuration: 0.1) {
            self.innerButn.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
//        [UIView animateWithDuration:0.1
//                                     animations:^{
//                        self.endBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
//                    }completion:^(BOOL finish){
//
//                    }];

    }
    
    private func stop() {
        curTime = 0
        
        progressView.progress = 1
        displayLink.isPaused = true
        
        UIView.animate(withDuration: 0.1) {
            self.innerButn.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
}

extension LongPressButton {
    
    private func config(progressView: KDCircularProgress) {
        progressView.startAngle = -90
        progressView.progressThickness = 0.2
        progressView.trackThickness = 0.2
        progressView.clockwise = false
        progressView.gradientRotateSpeed = 0
        progressView.roundedCorners = true
        progressView.glowMode = .noGlow
        progressView.glowAmount = 1
    }
    
}
