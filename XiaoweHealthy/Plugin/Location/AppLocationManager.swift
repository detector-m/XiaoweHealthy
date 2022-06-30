//
//  AppLocationManager.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/24.
//

import Foundation
import CoreLocation

protocol AppLocationManagerProtocol: AnyObject {
    
    func locationManager(_ manager: AppLocationManager, didUpdateLocations locations: [CLLocation])
    
}

/// 定位管理器
class AppLocationManager: NSObject {
    
    /// 授权回调
    typealias LocationAuthorizationStatusHandler = (_ isEnable: Bool, _ authStatus: CLAuthorizationStatus) -> Void
    
    static let shared = AppLocationManager()
    private static let kIsLocationAuthorizedKey = "IsLocationAuthorizedKey"
    
    /// 是否请求过定位权限
    static var isAuthorized: Bool {
        getIsAuthorized()
    }
    
    fileprivate lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.activityType = .fitness
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 5
        manager.allowsBackgroundLocationUpdates = true
        manager.pausesLocationUpdatesAutomatically = true
        manager.showsBackgroundLocationIndicator = true

        manager.delegate = self
        
        return manager
    }()
    
    /// 代理
    weak var delegate: AppLocationManagerProtocol?
    
    /// 定位是否打开
    var isEnable: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    /// 定位授权状态
    private(set) lazy var authStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
    
    /// 当前位置经纬度,为nil时使用updateLocation方法获取最新值
    var lastLocation: CLLocation? {
        locationManager.location
    }
    
    /// 是否正在定位
    lazy private var isRunning = false

    ///  一次性授权回调
    var oneTimeAuthStatusHandler: LocationAuthorizationStatusHandler?
    
}

extension AppLocationManager {
    
    private class func setIsAuthorized(_ isSet: Bool) {
        UserDefaults.standard.set(isSet, forKey: kIsLocationAuthorizedKey)
    }
    
    private class func getIsAuthorized() -> Bool {
        UserDefaults.standard.bool(forKey: kIsLocationAuthorizedKey)
    }
    
    /// 请求一次性定位权限
    func requestAuthorizationOneTime(completion: LocationAuthorizationStatusHandler?) {
        if !isEnable {
            completion?(false, authStatus)
            
            return
        }
        
        switch authStatus {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            oneTimeAuthStatusHandler = completion
            
        default:
            completion?(true, authStatus)
            oneTimeAuthStatusHandler = nil
        }
    }
    
    /// 停止定位
    func stop() {
        locationManager.stopUpdatingLocation()
        isRunning = false
    }
    
    /// 开始定位
    func start() {
        if !isEnable {
            return
        }
        
        locationManager.startUpdatingLocation()
        isRunning = true
    }
    
}


// MARK: - CLLocationManagerDelegate
extension AppLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authStatus = status
        
        log.info("当前定位权限\(status.rawValue)(0:未授权 1:设备不支持 2:拒绝 3:始终 4:使用期间)")
        
        oneTimeAuthStatusHandler?(true, authStatus)
        if authStatus != .notDetermined {
            oneTimeAuthStatusHandler = nil
        }
        
        Self.setIsAuthorized(true)
    }
    
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ = locations.last else {
            return
        }
        if !isRunning {
            return
        }

//        locationClosure?(location)
        delegate?.locationManager(self, didUpdateLocations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        log.error("定位出错:\(error.localizedDescription)")
    }
    
}


extension CLAuthorizationStatus {

    var isAuthorized: Bool {
        if self == .authorizedWhenInUse || self == .authorizedAlways {
            return true
        }

        return false
    }

}
