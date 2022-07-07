//
//  XWHSportInMotionVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/28.
//

import UIKit
import CoreLocation
import CoreMotion
import SwiftUI

/// 运动中
class XWHSportInMotionVC: XWHBaseVC {
    
    lazy var mapView = MAMapView(frame: .zero)
    
    /// 控制面板
    lazy var controlPanel = XWHSportControlPanel()
    
    private var panelHeight: CGFloat {
        return 508
    }
    
    lazy var sportType = XWHSportType.none
    
    private lazy var sportModel: XWHSportModel = {
        let _sportModel = XWHSportModel()
        _sportModel.uuid = UUID().uuidString
        _sportModel.type = sportType
        if let conDev = XWHDeviceDataManager.getCurrentDevice() {
            _sportModel.identifier = conDev.identifier
            _sportModel.mac = conDev.mac
        }
        
        return _sportModel
    }()
    
    // MARK: - 运动控制
    /// 时间管理器
    lazy var timeManager = TimeManager(delegate: self)
    /// 定位管理器
//    lazy var locationManager: AppLocationManager = {
//        let _locationManager = AppLocationManager.shared
//        _locationManager.delegate = self
//
//        return _locationManager
//    }()
    /// 运动步数管理器
    lazy var stepManager: AppPedometerManager = {
        let _stepManager = AppPedometerManager.shared
        _stepManager.delegate = self
        
        return _stepManager
    }()
    
    deinit {
        mapView.delegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlPanel.update(sportModel: sportModel)
        DispatchQueue.main.async { [weak self] in
            self?.sportModel.bTime = Date().string(withFormat: XWHDate.standardTimeAllFormat)
            self?.start()
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        relayoutSubViews()
    }
    
    override func setupNavigationItems() {
//        super.setupNavigationItems()
        setNavTransparent()
    }
    
    override func clickNavGlobalBackBtn() {
        navigationController?.dismiss(animated: true)
    }
    
    override func addSubViews() {
        view.addSubview(mapView)
        view.addSubview(controlPanel)
        
        mapView.backgroundColor = btnBgColor
        
        controlPanel.layer.cornerRadius = 16
        controlPanel.layer.backgroundColor = UIColor.white.cgColor
        controlPanel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        configMapView()
        configEvent()
    }
    
    private func configMapView() {
        mapView.backgroundColor = .white
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsScale = false
        mapView.userTrackingMode = .follow
        mapView.allowsBackgroundLocationUpdates = true
        mapView.distanceFilter = 5
        mapView.desiredAccuracy = kCLLocationAccuracyBest
        mapView.setZoomLevel(17, animated: false)
//        mapView.customizeUserLocationAccuracyCircleRepresentation = true
//        mapView.compassOrigin = CGPoint(x: 20, y: 100)
//        mapView.mapRectThatFits(mapView.visibleMapRect, edgePadding: UIEdgeInsets)
        mapView.showsCompass = false
        
        mapView.screenAnchor = CGPoint(x: 0.5, y: 0.4)
        mapView.isRotateEnabled = false
        mapView.isRotateCameraEnabled = false
        
        //当前位置
        let r = MAUserLocationRepresentation()
        r.showsAccuracyRing = true //精度圈是否显示
        r.fillColor = btnBgColor.withAlphaComponent(0.2) //精度圈填充颜色
        r.strokeColor = btnBgColor //调整精度圈边线颜色
        r.lineWidth = 2
        r.showsHeadingIndicator = true //是否显示蓝点方向指向
        r.locationDotBgColor = btnBgColor
        r.locationDotFillColor = UIColor.white
//        r.image = UIImage(named: "gps_icon") //定位图标, 与蓝色原点互斥
        
        mapView.update(r)
    }
    
    override func relayoutSubViews() {
        controlPanel.frame = CGRect(x: 0, y: view.height - panelHeight, width: view.width, height: panelHeight)
        
        mapView.frame = CGRect(x: 0, y: 0, width: view.width, height: controlPanel.y)
    }
    
    private func configEvent() {
        controlPanel.stopCompletion = { [unowned self] in
            self.stopSport()
        }
        
        controlPanel.pauseCompletion = { [unowned self] in
            self.pause()
        }
        
        controlPanel.continueCompletion = { [unowned self] in
            self.resume()
        }
        
        controlPanel.unlockCompletion = { [unowned self] in
            
        }
    }

}

extension XWHSportInMotionVC {
    
    private func stopSport() {
        if sportModel.distance < 100 {
            XWHAlert.show(title: nil, message: "本次运动距离太短，将不保存记录", messageAlignment: .center, cancelTitle: "知道了", confirmTitle: "继续运动") { [unowned self] aType in
                if aType == .confirm {
                    self.controlPanel.clickContinueBtn()
                } else {
                    self.stop()
                    self.dismiss(animated: true)
                }
            }
            
            return
        }
        
        stop()
        
        sportModel.eTime = Date().string(withFormat: XWHDate.standardTimeAllFormat)
        sportModel.eachPartItems.last?.eTime = sportModel.eTime
        if sportModel.step > 0 {
            sportModel.stepWidth = (sportModel.distance.double * 100 / sportModel.step.double).int
        }
        if sportModel.distance > 0, sportModel.duration > 0 {
            sportModel.pace = ((sportModel.duration.double / sportModel.distance.double) * 1000).int
            sportModel.speed = (sportModel.distance.double / sportModel.duration.double).int
            
            if sportModel.pace == 0 {
                sportModel.pace = 1
            }
            
            if sportModel.speed == 0 {
                sportModel.speed = 1
            }
        }
        
        postSport { [weak self] in
            guard let self = self else {
                return
            }
            self.dismiss(animated: true)
        }
    }
    
}

// MARK: - 运动控制
extension XWHSportInMotionVC {
    
    func start() {
        timeManager.start()
//        locationManager.start()
        stepManager.start()
        mapView.delegate = self
    }
    
    func stop() {
        timeManager.stop()
//        locationManager.stop()
        stepManager.stop()
        mapView.delegate = nil
    }
    
    func pause() {
        timeManager.pause()
//        locationManager.stop()
        stepManager.pause()
        mapView.delegate = nil
    }
    
    func resume() {
        timeManager.resume()
//        locationManager.start()
        stepManager.resume()
        mapView.delegate = self
    }
    
}


extension XWHSportInMotionVC: TimeManagerProtocol {
    
    func clockTick(time: Int) {
        sportModel.duration = time
        controlPanel.update(sportModel: sportModel)
    }
    
}

extension XWHSportInMotionVC: MAMapViewDelegate {
    
    func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        guard let newLocation = userLocation.location else {
            return
        }
        
        let howRecent = newLocation.timestamp.timeIntervalSinceNow
        let horizontalAccuracy = newLocation.horizontalAccuracy
        
        controlPanel.updateGPSSingal(horizontalAccuracy)
        
        guard horizontalAccuracy < 70 && abs(howRecent) < 10 else {
            return
        }
        
//        if let lastLocation = sportModel.locations.last {
//            let delta = newLocation.distance(from: lastLocation)
//            sportModel.distance = sportModel.distance + delta.int
//            sportModel.cal = XWHSportFunction.getCal(sportTime: sportModel.duration, distance: sportModel.distance)
//        }
//
//        sportModel.locations.append(newLocation)
        
        var tmpLastLocation: CLLocation?
        var lastItem: XWHSportEachPartSportModel
        if let lastSportItem = sportModel.eachPartItems.last {
            tmpLastLocation = lastSportItem.locations.last
            
            if let lastLocation = tmpLastLocation {
                let delta = newLocation.distance(from: lastLocation)
                if delta == 0 {
                    return
                }
                sportModel.distance = sportModel.distance + delta.int
                sportModel.cal = XWHSportFunction.getCal(sportTime: sportModel.duration, distance: sportModel.distance)
            }
            
            if sportModel.distance <= lastSportItem.startMileage + 1000 {
                lastItem = lastSportItem
                lastItem.endMileage = sportModel.distance
                lastItem.eTime = Date().string(withFormat: XWHDate.standardTimeAllFormat)
            } else {
                lastItem = XWHSportEachPartSportModel()
                lastItem.bTime = Date().string(withFormat: XWHDate.standardTimeAllFormat)
                sportModel.eachPartItems.append(lastItem)
                lastItem.startMileage = sportModel.distance
            }
            
            if lastItem.endMileage > 0 {
                var lastDuration = 0
                if let lastETime = lastItem.eTime.date(withFormat: XWHDate.standardTimeAllFormat), let lastBTime = lastItem.bTime.date(withFormat: XWHDate.standardTimeAllFormat) {
                    lastDuration = lastETime.timeIntervalSince1970.int - lastBTime.timeIntervalSince1970.int
                }
                
                if lastDuration < 0 {
                    lastDuration = 0
                }
                
                lastItem.duration = lastDuration
                lastItem.distance = lastItem.endMileage - lastItem.startMileage
                
                lastItem.pace = ((lastItem.duration.double / lastItem.distance.double) * 1000).int
                if lastItem.pace == 0 {
                    lastItem.pace = 1
                }
            }
        } else {
            lastItem = XWHSportEachPartSportModel()
            lastItem.bTime = Date().string(withFormat: XWHDate.standardTimeAllFormat)
            sportModel.eachPartItems.append(lastItem)
            lastItem.startMileage = sportModel.distance
        }
        
        lastItem.locations.append(newLocation)
        lastItem.coordinates.append(newLocation.coordinate)
    }
    
}

extension XWHSportInMotionVC: AppLocationManagerProtocol {
    
    func locationManager(_ manager: AppLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        
        let howRecent = newLocation.timestamp.timeIntervalSinceNow
        let horizontalAccuracy = newLocation.horizontalAccuracy
        
        controlPanel.updateGPSSingal(horizontalAccuracy)
        
        guard horizontalAccuracy < 60 && abs(howRecent) < 10 else {
            return
        }
        
//        if let lastLocation = sportModel.locations.last {
//            let delta = newLocation.distance(from: lastLocation)
//            sportModel.distance = sportModel.distance + delta.int
//            sportModel.cal = XWHSportFunction.getCal(sportTime: sportModel.duration, distance: sportModel.distance)
//        }
//
//        sportModel.locations.append(newLocation)
        
        var tmpLastLocation: CLLocation?
        var lastItem: XWHSportEachPartSportModel
        if let lastSportItem = sportModel.eachPartItems.last {
            tmpLastLocation = lastSportItem.locations.last
            if sportModel.distance <= lastSportItem.startMileage + 1000 {
                lastItem = lastSportItem
                lastItem.endMileage = sportModel.distance
                lastItem.eTime = Date().string(withFormat: XWHDate.standardTimeAllFormat)
            } else {
                lastItem = XWHSportEachPartSportModel()
                lastItem.bTime = Date().string(withFormat: XWHDate.standardTimeAllFormat)
                sportModel.eachPartItems.append(lastItem)
                lastItem.startMileage = sportModel.distance
            }
            
            if lastItem.endMileage > 0 {
                var lastDuration = 0
                if let lastETime = lastItem.eTime.date(withFormat: XWHDate.standardTimeAllFormat), let lastBTime = lastItem.bTime.date(withFormat: XWHDate.standardTimeAllFormat) {
                    lastDuration = lastETime.timeIntervalSince1970.int - lastBTime.timeIntervalSince1970.int
                }
                
                if lastDuration < 0 {
                    lastDuration = 0
                }
                
                lastItem.duration = lastDuration
                lastItem.distance = lastItem.endMileage - lastItem.startMileage
                
                lastItem.pace = ((lastItem.duration.double / lastItem.distance.double) * 1000).int
                if lastItem.pace == 0 {
                    lastItem.pace = 1
                }
            }
        } else {
            lastItem = XWHSportEachPartSportModel()
            lastItem.bTime = Date().string(withFormat: XWHDate.standardTimeAllFormat)
            sportModel.eachPartItems.append(lastItem)
            lastItem.startMileage = sportModel.distance
        }
        
        if let lastLocation = tmpLastLocation {
            let delta = newLocation.distance(from: lastLocation)
            sportModel.distance = sportModel.distance + delta.int
            sportModel.cal = XWHSportFunction.getCal(sportTime: sportModel.duration, distance: sportModel.distance)
        }
        
        lastItem.locations.append(newLocation)
        lastItem.coordinates.append(newLocation.coordinate)
    }
    
}

extension XWHSportInMotionVC: AppPedometerManagerProtocol {

    func update(stepCount: Int) {
        sportModel.step = stepCount
    }
    
}


// MARK: - Api
extension XWHSportInMotionVC {
    
    private func postSport(completion: @escaping () -> Void) {
        XWHProgressHUD.show()
        XWHServerDataManager.postSport(deviceMac: sportModel.identifier, deviceSn: sportModel.mac, data: [sportModel]) { [weak self] _ in
            XWHProgressHUD.hide()
            
            guard let _ = self else {
                return
            }
            
            completion()
        } successHandler: { [weak self] _ in
            XWHProgressHUD.hide()

            guard let _ = self else {
                return
            }
            
            completion()
            XWHSport.shared.notifyAllObserverUpdate()
        }
    }
    
}
