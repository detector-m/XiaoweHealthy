//
//  AppPedometerManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/1.
//

import Foundation
import CoreMotion


protocol AppPedometerManagerProtocol: AnyObject {
    
    func update(stepCount: Int)
    
}

/// 计步器管理器
class AppPedometerManager {
    
    public static var shared = AppPedometerManager()
    
    private let pedometer = CMPedometer()
    
    weak var delegate: AppPedometerManagerProtocol?
    
    var isStepCountingAvailable: Bool {
        CMPedometer.isStepCountingAvailable()
    }
    
    private(set) var validStep = 0
    private(set) var totalStep = 0
    
    func start() {
        validStep = 0
        totalStep = 0
        
        startPedometer()
    }
    
    func stop() {
        stopPedometer()
        
        validStep = 0
        totalStep = 0
    }
    
    func pause() {
        stopPedometer()
        
        validStep = totalStep
    }
    
    func resume() {
        startPedometer()
    }
    
    private func stopPedometer() {
        pedometer.stopUpdates()
    }
    
    private func startPedometer() {
        pedometer.startUpdates(from: Date()) { [weak self] (data, error) in
            guard let self = self else {
                return
            }
            
            guard let pedometerData = data else {
                log.error(error)
                return
            }
            
            self.totalStep = self.validStep + pedometerData.numberOfSteps.intValue
            self.delegate?.update(stepCount: self.totalStep)
        }
    }
    
    
}

//class AppPedometerManager {
//
//    public static var shared = AppPedometerManager()
//
//    private let pedometer = CMPedometer()
//
//    weak var delegate: AppPedometerManagerProtocol?
//
//    var isStepCountingAvailable: Bool {
//        CMPedometer.isStepCountingAvailable()
//    }
//
//    var isActivityAvailable: Bool {
//        CMMotionActivityManager.isActivityAvailable()
//    }
//
//    func stopPedometr() {
//        pedometer.stopUpdates()
//    }
//
//    func startPedometer() {
//        pedometer.startUpdates(from: Date()) { [weak self] (data, error) in
//            guard let self = self else {
//                return
//            }
//
//            guard let pedometerData = data else {
//                log.error(error)
//                return
//            }
//
//            self.delegate?.update(pedometerData: pedometerData)
//        }
//    }
//
//    func countSteps(completionHandler: @escaping (NSNumber?) -> Void) {
//        pedometer.startUpdates(from: Date()) { (data, error) in
//            DispatchQueue.main.async {
//                completionHandler(data?.numberOfSteps)
//            }
//        }
//    }
//
//    func stopActivity() {
//        activityManager.stopActivityUpdates()
//    }
//
//    func startActivity() {
//        activityManager.startActivityUpdates(to: OperationQueue.main) { [weak self] (data) in
//            guard let self = self else {
//                return
//            }
//
//            guard let activity = data else {
//                return
//            }
//
//            self.delegate?.update(motionActivity: activity)
//        }
//    }
//
//    func startTrackingActivity(completionHandler: @escaping (CMMotionActivity?) -> Void) {
//        activityManager.startActivityUpdates(to: OperationQueue.main) { (activity) in
//            DispatchQueue.main.async {
//                completionHandler(activity)
//            }
//        }
//    }
//
//    func distance(completionHandler: @escaping (NSNumber?) -> Void) {
//        pedometer.startUpdates(from: Date()) { (data, error) in
//            DispatchQueue.main.async {
//                completionHandler(data?.distance)
//            }
//        }
//    }
//
//    func currentPace(completionHandler: @escaping (NSNumber?)-> Void) {
//        pedometer.startUpdates(from: Date()) { (data, error) in
//            DispatchQueue.main.async {
//                completionHandler(data?.currentPace)
//            }
//        }
//    }
//
//    func ascendingFloors(completionHandler: @escaping (NSNumber?) -> Void) {
//        pedometer.startUpdates(from: Date()) { (data, error) in
//            DispatchQueue.main.async {
//                completionHandler(data?.floorsAscended)
//            }
//        }
//    }
//
//    func descendingFloors(completionHandler: @escaping (NSNumber?) -> Void) {
//        pedometer.startUpdates(from: Date()) { (data, error) in
//            DispatchQueue.main.async {
//                completionHandler(data?.floorsDescended)
//            }
//        }
//    }
//
//}
