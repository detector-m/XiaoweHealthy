//
//  XWHSportShareContentView.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/7/12.
//

import UIKit

class XWHSportShareContentView: XWHBaseView {
    
    lazy var mapView = MAMapView(frame: .zero)
    lazy var mapImageView = UIImageView()
    
    lazy var hSeparateLine1 = UIView()
    
    lazy var titleLb = UILabel()
    lazy var valueLb = UILabel()
    lazy var timeLb = UILabel()
    
    lazy var avatar = UIImageView()
    lazy var nicknameLb = UILabel()
    
    lazy var titleValueView1 = XWHTitleValueView()
    lazy var titleValueView2 = XWHTitleValueView()
    lazy var titleValueView3 = XWHTitleValueView()
    lazy var titleValueView4 = XWHTitleValueView()
    
    private var sportDetail: XWHSportModel?
    
    override func addSubViews() {
        super.addSubViews()
        
        addSubview(mapView)
        addSubview(mapImageView)
        
        addSubview(hSeparateLine1)
        
        addSubview(titleLb)
        addSubview(valueLb)
        addSubview(timeLb)
        
        addSubview(avatar)
        addSubview(nicknameLb)
        
        addSubview(titleValueView1)
        addSubview(titleValueView2)
        addSubview(titleValueView3)
        addSubview(titleValueView4)
        
        configMapView()
        
        hSeparateLine1.backgroundColor = UIColor(hex: 0x979797)!.withAlphaComponent(0.2)
        
        avatar.layer.cornerRadius = 25
        avatar.layer.masksToBounds = true
        avatar.contentMode = .scaleAspectFit
        
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 10, weight: .regular)
        titleLb.textColor = fontDarkColor
        titleLb.textAlignment = .left
                
        timeLb.font = XWHFont.harmonyOSSans(ofSize: 9, weight: .regular)
        timeLb.textColor = fontDarkColor.withAlphaComponent(0.4)
        timeLb.textAlignment = .right
        
        nicknameLb.font = XWHFont.harmonyOSSans(ofSize: 12, weight: .medium)
        nicknameLb.textAlignment = .right
        nicknameLb.textColor = fontDarkColor
        
        config(titleValueView: titleValueView1)
        config(titleValueView: titleValueView2)
        config(titleValueView: titleValueView3)
        config(titleValueView: titleValueView4)
        
        titleValueView1.textAlignment = .left
        titleValueView4.textAlignment = .right

        titleValueView1.titleLb.text = "总计时长"
        titleValueView2.titleLb.text = "消耗热量"
        titleValueView3.titleLb.text = "平均配速"
        titleValueView4.titleLb.text = "运动心率"
    }
    
    override func relayoutSubViews() {
        mapView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
            make.height.equalTo(210)
        }
        
        mapImageView.snp.makeConstraints { make in
            make.edges.equalTo(mapView)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.top.equalTo(mapView).offset(16)
            make.width.lessThanOrEqualTo(120)
            make.height.equalTo(15)
        }
        
        valueLb.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(18)
            make.top.equalTo(mapView.snp.bottom).offset(20)
            make.height.equalTo(40)
            make.right.equalTo(self.snp.centerX)
        }
        
        avatar.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(8)
            make.size.equalTo(50)
            make.right.equalToSuperview().inset(16)
        }
        
        nicknameLb.snp.makeConstraints { make in
            make.top.equalTo(avatar).offset(14)
            make.height.equalTo(17)
            make.right.equalTo(avatar.snp.left).offset(-5)
            make.width.lessThanOrEqualTo(100)
        }
        
        timeLb.snp.makeConstraints { make in
            make.top.equalTo(nicknameLb.snp.bottom).offset(4)
            make.height.equalTo(13)
            make.right.equalTo(nicknameLb)
            make.left.equalTo(self.snp.centerX).offset(2)
        }
        
        hSeparateLine1.snp.makeConstraints { make in
            make.height.equalTo(0.5)
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(self.snp.bottom).offset(-66)
        }
    }
    
    func relayoutForNormalTitleValues() {
        titleValueView4.isHidden = false
        titleValueView1.snp.makeConstraints { make in
            make.top.equalTo(hSeparateLine1.snp.bottom).offset(1)
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.25).offset(-10)
            make.height.equalTo(64)
        }

        titleValueView2.snp.makeConstraints { make in
            make.left.equalTo(titleValueView1.snp.right)
            make.top.width.height.equalTo(titleValueView1)
        }

        titleValueView3.snp.makeConstraints { make in
            make.height.width.top.equalTo(titleValueView2)
            make.left.equalTo(titleValueView2.snp.right)
        }

        titleValueView4.snp.makeConstraints { make in
            make.top.width.height.equalTo(titleValueView3)
            make.left.equalTo(titleValueView3.snp.right)
        }
    }
    
    func relayoutForNoHeartRate() {
        titleValueView4.isHidden = true
        titleValueView1.snp.makeConstraints { make in
            make.top.equalTo(hSeparateLine1.snp.bottom)
            make.left.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(0.33).offset(-14)
            make.height.equalTo(64)
        }

        titleValueView2.snp.makeConstraints { make in
            make.left.equalTo(titleValueView1.snp.right)
            make.top.width.height.equalTo(titleValueView1)
        }

        titleValueView3.snp.makeConstraints { make in
            make.height.width.top.equalTo(titleValueView2)
            make.left.equalTo(titleValueView2.snp.right)
        }
    }
    
    func update(sportDetail: XWHSportModel?) {
        if let user = XWHUserDataManager.getCurrentUser() {
            avatar.kf.setImage(with: user.avatar.url, placeholder: R.image.sport_avatar())
            nicknameLb.text = user.nickname
        }
        
        guard let sDetail = sportDetail else {
            return
        }
        
        self.sportDetail = sDetail
        
        drawLocationPath()
        
        var sTypeString = ""
        let sType = XWHSportHelper.getSportType(sportIndex: sDetail.intSportType)
        switch sType {
        case .none:
//            iconView.image = nil
            titleLb.text = ""
            
        case .run:
//            iconView.image = R.image.sport_run()
            sTypeString = R.string.xwhSportText.跑步()
            
        case .walk:
//            iconView.image = R.image.sport_walk()
            sTypeString = R.string.xwhSportText.步行()
            
        case .ride:
//            iconView.image = R.image.sport_ride()
            sTypeString = R.string.xwhSportText.骑行()
            
        case .climb:
//            iconView.image = R.image.sport_climb()
            sTypeString = R.string.xwhSportText.爬山()
            
        case .other:
            sTypeString = R.string.xwhSportText.其他()
        }
        
        let sportDate = sDetail.eTime.date(withFormat: XWHDate.standardTimeAllFormat) ?? Date()
        timeLb.text = sportDate.localizedString(withFormat: XWHDate.yearMonthDayHourMinuteFormat)
        
        titleLb.text = "小维健康·\(sTypeString)"
        
        let value = XWHSportDataHelper.mToKm(sDetail.distance).string
        let unit = " 公里"
        let text = value + unit
        valueLb.attributedText = text.colored(with: fontDarkColor).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 40, weight: .bold)], toOccurrencesOf: value).applying(attributes: [.font: XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)], toOccurrencesOf: unit)
        
        
        titleValueView1.valueLb.text = XWHSportHelper.getDurationString(sDetail.duration)
        titleValueView2.valueLb.text = sDetail.cal.string
        
        titleValueView3.valueLb.text = XWHSportHelper.getPaceString(sDetail.pace)
        
        if sDetail.heartRate > 0 {
            titleValueView3.textAlignment = .center
            titleValueView4.valueLb.text = sDetail.heartRate.string
            relayoutForNormalTitleValues()
        } else if sDetail.avgHeartRate > 0 {
            titleValueView3.textAlignment = .center
            titleValueView4.valueLb.text = sDetail.avgHeartRate.string
            relayoutForNormalTitleValues()
        } else {
            titleValueView3.textAlignment = .right
            titleValueView4.valueLb.text = "--"
            relayoutForNoHeartRate()
        }
    }
    
    func getScreenshot(completion: @escaping (UIImage?) -> Void) {
        if mapImageView.image != nil {
            completion(screenshot)
            return
        }
        mapView.takeSnapshot(in: mapView.bounds) { [weak self] mapImage, _ in
            self?.mapImageView.image = mapImage
            self?.mapView.isHidden = true
            
            completion(self?.screenshot)
        }
    }
}

extension XWHSportShareContentView: MAMapViewDelegate {
    
    func mapViewRequireLocationAuth(_ locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay?) -> MAOverlayRenderer? {
        guard let overlay = overlay else {
            return nil
        }
        
        if overlay.isKind(of: MAMultiPolyline.self) {
            let renderer: MAMultiColoredPolylineRenderer = MAMultiColoredPolylineRenderer(overlay: overlay)
            renderer.lineWidth = 3.0
            renderer.strokeColors = [UIColor(hex: 0x74C39E)!, UIColor(hex: 0xFECA4F)!]
            renderer.isGradient = true
            
            return renderer
        }
        
        return nil
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        let pointReuseIndetifier = "pointReuseIndetifier"
        var annotationView: XWHLocationAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as? XWHLocationAnnotationView
        
        if annotationView == nil {
            annotationView = XWHLocationAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
        }
        
        config(annotationView: annotationView!, annotation: annotation)
        
        annotationView!.canShowCallout = false
        annotationView!.isDraggable = false
        
        return annotationView!
    }
    
    private func drawLocationPath() {
        mapView.removeOverlays(mapView.overlays)
        guard let sportModel = sportDetail else {
            return
        }
        var allCoordinates = sportModel.eachPartItems.flatMap({ $0.coordinates })
        if allCoordinates.isEmpty {
//            mapView.setCenter(mapView.userLocation.coordinate, animated: true)
            return
        }
        
        let cCount: Int = allCoordinates.count
        let polyline: MAMultiPolyline = MAMultiPolyline(coordinates: &allCoordinates, count: UInt(cCount), drawStyleIndexes: [NSNumber(0), NSNumber(value: cCount - 1)])
        
        mapView.add(polyline)
//        let centerCoordinate = allCoordinates[cCount / 2]
        mapView.setCenter(polyline.coordinate, animated: true)
        
        addAnnotations()
    }

    private func addAnnotations() {
        if let f = sportDetail?.eachPartItems.first?.coordinates.first {
            addAnnotation(coordinate: f)
        }
        if let l = sportDetail?.eachPartItems.last?.coordinates.last {
            addAnnotation(coordinate: l)
        }
    }
    
    private func addAnnotation(coordinate: CLLocationCoordinate2D) {
        let annotation: MAPointAnnotation = MAPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
    }
    
    private func config(annotationView: XWHLocationAnnotationView, annotation: MAAnnotation) {
        if let f = sportDetail?.eachPartItems.first?.coordinates.first {
            if annotation.coordinate.latitude == f.latitude, annotation.coordinate.longitude == f.longitude {
                annotationView.image = R.image.location_start()
                annotationView.textLb.text = ""
                
//                annotationView.image = R.image.gps_icon()
//                annotationView.textLb.text = "1"
            }
        }
        if let l = sportDetail?.eachPartItems.last?.coordinates.last {
            if annotation.coordinate.latitude == l.latitude, annotation.coordinate.longitude == l.longitude {
                annotationView.image = R.image.location_stop()
                annotationView.textLb.text = ""
                
//                annotationView.image = R.image.gps_icon()
//                annotationView.textLb.text = "2"
            }
        }
    }
    
}

extension XWHSportShareContentView {
    
    private func configMapView() {
        mapView.backgroundColor = .white
        mapView.delegate = self
        mapView.showsUserLocation = false
        mapView.showsScale = false
        mapView.userTrackingMode = .none
        mapView.allowsBackgroundLocationUpdates = false
        mapView.distanceFilter = kCLDistanceFilterNone
        mapView.desiredAccuracy = kCLLocationAccuracyHundredMeters
        mapView.setZoomLevel(17, animated: false)
        mapView.showsCompass = false
        
        mapView.isRotateEnabled = false
        mapView.isRotateCameraEnabled = false
        mapView.isScrollEnabled = false
//        mapView.screenAnchor = CGPoint(0.5, 0.4)
    }
    
    func config(titleValueView: XWHTitleValueView) {
        titleValueView.type = .valueUp
        titleValueView.textAlignment = .center
        
        titleValueView.titleLbHeight = 16
        titleValueView.edgeMargin = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)

        titleValueView.titleLb.font = XWHFont.harmonyOSSans(ofSize: 11)
        titleValueView.titleLb.textColor = fontDarkColor.withAlphaComponent(0.4)

        titleValueView.valueLb.font = XWHFont.harmonyOSSans(ofSize: 17, weight: .bold)
        titleValueView.valueLb.textColor = fontDarkColor
    }
    
}

