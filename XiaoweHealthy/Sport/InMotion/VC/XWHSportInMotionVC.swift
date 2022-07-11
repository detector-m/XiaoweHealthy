//
//  XWHSportInMotionVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/28.
//

import UIKit
import CoreLocation
import CoreMotion
import CoreBluetooth


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
    
    private var isShowDisconnect = false
    
    private var isDeviceSport = false
    
    deinit {
        mapView.showsUserLocation = false
        mapView.allowsBackgroundLocationUpdates = false
        mapView.delegate = nil
        XWHDDMShared.removeSportHandlerDelegate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlPanel.update(sportModel: sportModel)
        DispatchQueue.main.async { [weak self] in
            self?.sportModel.bTime = Date().string(withFormat: XWHDate.standardTimeAllFormat)
            self?.start()
        }
        
        if XWHDevice.isDevConnectBind {
            isDeviceSport = true
            XWHDDMShared.addMonitorDelegate(self)
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
    
//    override func clickNavGlobalBackBtn() {
//        navigationController?.dismiss(animated: true)
//    }
    
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
        
//        mapView.screenAnchor = CGPoint(x: 0.5, y: 0.5)
        mapView.isRotateEnabled = false
        mapView.isRotateCameraEnabled = false
        
        //当前位置
        let r = MAUserLocationRepresentation()
        r.showsAccuracyRing = false //精度圈是否显示
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
        
        controlPanel.unlockCompletion = {
            
        }
    }
    
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if presentedViewController == nil {
            XWHDDMShared.removeMonitorDelegate(self)
        }
        
        if let vcs = navigationController?.viewControllers, !vcs.contains(self) {
            XWHDDMShared.removeMonitorDelegate(self)
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
                    XWHDDMShared.removeMonitorDelegate(self)
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
            XWHDDMShared.removeMonitorDelegate(self)
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
        sportModel.state = .start
        
        startDeviceSport()
    }
    
    func stop() {
        timeManager.stop()
//        locationManager.stop()
        stepManager.stop()
        mapView.delegate = nil
        
        sportModel.state = .stop
        
        stopDeviceSport()
    }
    
    func pause() {
        timeManager.pause()
//        locationManager.stop()
        stepManager.pause()
        mapView.delegate = nil
        
        sportModel.state = .pause
        
        pauseDeviceSport()
    }
    
    func resume() {
        timeManager.resume()
//        locationManager.start()
        stepManager.resume()
        mapView.delegate = self
        
        sportModel.state = .continue
        
        resumeDeviceSport()
    }
    
    func startDeviceSport() {
        if !XWHDevice.isDevConnectBind {
            return
        }
        
        XWHDDMShared.addSportHandlerDelegate(self)
        XWHDDMShared.sendSportState(sportModel: sportModel)
    }
    
    func stopDeviceSport() {
        if !XWHDevice.isDevConnectBind {
            return
        }
        
        XWHDDMShared.removeSportHandlerDelegate()
        XWHDDMShared.sendSportState(sportModel: sportModel)
    }
    
    func pauseDeviceSport() {
        if !XWHDevice.isDevConnectBind {
            return
        }
        XWHDDMShared.sendSportState(sportModel: sportModel)
    }
    
    func resumeDeviceSport() {
        if !XWHDevice.isDevConnectBind {
            return
        }
        
        XWHDDMShared.sendSportState(sportModel: sportModel)
    }
    
    private func sendSportInfoToDevice() {
        if !XWHDevice.isDevConnectBind {
            return
        }
        
        XWHDDMShared.sendSportInfo(sportModel)
    }
    
}


extension XWHSportInMotionVC: TimeManagerProtocol {
    
    func clockTick(time: Int) {
        sportModel.duration = time
        controlPanel.update(sportModel: sportModel)
        
        sendSportInfoToDevice()
    }
    
}

extension XWHSportInMotionVC: MAMapViewDelegate {
    
    func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        if !updatingLocation {
            return
        }
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
        
        // 绘制轨迹
        drawLocationPath()
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay?) -> MAOverlayRenderer? {
        guard let overlay = overlay else {
            return nil
        }
        
        if overlay.isKind(of: MAPolyline.self) {
            let renderer: MAPolylineRenderer = MAPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 3.0
            renderer.strokeColor = btnBgColor
            
            return renderer
        }
        
        return nil
    }
    
    private func drawLocationPath() {
        mapView.removeOverlays(mapView.overlays)
        var allCoordinates = sportModel.eachPartItems.flatMap({ $0.coordinates })
        let polyline: MAPolyline = MAPolyline(coordinates: &allCoordinates, count: UInt(allCoordinates.count))
        
        mapView.add(polyline)
    }
    
}

//extension XWHSportInMotionVC: AppLocationManagerProtocol {
//
//    func locationManager(_ manager: AppLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let newLocation = locations.last else {
//            return
//        }
//
//        let howRecent = newLocation.timestamp.timeIntervalSinceNow
//        let horizontalAccuracy = newLocation.horizontalAccuracy
//
//        controlPanel.updateGPSSingal(horizontalAccuracy)
//
//        guard horizontalAccuracy < 60 && abs(howRecent) < 10 else {
//            return
//        }
//
////        if let lastLocation = sportModel.locations.last {
////            let delta = newLocation.distance(from: lastLocation)
////            sportModel.distance = sportModel.distance + delta.int
////            sportModel.cal = XWHSportFunction.getCal(sportTime: sportModel.duration, distance: sportModel.distance)
////        }
////
////        sportModel.locations.append(newLocation)
//
//        var tmpLastLocation: CLLocation?
//        var lastItem: XWHSportEachPartSportModel
//        if let lastSportItem = sportModel.eachPartItems.last {
//            tmpLastLocation = lastSportItem.locations.last
//            if sportModel.distance <= lastSportItem.startMileage + 1000 {
//                lastItem = lastSportItem
//                lastItem.endMileage = sportModel.distance
//                lastItem.eTime = Date().string(withFormat: XWHDate.standardTimeAllFormat)
//            } else {
//                lastItem = XWHSportEachPartSportModel()
//                lastItem.bTime = Date().string(withFormat: XWHDate.standardTimeAllFormat)
//                sportModel.eachPartItems.append(lastItem)
//                lastItem.startMileage = sportModel.distance
//            }
//
//            if lastItem.endMileage > 0 {
//                var lastDuration = 0
//                if let lastETime = lastItem.eTime.date(withFormat: XWHDate.standardTimeAllFormat), let lastBTime = lastItem.bTime.date(withFormat: XWHDate.standardTimeAllFormat) {
//                    lastDuration = lastETime.timeIntervalSince1970.int - lastBTime.timeIntervalSince1970.int
//                }
//
//                if lastDuration < 0 {
//                    lastDuration = 0
//                }
//
//                lastItem.duration = lastDuration
//                lastItem.distance = lastItem.endMileage - lastItem.startMileage
//
//                lastItem.pace = ((lastItem.duration.double / lastItem.distance.double) * 1000).int
//                if lastItem.pace == 0 {
//                    lastItem.pace = 1
//                }
//            }
//        } else {
//            lastItem = XWHSportEachPartSportModel()
//            lastItem.bTime = Date().string(withFormat: XWHDate.standardTimeAllFormat)
//            sportModel.eachPartItems.append(lastItem)
//            lastItem.startMileage = sportModel.distance
//        }
//
//        if let lastLocation = tmpLastLocation {
//            let delta = newLocation.distance(from: lastLocation)
//            sportModel.distance = sportModel.distance + delta.int
//            sportModel.cal = XWHSportFunction.getCal(sportTime: sportModel.duration, distance: sportModel.distance)
//        }
//
//        lastItem.locations.append(newLocation)
//        lastItem.coordinates.append(newLocation.coordinate)
//    }
//
//}

extension XWHSportInMotionVC: AppPedometerManagerProtocol {

    func update(stepCount: Int) {
        sportModel.step = stepCount
    }
    
}

// MARK: - 运动数据回调
extension XWHSportInMotionVC: XWHDataFromDeviceInteractionProtocol {
    
    func receiveSportState(_ state: XWHSportState) {
        if sportModel.state == state {
            return
        }

        if !isDeviceSport {
            return
        }
        
        switch state {
        case .stop:
            stop()
            
        case .start:
            return
            
        case .pause:
            controlPanel.clickPauseBtn()
            
        case .continue:
            controlPanel.clickContinueBtn()
        }
    }
    
    func receiveSportHeartRate(_ hrs: [XWHHeartModel]) {
        sportModel.heartRate = hrs.last?.value ?? 0
        sportModel.heartRateList.append(contentsOf: hrs)
    }
    
}

// MARK: - XWHMonitorFromDeviceProtocol
extension XWHSportInMotionVC: XWHMonitorFromDeviceProtocol {
    
    func receiveBLEState(_ state: CBManagerState) {
        
    }
    
    func receiveConnectInfo(device: XWHDevWatchModel, connectState: XWHDeviceConnectBindState, error: XWHBLEError?) {
        if !isDeviceSport {
            return
        }
        
        if XWHDDMShared.connectBindState == .disconnected {
            XWHProgressHUD.hide()
            if sportModel.state == .stop {
                return
            }
            
            if isShowDisconnect {
                return
            }
            
            isShowDisconnect = true
            controlPanel.clickPauseBtn()
            XWHAlert.show(title: nil, message: "检测到手表设备已断开连接", messageAlignment: .center, cancelTitle: "继续运动", confirmTitle: "重新连接") { [weak self] aType in
                guard let self = self else {
                    return
                }
                self.isShowDisconnect = false
                if aType == .confirm {
                    self.isDeviceSport = true
                    XWHProgressHUD.show(title: "连接中...")
                    
                    XWHDevice.shared.connect()
                } else {
                    self.isDeviceSport = false
                }
            }
        } else if XWHDDMShared.connectBindState == .connected {
            XWHProgressHUD.hide()
        } else { // 连接中
            
        }
    }
    
    func receiveSyncDataStateInfo(syncState: XWHDevDataTransferState, progress: Int, error: XWHError?) {
        
    }
    
}


// MARK: - Api
extension XWHSportInMotionVC {
    
    private func postSport(completion: @escaping () -> Void) {
        XWHProgressHUD.show()
        if !sportModel.heartRateList.isEmpty {
            sportModel.avgHeartRate = sportModel.heartRateList.sum(for: \.value) / sportModel.heartRateList.count
        }
        
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
