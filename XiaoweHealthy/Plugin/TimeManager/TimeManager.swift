//
//  TimeManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/30.
//

import Foundation


protocol TimeManagerProtocol: AnyObject {
    
    func clockTick(time: Int)
    
}

/// 时间管理器
class TimeManager {
    
    weak var delegate: TimeManagerProtocol?
    
    /// 总的时间（s）
    private(set) var totalTime: Int = 0
    
    /// 有效时间 （s）
    private(set) var validTime: Int = 0
    
    /// timer启动的绝对时间（s）
    private var absoluteTimerStartTime = 0
    
    /// 开始的绝对时间（s）
    private var absoluteStartTime = 0
    
    /// 暂停的绝对时间 （s）
    private var absolutePauseTime = 0
    
    /// 暂停的时间
//    private var pauseTime: Int = 0
    
    private var timer: Timer?
    
//    deinit {
//        
//    }
    
    init() {
        
    }
    
    init(delegate: TimeManagerProtocol) {
        self.delegate = delegate
    }
    
    func start() {
        absoluteStartTime = CFAbsoluteTimeGetCurrent().int
        
        startTimer()
    }
    
    func stop() {
        stopTimer()
        
        totalTime = 0
        validTime = 0

        absoluteStartTime = 0
    }
    
    func pause() {
        guard let _ = timer else {
            return
        }
        
        absolutePauseTime = CFAbsoluteTimeGetCurrent().int
        
        let cTime = CFAbsoluteTimeGetCurrent().int
        let cValidTime = cTime - absoluteTimerStartTime
        validTime += cValidTime

        stopTimer()
    }
    
    func resume() {
        absolutePauseTime = 0

        startTimer()
    }
    
    private func startTimer() {
        absoluteTimerStartTime = CFAbsoluteTimeGetCurrent().int
        
        timer = Timer(timeInterval: 1, target: self, selector: #selector(clockTick(sender:)), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    private func stopTimer() {
        
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func clockTick(sender: Timer) {
        if absoluteTimerStartTime == 0 || absoluteStartTime == 0 {
            return
        }
        
        let cTime = CFAbsoluteTimeGetCurrent().int
        let cValidTime = cTime - absoluteTimerStartTime
        
        totalTime = cTime - absoluteStartTime
        
        delegate?.clockTick(time: validTime + cValidTime)
    }
    
}
