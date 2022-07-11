//
//  XWHSportRecordDetailVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/6/9.
//

import UIKit
import CoreLocation


/// 运动详情
class XWHSportRecordDetailVC: XWHTableViewBaseVC {
    
    override var titleText: String {
        return "运动详情"
    }
    
    lazy var mapView = MAMapView(frame: .zero)
    
    private var tbXOffset: CGFloat {
        16
    }
    private var tbWidth: CGFloat {
        view.width - tbXOffset * 2
    }
    private var tbHeigth: CGFloat {
        view.height - view.safeAreaInsets.top
    }
    private var safeAreaTop: CGFloat {
        view.safeAreaInsets.top
    }
    private var topOffset: CGFloat {
        242
    }
    
    var sportId: Int = -1
    private var sportDetail: XWHSportModel?
    
    var firstCoordinate: CLLocationCoordinate2D?
    
    deinit {
        mapView.showsUserLocation = false
        mapView.allowsBackgroundLocationUpdates = false
        mapView.delegate = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSportDetail()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        tableView.frame = CGRect(x: tbXOffset, y: safeAreaTop + topOffset, width: tbWidth, height: tbHeigth)
        mapView.frame = CGRect(x: 0, y: 0, width: view.width, height: tableView.y)
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        setNavTransparent()
        navigationItem.title = ""
        
        let rightItem = getNavItem(text: nil, image: R.image.share_icon(), target: self, action: #selector(clickShareBtn))
        navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc private func clickShareBtn() {
        
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(mapView)
        
        view.backgroundColor = collectionBgColor
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.clipsToBounds = false
        
        view.sendSubviewToBack(mapView)
        
        configMapView()
    }
    
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
        
//        mapView.setCenter(mapView.userLocation.coordinate, animated: true)
    }
    
    override func relayoutSubViews() {
//        tableView.frame = CGRect(x: 0, y: 240, width: view.width, height: view.height)
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHSportDetailSummaryTBCell.self)
        tableView.register(cellWithClass: XWHSportDetailDataDetailTBCell.self)
        tableView.register(cellWithClass: XWHSportDetailPaceTBCell.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHSportRecordDetailVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
//        let row = indexPath.row

        if section == 0 {
            return 300
        } else if section == 1 {
            let paceCount = sportDetail?.eachPartItems.count ?? 0
            return 85 + 11 + (34 + 5) * paceCount.cgFloat
        } else {
            return 481
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
//        let row = indexPath.row
        
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withClass: XWHSportDetailSummaryTBCell.self)
            cell.update(sportDetail: sportDetail)
            
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withClass: XWHSportDetailPaceTBCell.self)
            cell.update(sportDetail: sportDetail)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withClass: XWHSportDetailDataDetailTBCell.self)
            cell.update(sportDetail: sportDetail)
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        rounded(tableView, willDisplay: cell, forRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 30
        }
        return 0.001
    }

//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if section != 0 {
//            return nil
//        }
//        let cView = UIView()
//        cView.backgroundColor = collectionBgColor
//
//        return cView
//    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12
    }

//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let cView = UIView()
//        cView.backgroundColor = collectionBgColor
//
//        return cView
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    // MARK: - UIScrollViewDeletate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let sOffset = scrollView.contentOffset.y
        
        if sOffset > 0 {
            if tableView.y == safeAreaTop {
                return
            }
            
            scrollView.touchesShouldCancel(in: scrollView)
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) { [weak self] in
                guard let self = self else {
                    return
                }
                self.tableView.frame = CGRect(x: self.tbXOffset, y: self.safeAreaTop, width: self.tbWidth, height: self.tbHeigth)
                self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                self.setNav(color: .white)
                self.navigationItem.title = self.titleText
            } completion: { _ in }
        } else if sOffset < -64 {
            if tableView.y == topOffset + safeAreaTop {
                return
            }
            
            scrollView.touchesShouldCancel(in: scrollView)
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear) { [weak self] in
                guard let self = self else {
                    return
                }
                self.tableView.frame = CGRect(x: self.tbXOffset, y: self.topOffset + self.safeAreaTop, width: self.tbWidth, height: self.tbHeigth)
                self.tableView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                self.setNavTransparent()
                self.navigationItem.title = ""
            } completion: { _ in }
        }
        
//        if sOffset >= 242 {
//            sOffset = 242
//        } else if sOffset <= 0 {
//            sOffset = 0
//        }
//
//        tableView.frame = CGRect(x: 0, y: 242 + view.safeAreaInsets.top - sOffset, width: view.width, height: view.height)
    }
    
}

extension XWHSportRecordDetailVC: MAMapViewDelegate {
    
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
        let centerCoordinate = allCoordinates[cCount / 2]
        firstCoordinate = centerCoordinate
        mapView.setCenter(centerCoordinate, animated: true)
        
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

// MARK: - Api
extension XWHSportRecordDetailVC {
    
    private func getSportDetail() {
        if sportId < 0 {
            return
        }
        
        XWHProgressHUD.show()
        XWHSportVM().getSportDetail(sportId: sportId) { [weak self] error in
            log.error(error)
            
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            self.view.makeInsetToast("获取运动详情失败")
        } successHandler: { [weak self] response in
            XWHProgressHUD.hide()
            
            guard let self = self else {
                return
            }
            guard let retModel = response.data as? XWHSportModel else {
                self.view.makeInsetToast("获取运动详情失败")
                
                return
            }
            
            self.sportDetail = retModel
            self.tableView.reloadData()
            self.drawLocationPath()
        }
    }
    
}
