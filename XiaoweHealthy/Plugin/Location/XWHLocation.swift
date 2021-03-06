//
//  XWHLocation.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/14.
//

//import Foundation
//import CoreLocation
//
//
//class XWHLocation: NSObject {
//    
//    static let shared = XWHLocation()
//    
//    static let kLocationRequestAuthorizationKey = "LocationRequestAuthorizationKey"
//    
//    typealias XWHLocationEnableAndAuthorizationHandler = (_ isEnable: Bool, _ authStatus: CLAuthorizationStatus) -> Void
//    
//    fileprivate lazy var locationManager: CLLocationManager = {
//        let manager = CLLocationManager()
//        
//        manager.activityType = .fitness
//        
//        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        
//        manager.distanceFilter = 5
//        
//        manager.allowsBackgroundLocationUpdates = true
//        
//        manager.pausesLocationUpdatesAutomatically = false
//        
//        manager.delegate = self
//
//        manager.showsBackgroundLocationIndicator = true
//        
//        return manager
//    }()
//    
//    /// 获取到当前位置的回调
//    fileprivate var locationClosure: ((CLLocation) -> Void)?
//    
//    /// 定位失败回调
//    fileprivate var faileClosure: (() -> Void)?
//    
//    /// 授权状态回调
//    fileprivate var statusClosure: ((Bool) -> Void)?
//    
//    /// 定位开关和授权状态回调
//    private var locationEnableAndAuthorizationHandler: XWHLocationEnableAndAuthorizationHandler?
//    
//    /// 定位授权状态
//    lazy var locationStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
//    
//    
//    /// 是否正在定位
//    lazy private var isLocation = false
//    
//    /// 当前位置经纬度,为nil时使用updateLocation方法获取最新值
//    lazy var currentLocation = locationManager.location
//
//}
//
//// MARK: - Method
//
//extension XWHLocation {
//    
//    /// 是否请求过定位权限
//    class func isRequestedAuthorization() -> Bool {
//        UserDefaults.standard.bool(forKey: Self.kLocationRequestAuthorizationKey)
//    }
//    
//    /// 定位是否打开
//    func locationEnabled() -> Bool {
//        return CLLocationManager.locationServicesEnabled()
//    }
//    
//    /// 获取定位的状态
//    func checkState(completion:((Bool) -> Void)? = nil) {
//        if locationEnabled() {
//            switch locationStatus {
//            case .notDetermined:
//                requestAuthorization(completion: completion)
//                
//            case .authorizedAlways, .authorizedWhenInUse:
//                completion?(true)
//                statusClosure = nil
//                
//            default:
//                completion?(false)
//                statusClosure = nil
//            }
//        } else {
//            completion?(false)
//        }
//        
//    }
//    
//    /// 请求定位权限
//    func requestAuthorization(completion:((Bool) -> Void)? = nil) {
//        locationManager.requestAlwaysAuthorization()
//        statusClosure = completion
//    }
//    
//    /// 请求定位是否开启和权限
//    func requestLocationEnableAndAuthorize(handler: XWHLocationEnableAndAuthorizationHandler? = nil) {
//        if !locationEnabled() {
//            log.error("未开启定位功能")
//            
//            handler?(false, .denied)
//            
//            return
//        }
//        locationManager.requestAlwaysAuthorization()
//        locationEnableAndAuthorizationHandler = handler
//        
//        locationEnableAndAuthorizationHandler?(true, locationStatus)
//    }
//    
//    
//    /// 停止定位
//    func stopUpdatingLocation() {
//        locationManager.stopUpdatingLocation()
//        currentLocation = nil
//        isLocation = false
//    }
//    
//    /// 开始定位
//    func startUpdatingLocation() {
//        locationManager.startUpdatingLocation()
//        currentLocation = nil
//        isLocation = true
//    }
//    
//    /// 获取当前位置并回调经纬度
//    func updateLocation(closure: ((CLLocation) -> Void)?) {
//        startUpdatingLocation()
//        locationClosure = closure
//    }
//    
//    /// 定位失败
//    func locationFail(closure: (() -> Void)?) {
//        faileClosure = closure
//    }
//    
//}
//
//// MARK: - CLLocationManagerDelegate
//
//extension XWHLocation: CLLocationManagerDelegate {
//    
//    func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        locationStatus = status
//                
//        log.info("当前定位权限\(status.rawValue)(0:未授权 1:设备不支持 2:拒绝 3:始终 4:使用期间)")
//        
//        locationEnableAndAuthorizationHandler?(true, locationStatus)
//        
//        statusClosure?(locationStatus.isAuthorized)
//        statusClosure = nil
//        
//        UserDefaults.standard.set(true, forKey: Self.kLocationRequestAuthorizationKey)
//    }
//    
//    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {
//            return
//        }
//        if !isLocation {
//            return
//        }
//        currentLocation = location
//        
//        locationClosure?(location)
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        
//        log.error("定位出错:\(error.localizedDescription)")
//
//        faileClosure?()
//    }
//    
//}
