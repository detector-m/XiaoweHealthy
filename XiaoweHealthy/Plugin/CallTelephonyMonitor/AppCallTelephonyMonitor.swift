//
//  AppCallTelephonyMonitor.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/14.
//

import Foundation
import CallKit


/// 电话状态监测
class AppCallTelephonyMonitor: NSObject, CXCallObserverDelegate {
    
    static let shared = AppCallTelephonyMonitor()
    lazy var callObserver: CXCallObserver = {
        let _callObserver = CXCallObserver()
        _callObserver.setDelegate(self, queue: DispatchQueue.main)
        
        return _callObserver
    }()
    
    typealias CallObserverClosure = (Bool) -> Void
    
    private var monitorClosure: CallObserverClosure?

    private override init() {
        
    }
    
    func monitor(completion: CallObserverClosure?) {
        monitorClosure = completion
    }
    
    // MARK: - CXCallObserverDelegate
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        print("outgoing :%d  onHold :%d   hasConnected :%d   hasEnded :%d", call.isOutgoing, call.isOnHold, call.hasConnected, call.hasEnded);
            /*
             拨打:  outgoing :1  onHold :0   hasConnected :0   hasEnded :0
             拒绝:  outgoing :1  onHold :0   hasConnected :0   hasEnded :1
             链接:  outgoing :1  onHold :0   hasConnected :1   hasEnded :0
             挂断:  outgoing :1  onHold :0   hasConnected :1   hasEnded :1
             对方未接听时挂断：  outgoing :1  onHold :0   hasConnected :0   hasEnded :1
             
             新来电话:    outgoing :0  onHold :0   hasConnected :0   hasEnded :0
             保留并接听:  outgoing :1  onHold :1   hasConnected :1   hasEnded :0
             另一个挂掉:  outgoing :0  onHold :0   hasConnected :1   hasEnded :0
             保持链接:    outgoing :1  onHold :0   hasConnected :1   hasEnded :1
             对方挂掉:    outgoing :0  onHold :0   hasConnected :1   hasEnded :1
             */
        
        monitorClosure?(!call.hasEnded)
    }
    
}

//import CoreTelephony

//class AppCallTelephonyMonitor {
//
//    static let shared = AppCallTelephonyMonitor()
//
//    lazy var callCenter = CTCallCenter()
//
//    typealias CallClosure = (Bool) -> Void
//
//    func monitor(completion:CallClosure?) {
//
//        callCenter.callEventHandler = { call in
//            completion?(call.callState == CTCallStateConnected)
//        }
//    }
//
//}
