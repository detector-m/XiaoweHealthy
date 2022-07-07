//
//  XWHSportStartVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/23.
//

import UIKit

class XWHSportStartVC: XWHBaseVC {
    
    var sportType: XWHSportType = .none
    
    lazy var totalBtn = UIButton()
    lazy var totalArrowBtn = UIButton()
    
    lazy var totalLb = UILabel()
    
    //当前位置
    lazy var currentLocationRepresentation: MAUserLocationRepresentation = {
        let r = MAUserLocationRepresentation()
        r.showsAccuracyRing = true //精度圈是否显示
        r.fillColor = btnBgColor.withAlphaComponent(0.2) //精度圈填充颜色
        r.strokeColor = btnBgColor //调整精度圈边线颜色
        r.lineWidth = 2
        r.showsHeadingIndicator = true //是否显示蓝点方向指向
        r.locationDotBgColor = btnBgColor
        r.locationDotFillColor = UIColor.white
//        r.image = UIImage(named: "gps_icon") //定位图标, 与蓝色原点互斥
        return r
    }()
    
    lazy var mapView: MAMapView = MAMapView(frame: .zero)
    
    lazy var locationBtn = UIButton()
    lazy var goBtn = UIButton()
    lazy var settingBtn = UIButton()
    
    lazy var gpsSignalView = XWHGPSSignalView()

    var sportTotalRecord: XWHSportTotalRecordModel?
    
    private var curLocation: MAUserLocation?
    
    deinit {
        mapView.delegate = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configMapView()
        update()
        getSportTotalRecord()
    }

    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        navigationItem.title = sportType.name
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(totalBtn)
        view.addSubview(totalArrowBtn)
        
        view.addSubview(totalLb)
        
        view.addSubview(mapView)
        
        view.addSubview(locationBtn)
        view.addSubview(goBtn)
        view.addSubview(settingBtn)
        
        view.addSubview(gpsSignalView)

        totalBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .regular)
        totalBtn.setTitleColor(fontDarkColor.withAlphaComponent(0.4), for: .normal)
        let btnTitle = sportType.name + "总距离"
        totalBtn.setTitle(btnTitle, for: .normal)
        totalBtn.addTarget(self, action: #selector(clickTotalBtn), for: .touchUpInside)
        
        let tImage = UIImage.iconFont(text: XWHIconFontOcticons.arrowRight.rawValue, size: 12, color: fontDarkColor.withAlphaComponent(0.2))
        totalArrowBtn.setImage(tImage, for: .normal)
        totalArrowBtn.addTarget(self, action: #selector(clickTotalBtn), for: .touchUpInside)
        
        mapView.layer.cornerRadius = 16
        mapView.layer.backgroundColor = collectionBgColor.cgColor
        
        locationBtn.setImage(R.image.gps_current(), for: .normal)
        locationBtn.layer.cornerRadius = 25
        locationBtn.adjustsImageWhenHighlighted = false
        locationBtn.layer.backgroundColor = UIColor.white.cgColor
        locationBtn.addTarget(self, action: #selector(clickLocationBtn), for: .touchUpInside)
        
        settingBtn.setImage(R.image.sport_setting(), for: .normal)
        settingBtn.layer.cornerRadius = 25
        settingBtn.layer.backgroundColor = UIColor.white.cgColor
        settingBtn.addTarget(self, action: #selector(clickSettingBtn), for: .touchUpInside)
        
        goBtn.layer.cornerRadius = 47
        goBtn.layer.backgroundColor = btnBgColor.cgColor
        goBtn.addTarget(self, action: #selector(clickGoBtn), for: .touchUpInside)
        goBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 25, weight: .black)
        goBtn.setTitleColor(UIColor.white, for: .normal)
        goBtn.setTitle("GO", for: .normal)
    }
    
    private func configMapView() {
        mapView.backgroundColor = .white
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.showsScale = false
        mapView.userTrackingMode = .follow
        mapView.allowsBackgroundLocationUpdates = true
        mapView.distanceFilter = 5
        mapView.setZoomLevel(17, animated: false)
//        mapView.customizeUserLocationAccuracyCircleRepresentation = true
//        mapView.compassOrigin = CGPoint(x: 20, y: 100)
//        mapView.mapRectThatFits(mapView.visibleMapRect, edgePadding: UIEdgeInsets)
        mapView.showsCompass = false
        
        mapView.screenAnchor = CGPoint(x: 0.5, y: 0.4)
        mapView.isRotateEnabled = false
        mapView.isRotateCameraEnabled = false
        
        mapView.update(currentLocationRepresentation)
    }
    
    @objc private func clickTotalBtn() {
        gotoSportRecordList()
    }
    
    @objc private func clickLocationBtn() {
        guard let curLoc = curLocation?.location else {
            return
        }
        updateMapCoordinateRegion(location: curLoc)
        mapView.screenAnchor = CGPoint(x: 0.5, y: 0.4)
    }
    
    @objc private func clickSettingBtn() {
        gotoSportSettings()
    }
    
    @objc private func clickGoBtn() {
        gotoStartSport()
    }
    
    override func relayoutSubViews() {
        totalBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
            make.height.equalTo(17)
        }
        totalArrowBtn.snp.makeConstraints { make in
            make.left.equalTo(totalBtn.snp.right).offset(2)
            make.centerY.height.equalTo(totalBtn)
        }

        
        totalLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(totalBtn.snp.bottom).offset(6)
            make.height.equalTo(44)
        }
        
        mapView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(totalLb.snp.bottom).offset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
        }
        
        gpsSignalView.snp.makeConstraints { make in
            make.left.top.equalTo(mapView).inset(16)
            make.height.equalTo(16)
            make.width.lessThanOrEqualTo(60)
        }
        
        goBtn.snp.makeConstraints { make in
            make.size.equalTo(94)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(mapView).offset(-63)
        }
        
        locationBtn.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.centerY.equalTo(goBtn)
            make.right.equalTo(goBtn.snp.left).offset(-30)
        }
        
        settingBtn.snp.makeConstraints { make in
            make.size.equalTo(50)
            make.centerY.equalTo(goBtn)
            make.left.equalTo(goBtn.snp.right).offset(30)
        }
    }
    
    private func update() {
        let unit = " 公里"
        let distance = XWHSportDataHelper.mToKm(sportTotalRecord?.distance ?? 0)
        let value = distance.string
        
        let text = value + unit
        let valueFont = XWHFont.harmonyOSSans(ofSize: 40, weight: .bold)
        let unitFont = XWHFont.harmonyOSSans(ofSize: 13, weight: .bold)
        totalLb.attributedText = text.colored(with: fontDarkColor).applying(attributes: [.font: valueFont], toOccurrencesOf: value).applying(attributes: [.font: unitFont], toOccurrencesOf: unit)
    }

}

// MARK: - MAMapDelegate
extension XWHSportStartVC: MAMapViewDelegate {
    
    func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        guard let newLocation = userLocation.location else {
            return
        }
        
        if curLocation == nil {
//            updateMapCoordinateRegion(location: newLocation)
//            mapView.update(currentLocationRepresentation)
        }
        curLocation = userLocation
        
//        let howRecent = newLocation.timestamp.timeIntervalSinceNow
        let horizontalAccuracy = newLocation.horizontalAccuracy
        
        gpsSignalView.update(XWHSportFunction.getGpsLevel(gpsSignal: horizontalAccuracy))
    }
    
}

// MARK: - For Map
extension XWHSportStartVC {
    
    private func updateMapCoordinateRegion(location: CLLocation) {
        let span = MACoordinateSpanMake(0.00423, 0.00425)

        // 设置地图中心点
    //        mapView.setCenter(newLocation.coordinate, animated: true)
        // 设置比例尺大小
        let region = MACoordinateRegionMake(location.coordinate, span)
//        mapView.region = MACoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
    
}

// MARK: - Api
extension XWHSportStartVC {
    
    private func getSportTotalRecord() {
        XWHSportVM().getSportTotalRecord(type: sportType) { [weak self] error in
            log.error(error)
            guard let self = self else {
                return
            }
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
        } successHandler: { [weak self] response in
            guard let self = self else {
                return
            }
            guard let retModel = response.data as? XWHSportTotalRecordModel else {
                log.debug("运动 - 所有运动总结数据为空")
                return
            }
            
            self.sportTotalRecord = retModel
            self.update()
        }

    }
    
}

// MARK: - Jump UI
extension XWHSportStartVC {
    
    /// 开始运动
    private func gotoStartSport() {
        let vc = XWHSportInMotionVC()
        vc.sportType = sportType
        
        let nav = XWHBaseNavigationVC(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    /// 运动记录列表
    private func gotoSportRecordList() {
        let vc = XWHSportRecordListTBVC()
        vc.sSportType = sportType
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 运动设置
    private func gotoSportSettings() {
        let vc = XWHSportSettingsTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
