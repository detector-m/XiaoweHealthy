//
//  XWHHealthyMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit
import MJRefresh

/// 运动健康首页
class XWHHealthyMainVC: XWHCollectionViewBaseVC {
    
    override var largeTitleWidth: CGFloat {
        UIScreen.main.bounds.width - 32
    }
    
    override var largeTitleHeight: CGFloat {
        40
    }
    
    override var topContentInset: CGFloat {
        66
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors.map({ $0.cgColor })
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.type = .axial
        return gradientLayer
    }()
    
    private var refreshHeader: PullToRefreshHeader?
    
    private lazy var gradientColors: [UIColor] = [UIColor(hex: 0xD5F9E1)!, UIColor(hex: 0xF8F8F8)!]
    
    private lazy var deployItems: [XWHHomeDeployItemModel] = []
    private lazy var deploy = XWHHomeDeploy()
    
    private var sleepUIModel: XWHHealthySleepUISleepModel?
    private var heartUIModel: XWHHeartUIHeartModel?
    private var boUIModel: XWHBOUIBloodOxygenModel?
    private var msUIModel: XWHMentalStressUIStressModel?
    private var moodUIModel: XWHMoodUIMoodModel?

    private var atSumUIModel: XWHActivitySumUIModel?
    
    private var isGpsStarting: Bool = false
    private var weatherInfo: XWHWeatherInfoModel?
    
    private var isGpsOk: Bool = false

    deinit {
        XWHDevice.shared.removeObserver(observer: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addHeaderRefresh()
        
        loadDatas()
        configNotifications()
        XWHDevice.shared.addObserver(observer: self)
        
        gotoRequestHealthKitAuthorize()
    }
    
    override func setupNavigationItems() {
        
    }
    
    override func setNavigationBarWithLargeTitle() {
        setNav(color: .white)
        
        let leftItem = getNavItem(text: R.string.xwhDisplayText.健康(), font: XWHFont.harmonyOSSans(ofSize: 16, weight: .medium), image: nil, target: self, action: #selector(clickNavLeftItem))
        navigationItem.leftBarButtonItem = leftItem
        
//        let rightImage = UIImage.iconFont(text: XWHIconFontOcticons.addCircle.rawValue, size: 24, color: fontDarkColor)
//        let rightItem = getNavItem(text: nil, image: rightImage, target: self, action: #selector(clickNavRightItem))
//        navigationItem.rightBarButtonItem = rightItem
        
        setNavHidden(false, animated: true, async: isFirstTimeSetNavHidden)
    }
    
    @objc private func clickNavLeftItem() {
        
    }
    
    override func resetNavigationBarWithoutLargeTitle() {
        setNavTransparent()
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
        
        setNavHidden(true, animated: true, async: isFirstTimeSetNavHidden)
    }
    
    override func addSubViews() {
        super.addSubViews()
        view.backgroundColor = .clear

        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        setLargeTitleMode()
        
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        largeTitleView.backgroundColor = collectionView.backgroundColor
        
        largeTitleView.titleLb.text = R.string.xwhDisplayText.健康()
    }
    
    override func relayoutSubViews() {
        collectionView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        relayoutLargeTitle()
        relayoutLargeTitleContentView()
    }
    
    override func relayoutLargeTitleContentView() {
        largeTitleView.relayout { ltView in
            ltView.button.snp.remakeConstraints { make in
                make.right.equalToSuperview().inset(12)
                make.size.equalTo(24)
                make.centerY.equalTo(ltView.titleLb)
            }

            ltView.titleLb.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(40)
                make.left.equalToSuperview().inset(12)
                make.right.lessThanOrEqualTo(ltView.button.snp.left).offset(-10)
            }
        }
    }
    
    override func registerViews() {
        collectionView.register(cellWithClass: XWHHomeWeatherCTCell.self)
        
        collectionView.register(cellWithClass: XWHHomeMoodCTCell.self)
        collectionView.register(cellWithClass: XWHHomeSleepCTCell.self)
//        collectionView.register(cellWithClass: XWHHomeColumnRangeBarChartCTCell.self)
        
        collectionView.register(cellWithClass: XWHHomeHeartCTCell.self)
        collectionView.register(cellWithClass: XWHHomeBOCTCell.self)
        collectionView.register(cellWithClass: XWHHomeMSCTCell.self)

        collectionView.register(cellWithClass: XWHHealthActivityCTCell.self)
        collectionView.register(cellWithClass: XWHHealthyMainCommonCTCell.self)
        
        collectionView.register(cellWithClass: XWHHomeEditCardCTCell.self)
        
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withClass: UICollectionReusableView.self)
    }
    
    func addHeaderRefresh() {
        let headerContentOffset = UIApplication.shared.statusBarFrame.height

        refreshHeader = collectionView.addHeader(contentInsetTop: topContentInset + largeTitleHeight, contentOffset: headerContentOffset) { [unowned self] in
            self.gotoReconnectOrSyncData()
        }
        refreshHeader?.setTitle("设备连接中...", for: .refreshing)
    }
    
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

// MARK: - Data
extension XWHHealthyMainVC {
    
    private func loadDatas() {
        deployItems = deploy.loadDeploys(rawData: [])
        collectionView.reloadData()
        
        loadServerDatas()
    }
    
    private func loadServerDatas() {
        if XWHUser.isLogined {
            if let _ = deployItems.first(where: { $0.type == .activity }) {
                getActivitySum()
            }
        }
            
        if let iDeployItem = deployItems.first(where: { $0.type == .health }) {
            for iSubDeployItem in iDeployItem.items {
                if iSubDeployItem.subType == .sleep {
                    getSleepData()
                } else if iSubDeployItem.subType == .mood {
                    getMoodData()
                } else if iSubDeployItem.subType == .mentalStress {
                    getMentalStressData()
                } else if iSubDeployItem.subType == .heart {
                    getHeartData()
                } else if iSubDeployItem.subType == .bloodOxygen {
                    getBOData()
                }
            }
        }
        
        if AppLocationManager.isAuthorized, AppLocationManager.shared.isEnable {
            getWeathInfo(isAuto: true)
        }
    }
    
}

// MARK: - Notification
extension XWHHealthyMainVC {
    
    private func configNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginNotification(notification:)), name: XWHLogin.kLoginOrLogoutNotificationName, object: nil)
    }
    
    @objc private func handleLoginNotification(notification: Notification) {
        guard let _ = notification.object as? Bool else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.loadDatas()
        }
    }
    
}

// MARK: - XWHDeviceObserverProtocol
extension XWHHealthyMainVC: XWHDeviceObserverProtocol {
    
    func updateDeviceConnectBind() {
        if XWHDDMShared.connectBindState == .disconnected {
            refreshHeader?.setTitle("设备未连接", for: .refreshing)
            refreshHeader?.endRefreshing()
        } else if XWHDDMShared.connectBindState == .paired {
            
        } else {
            refreshHeader?.beginRefreshing()
        }
        
        loadDatas()
    }
    
    func updateSyncState(_ syncState: XWHDevDataTransferState) {
        switch syncState {
        case .failed:
            collectionView.mj_header?.endRefreshing()
            
        case .succeed:
            collectionView.mj_header?.endRefreshing()
            
            loadDatas()
            
        case .inTransit:
            refreshHeader?.setTitle("数据同步中...", for: .refreshing)
        }
    }
    
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
@objc extension XWHHealthyMainVC {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return deployItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let iDeployItem = deployItems[section]
        if iDeployItem.type == .health {
            return iDeployItem.items.count
        } else {
            return 1
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let iDeployItem = deployItems[indexPath.section]
        if iDeployItem.type == .weather {
            return CGSize(width: collectionView.width, height: 38)
        }
        
        if iDeployItem.type == .activity {
            return CGSize(width: collectionView.width, height: 205)
        }
        
        if iDeployItem.type == .health {
            let iWidth = (collectionView.width - 12) / 2
            return CGSize(width: iWidth.int, height: 198)
        }
        
        if iDeployItem.type == .editCard {
            return CGSize(width: collectionView.width, height: 48)
        }

        return CGSize(width: collectionView.width, height: 74)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        let row = indexPath.item
        
        let iDeployItem = deployItems[section]
        
        if iDeployItem.type == .weather {
            let cell = collectionView.dequeueReusableCell(withClass: XWHHomeWeatherCTCell.self, for: indexPath)
            
            if !AppLocationManager.isAuthorized || !AppLocationManager.shared.isEnable, !isGpsOk {
                cell.textLb.text = "开启定位获取天气"
            } else {
                if isGpsStarting {
                    cell.textLb.text = "开启中..."
                } else if let wInfo = weatherInfo {
                    let dStr = Date().localizedString(withFormat: XWHDate.monthDayWeekFormat)
                    
                    var text = dStr + "，" + wInfo.cityName
                    if let wFirstInfo = wInfo.items.first {
                        text += " " + "\(wFirstInfo.minTemp)~\(wFirstInfo.maxTemp)℃" + " " + XWHWeather.getWeatherName(code: wFirstInfo.code)
                    }
                    cell.textLb.text = text
                } else {
                    cell.textLb.text = Date().localizedString(withFormat: XWHDate.monthDayWeekFormat)
                }
            }
            
            return cell
        }
        
        if iDeployItem.type == .activity {
            let cell = collectionView.dequeueReusableCell(withClass: XWHHealthActivityCTCell.self, for: indexPath)
            
            cell.update(atSumUIModel: atSumUIModel)
            return cell
        }
        
        if iDeployItem.type == .health {
            let iSubDeployItem = iDeployItem.items[row]
            if iSubDeployItem.subType == .sleep {
                let cell = collectionView.dequeueReusableCell(withClass: XWHHomeSleepCTCell.self, for: indexPath)
                cell.textLb.text = iSubDeployItem.subType.rawValue
                
                cell.update(sleepUIModel: sleepUIModel)
                
                return cell
            } else if iSubDeployItem.subType == .mood {
                let cell = collectionView.dequeueReusableCell(withClass: XWHHomeMoodCTCell.self, for: indexPath)
                cell.textLb.text = iSubDeployItem.subType.rawValue
                
                cell.update(moodUIModel: moodUIModel)
                
                return cell
            } else if iSubDeployItem.subType == .heart {
                let cell = collectionView.dequeueReusableCell(withClass: XWHHomeHeartCTCell.self, for: indexPath)
                cell.textLb.text = iSubDeployItem.subType.rawValue
                cell.imageView.image = R.image.heartIcon()
                cell.emptyChartView.layer.backgroundColor = UIColor(hex: 0xEB5763)?.withAlphaComponent(0.08).cgColor
                
                cell.update(heartUIModel: heartUIModel)
                
                return cell
            } else if iSubDeployItem.subType == .bloodOxygen {
                
                let cell = collectionView.dequeueReusableCell(withClass: XWHHomeBOCTCell.self, for: indexPath)
                cell.textLb.text = iSubDeployItem.subType.rawValue
                
                cell.imageView.image = R.image.deviceOxygen()
                cell.imageView.layer.backgroundColor = UIColor(hex: 0x6CD267)!.cgColor
                
                cell.emptyChartView.layer.backgroundColor = UIColor(hex: 0x6CD267)?.withAlphaComponent(0.08).cgColor
                
                cell.update(boUIModel: boUIModel)
                
                return cell
            } else if  iSubDeployItem.subType == .mentalStress {
                let cell = collectionView.dequeueReusableCell(withClass: XWHHomeMSCTCell.self, for: indexPath)
                cell.textLb.text = iSubDeployItem.subType.rawValue
                
                cell.imageView.image = R.image.stressIcon()
                
                cell.emptyChartView.layer.backgroundColor = UIColor(hex: 0x76D4EA)?.withAlphaComponent(0.08).cgColor
                
                cell.update(msUIModel: msUIModel)
                
                return cell
            }
        }
        
        if iDeployItem.type == .editCard {
            let cell = collectionView.dequeueReusableCell(withClass: XWHHomeEditCardCTCell.self, for: indexPath)
            return cell
        }
        
//        if iDeployItem.type == .login, iDeployItem.type == .bind {  }
        
        // iDeployItem.type == .login, iDeployItem.type == .bind
        let cell = collectionView.dequeueReusableCell(withClass: XWHHealthyMainCommonCTCell.self, for: indexPath)
        
        if iDeployItem.type == .login {
            cell.textLb.text = R.string.xwhHealthyText.点击登录()
            cell.detailLb.text = R.string.xwhHealthyText.体验更多功能和运动健康服务()
            cell.imageView.image = R.image.homeLoginIcon()?.scaled(toWidth: 18)
        } else if iDeployItem.type == .bind {
            cell.textLb.text = R.string.xwhHealthyText.点击绑定设备()
            cell.detailLb.text = R.string.xwhHealthyText.体验更丰富的设备功能和服务()
            cell.imageView.image = R.image.tabMe()?.tint(.white, blendMode: .destinationIn).scaled(toWidth: 18)
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.width, height: 12)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withClass: UICollectionReusableView.self, for: indexPath)
        return reusableView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.item
        
        let iDeployItem = deployItems[section]
        
        switch iDeployItem.type {
        case .weather:
            gotoGetWeatherInfo()
            
        case .activity:
            gotoActivity()
            
        case .login:
            gotoLogin()
            
        case .bind:
            gotoBindDevice()
            
        case .health:
            let iSubDeployItem = iDeployItem.items[row]
            switch iSubDeployItem.subType {
            case .heart:
                gotoHeart()
                
            case .bloodOxygen:
                gotoBloodOxygen()
                
            case .mentalStress:
                gotoMentalStress()
                
            case .mood:
                gotoMood()
                
            case .sleep:
                gotoSleep()
                
            case .none:
                break
            }
            
        case .editCard:
            gotoEidtCard()
        }
    }
    
    // MARK: - UIScrollViewDeletate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollLargeTitle(in: scrollView)
    }
    
}

// MARK: - Api
extension XWHHealthyMainVC {
    
    /// 获取每日数据概览
    private func getActivitySum() {
        XWHActivityVM().getActivity(date: Date()) { [weak self] error in
            log.error(error)
            
            guard let self = self else {
                return
            }
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.atSumUIModel = nil
            self.collectionView.reloadData()
        } successHandler: { [weak self] response in
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? XWHActivitySumUIModel else {
                log.debug("活动 - 获取数据为空")
                
                self.atSumUIModel = nil
                self.collectionView.reloadData()
                                
                return
            }
            
            self.atSumUIModel = retModel
            self.collectionView.reloadData()
        }
    }
    
    /// 睡眠
    private func getSleepData() {
        let cDate = Date()
        XWHHealthyVM().getSleep(date: cDate, dateType: .day) { [weak self] error in
            log.error(error)
            
            guard let self = self else {
                return
            }
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.sleepUIModel = nil
            self.collectionView.reloadData()
        } successHandler: { [weak self] response in
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? XWHHealthySleepUISleepModel else {
                log.debug("睡眠 - 获取数据为空")
                
                self.sleepUIModel = nil
                self.collectionView.reloadData()
                                
                return
            }
            
            self.sleepUIModel = retModel
            self.collectionView.reloadData()
        }
    }
    
    /// 精神压力
    private func getMentalStressData() {
        let cDate = Date()
        XWHHealthyVM().getMentalStress(date: cDate, dateType: .day) { [weak self] error in
            log.error(error)
            
            guard let self = self else {
                return
            }
            
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.msUIModel = nil
            self.collectionView.reloadData()
        } successHandler: { [weak self] response in
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? XWHMentalStressUIStressModel else {
                log.debug("精神压力 - 获取数据为空")
                self.msUIModel = nil
                self.collectionView.reloadData()
                
                return
            }
            
            self.msUIModel = retModel
            self.collectionView.reloadData()
        }
    }
    
    /// 血氧
    private func getBOData() {
        let cDate = Date()
        XWHHealthyVM().getBloodOxygen(date: cDate, dateType: .day) { [weak self] error in
            log.error(error)
            
            guard let self = self else {
                return
            }
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.boUIModel = nil
            self.collectionView.reloadData()
        } successHandler: { [weak self] response in
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? XWHBOUIBloodOxygenModel else {
                log.debug("血氧 - 获取数据为空")
                self.boUIModel = nil
                self.collectionView.reloadData()

                return
            }
            
            self.boUIModel = retModel
            self.collectionView.reloadData()
        }
    }
    
    /// 心率
    private func getHeartData() {
        let cDate = Date()
        XWHHealthyVM().getHeart(date: cDate, dateType: .day) { [weak self] error in
            log.error(error)
            
            guard let self = self else {
                return
            }
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.heartUIModel = nil
            self.collectionView.reloadData()
        } successHandler: { [weak self] response in
            guard let self = self else {
                return
            }
            
            guard let retModel = response.data as? XWHHeartUIHeartModel else {
                log.debug("心率 - 获取数据为空")

                self.heartUIModel = nil
                self.collectionView.reloadData()
                
                return
            }
            
            self.heartUIModel = retModel
            self.collectionView.reloadData()
        }
    }
    
    /// 情绪
    private func getMoodData() {
        let cDate = Date()
        XWHHealthyVM().getMood(date: cDate, dateType: .day) { [weak self] error in
            log.error(error)
            guard let self = self else {
                return
            }
            if error.isExpiredUserToken {
                XWHUser.handleExpiredUserTokenUI(self, nil)
                return
            }
            
            self.moodUIModel = nil
            self.collectionView.reloadData()
        } successHandler: { [weak self] response in
            guard let self = self else {
                return
            }
            guard let retModel = response.data as? XWHMoodUIMoodModel else {
                log.debug("情绪 - 获取数据为空")
                self.moodUIModel = nil
                self.collectionView.reloadData()
                
                return
            }
            
            self.moodUIModel = retModel
            self.collectionView.reloadData()
        }
    }
    
    /// 获取天气信息
    private func getWeathInfo(isAuto: Bool) {
        AppLocationManager.shared.requestAuthorizationOneTime { [weak self] isEnable, authStatus in
            self?.isGpsOk = authStatus.isAuthorized
            
            if authStatus.isAuthorized {
                self?.isGpsStarting = false
                
                XWHWeather.getWeatherInfo { [weak self]  cInfo in
                    self?.weatherInfo = cInfo
                    
                    self?.collectionView.reloadData()
                }
            } else {
                if !isAuto {
                    if authStatus == .denied {
                        RLBLEPermissions.openAppSettings()
                    } else if authStatus == .notDetermined {
                        guard let self = self else {
                            return
                        }
                        
//                        self.collectionView.reloadData()

                        if !self.isGpsStarting {
                            return
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                            self.isGpsStarting = false
                            self.collectionView.reloadData()
                        }
                        
                        return
                    }
                }
                
                self?.isGpsStarting = false
                self?.collectionView.reloadData()
            }
        }
    }
    
}

// MARK: - Jump UI
extension XWHHealthyMainVC {
    
    // 重连设备或者同步数据
    private func gotoReconnectOrSyncData() {
        if XWHDevice.shared.isConnectBind {
            if XWHDevice.shared.isSyncing {
                view.makeInsetToast(R.string.xwhDeviceText.正在同步数据())
                return
            }
            
            XWHDevice.shared.syncData()
        } else {
            RLBLEPermissions.shared.getState { bleState in
                if bleState == .poweredOn {
                    XWHDevice.shared.connect()
                } else {
                    XWHAlert.show(message: R.string.xwhDeviceText.连接设备需要打开手机蓝牙要开启吗())
                }
            }
        }
    }
    
    /// 运动健康授权
    private func gotoRequestHealthKitAuthorize() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            hkServiceManager.requestAuthorization { success, setupError in
                if !success {
                    XWHAlert.show(title: nil, message: "运动健康未授权，请到运动健康App授权", cancelTitle: R.string.xwhDisplayText.取消(), confirmTitle: "去授权") { aType in
                        if aType == .confirm {
                            RLBLEPermissions.openAppSettings()
                        }
                    }
                }
            }
        }
    }
    
    /// 获取天气
    private func gotoGetWeatherInfo() {
        if let _ = weatherInfo {
            return
        }
        isGpsStarting = true
        collectionView.reloadData()

        getWeathInfo(isAuto: false)
    }
    
    /// 去登录
    private func gotoLogin() {
        XWHLogin.present(at: self)
    }
    
    /// 去绑定设备
    private func gotoBindDevice() {
        tabBarController?.selectedIndex = 2
    }
    
    /// 每日活动
    private func gotoActivity() {
        if !XWHUser.isLogined {
            gotoLogin()
            
            return
        }
        
        let vc = XWHActivityCTVC()
        vc.atSumUIModel = atSumUIModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转到心率
    private func gotoHeart() {
        if !XWHUser.isLogined {
            gotoLogin()
            
            return
        }
        
        let vc = XWHHealthyHeartCTVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转到血氧
    private func gotoBloodOxygen() {
        if !XWHUser.isLogined {
            gotoLogin()
            
            return
        }
        
        let vc = XWHHealthyBloodOxygenCTVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转到压力
    private func gotoMentalStress() {
        if !XWHUser.isLogined {
            gotoLogin()
            
            return
        }
        
        let vc = XWHHealthyMentalStressCTVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转到情绪
    private func gotoMood() {
        if !XWHUser.isLogined {
            gotoLogin()
            
            return
        }
        
        let vc = XWHHealthyMoodCTVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 跳转到睡眠
    private func gotoSleep() {
        if !XWHUser.isLogined {
            gotoLogin()
            
            return
        }
        
        let vc = XWHHealthySleepCTVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 编辑健康卡片
    private func gotoEidtCard() {
        if !XWHUser.isLogined {
            gotoLogin()
            
            return
        }
        
        let vc = XWHHealthCardEditTBVC()
        vc.refreshCallback = { [weak self] in
            self?.loadDatas()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
