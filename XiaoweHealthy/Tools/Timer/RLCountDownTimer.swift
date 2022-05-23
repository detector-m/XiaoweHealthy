//
//  RLCountDownTimer.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/23.
//

import Foundation

class RLCountDownTimer {
    
    private(set) var timer: Repeater?
    
    private(set) var count: Int = 60
    private(set) var curCount: Int = 60
    
    deinit {
        timer?.pause()
    }
    
    func createTimer(tCount: Int = 60, handler: @escaping (() -> ())) {
        count = tCount
        curCount = tCount
        
        let mode: Repeater.Mode = .finite(count)
        timer = Repeater(interval: .seconds(1), mode: mode, tolerance: .nanoseconds(0), queue: nil, observer: { [weak self] _ in
            
            guard let self = self else {
                return
            }
            
            DispatchQueue.main.async {
                self.curCount -= 1
                
                handler()
                
                if self.curCount <= 0 {
                    self.curCount = self.count
                    self.timer?.reset(nil, restart: false)
                }
            }
        })
    }
    
}
