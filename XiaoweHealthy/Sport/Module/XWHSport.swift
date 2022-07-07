//
//  XWHSport.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/7.
//

import Foundation


class XWHSport {
    
    private static var _shared = XWHSport.init()
    static var shared: XWHSport {
        return _shared
    }
    
    private var observers: [XWHSportObserverProtocol] = []
    
    private init() {
        
    }
    
    func addObserver(observer: XWHSportObserverProtocol) {
            observers.append(observer)
    }
        
    func removeObserver(observer: XWHSportObserverProtocol) {
        observers.removeFirst(where: { $0 === observer })
    }
    
    func notifyAllObserverUpdate() {
        for observer in observers {
            observer.reloadOrUpdate()
        }
    }
    
}

