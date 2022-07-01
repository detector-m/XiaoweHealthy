//
//  XWHSportInMotionVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/28.
//

import UIKit
import CoreLocation
import CoreMotion

/// 运动中
class XWHSportInMotionVC: XWHBaseVC {
    
    lazy var mapView = UIView()
    
    /// 控制面板
    lazy var controlPanel = XWHSportControlPanel()
    
    private var panelHeight: CGFloat {
        return 508
    }
    
    private lazy var sportModel: XWHSportModel = {
        let _sportModel = XWHSportModel()
        _sportModel.uuid = UUID().uuidString
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
    lazy var locationManager: AppLocationManager = {
        let _locationManager = AppLocationManager.shared
        _locationManager.delegate = self
        
        return _locationManager
    }()
    /// 运动步数管理器
    lazy var stepManager: AppPedometerManager = {
        let _stepManager = AppPedometerManager.shared
        _stepManager.delegate = self
        
        return _stepManager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        controlPanel.update(sportModel: sportModel)
        DispatchQueue.main.async { [weak self] in
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
        
        configEvent()
    }
    
    override func relayoutSubViews() {
        mapView.frame = view.bounds
        
        controlPanel.frame = CGRect(x: 0, y: view.height - panelHeight, width: view.width, height: panelHeight)
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
        if sportModel.distance < 150 {
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
        
        postSport()
        dismiss(animated: true)
    }
    
}

// MARK: - 运动控制
extension XWHSportInMotionVC {
    
    func start() {
        timeManager.start()
        locationManager.start()
        stepManager.start()
    }
    
    func stop() {
        timeManager.stop()
        locationManager.stop()
        stepManager.stop()
    }
    
    func pause() {
        timeManager.pause()
        locationManager.stop()
        stepManager.pause()
    }
    
    func resume() {
        timeManager.resume()
        locationManager.start()
        stepManager.resume()
    }
    
}


extension XWHSportInMotionVC: TimeManagerProtocol {
    
    func clockTick(time: Int) {
        sportModel.duration = time
        controlPanel.update(sportModel: sportModel)
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
            } else {
                lastItem = XWHSportEachPartSportModel()
                sportModel.eachPartItems.append(lastItem)
                lastItem.startMileage = sportModel.distance
            }
        } else {
            lastItem = XWHSportEachPartSportModel()
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
    
    private func postSport() {
        XWHServerDataManager.postSport(deviceMac: sportModel.identifier, deviceSn: sportModel.mac, data: [sportModel])
    }
    
}
