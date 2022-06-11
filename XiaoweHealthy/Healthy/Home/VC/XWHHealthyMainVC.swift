//
//  XWHHealthyMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

/// 运动健康首页
class XWHHealthyMainVC: XWHCollectionViewBaseVC {
    
    override var largeTitleWidth: CGFloat {
        UIScreen.main.bounds.width - 32
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
    
    private lazy var gradientColors: [UIColor] = [UIColor(hex: 0xD5F9E1)!, UIColor(hex: 0xF8F8F8)!]
    
    private lazy var deployItems: [XWHHomeDeployItemModel] = []
    private lazy var deploy = XWHHomeDeploy()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addHeaderRefresh()
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
        collectionView.register(cellWithClass: XWHHealthActivityCTCell.self)
        collectionView.register(cellWithClass: XWHHealthyMainCommonCTCell.self)
        
        collectionView.register(cellWithClass: XWHHomeEditCardCTCell.self)
        
        collectionView.register(supplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withClass: UICollectionReusableView.self)
    }
    
    func addHeaderRefresh() {
        let headerContentOffset = UIApplication.shared.statusBarFrame.height

        collectionView.addHeader(contentInsetTop: topContentInset + largeTitleHeight, contentOffset: headerContentOffset) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [unowned self] in
                self.collectionView.mj_header?.endRefreshing()
            }
        }
    }
    
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadDatas()
    }

}

// MARK: - Data
extension XWHHealthyMainVC {
    
    private func loadDatas() {
        deployItems = deploy.loadDeploys(rawData: [])
        collectionView.reloadData()
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
        
        if iDeployItem.type == .activity {
            let cell = collectionView.dequeueReusableCell(withClass: XWHHealthActivityCTCell.self, for: indexPath)
            cell.textLb.text = iDeployItem.type.name
            
            return cell
        }
        
        if iDeployItem.type == .health {
            let iSubDeployItem = iDeployItem.items[row]

            let cell = collectionView.dequeueReusableCell(withClass: XWHHealthyMainCommonCTCell.self, for: indexPath)
            cell.textLb.text = iSubDeployItem.subType.rawValue
            
            return cell
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
        case .activity:
            break
            
        case .login:
            gotoLogin()
            
        case .bind:
            break
            
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

// MARK: - Jump UI
extension XWHHealthyMainVC {
    
    /// 去登录
    private func gotoLogin() {
        XWHLogin.present(at: self)
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
        let vc = XWHHealthCardEditTBVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: - Test
extension XWHHealthyMainVC {
    
    private func gotoTestTest() {
        //        XWHLogin.present(at: self)
                
        //        testFirmwareUpdate()
                
        //        testCache()
                
        //        testScan()
                
        //        testDatabase()
        //        testUTEWeatherApi()
                
        //        testDailVC()
                
//                testContact()
        
//        testGetHeart()
        
        testCalendar()
    }
    
    private func gotoTestPost() {
//        testPostHeart()
//        testPostBloodOxygen()
        
        testPostMentalState()
    }
    
    private func gotoSync() {
        let devModel = XWHDevWatchModel()
        devModel.category = .watch
        devModel.type = .skyworthWatchS1
        XWHDDMShared.config(device: devModel)
        
        XWHDDMShared.setDataOperation { cp in
            log.debug("同步进度 = \(cp)")
        } resultHandler: { [weak self] (syncType, syncState, result: Result<XWHResponse?, XWHError>) in
            if syncState == .succeed {
                log.debug("数据同步成功")
            } else if syncState == .failed {
                switch result {
                case .success(_):
                    return
                    
                case .failure(let error):
                    log.error("数据同步失败 error = \(error)")
                    self?.view.makeInsetToast(error.message)
                }
            }
        }

        XWHDDMShared.syncData()
    }
    
    fileprivate func testUserProfile() {
        XWHUserVM().profile { error in
            self.view.makeInsetToast(error.message)
        } successHandler: { response in
            self.view.makeInsetToast(response.data.debugDescription)
        }
    }
    
    fileprivate func testFirmwareUpdate() {
        XWHDeviceVM().firmwareUpdate(deviceSn: Self.testDeviceSn(), version: "v1.2.32") { error in
            self.view.makeInsetToast(error.message)
        } successHandler: { response in
            self.view.makeInsetToast(response.data.debugDescription)
        }
    }
    
    fileprivate func testCache() {
        XWHCache.test()
    }
    
    fileprivate func testScan() {
        let devModel = XWHDevWatchModel()
        devModel.category = .watch
        devModel.type = .skyworthWatchS1
        XWHDDMShared.config(device: devModel)
        
        XWHDDMShared.startScan(device: devModel) { devices in
            log.debug(devices)
        }
    }
    
    fileprivate func testDatabase() {
//        XWHDataUserManager.test()
        XWHDataDeviceManager.test()
    }
    
    fileprivate func testUTEWeatherApi() {
        let devModel = XWHDevWatchModel()
        devModel.category = .watch
        devModel.type = .skyworthWatchS1
        XWHDDMShared.config(device: devModel)
        
        XWHDDMShared.getWeatherServiceWeatherInfo(cityId: "CN101010100", latitude: 0, longitude: 0) { [weak self] result in
            switch result {
            case .success(let wsInfo):
                log.debug(wsInfo)
                
            case .failure(let error):
                self?.view.makeInsetToast(error.message)
            }
        }
    }
    
    private func testDailVC() {
        let vc = XWHDialVC()
        // Test
        vc.deviceSn = Self.testDeviceSn()
        navigationController?.pushViewController(vc, animated: true)
        
        // Test
//        let deviceSn = testDeviceSn()
//        XWHDialVM().add(dialNo: "D3919001", deviceSn: deviceSn) { error in
//
//        } successHandler: { response in
//
//        }
        
        // Test
//        XWHUserVM().bindDevice(deviceSn: deviceSn, deviceMode: "S1", deviceName: "ABCE", macAddr: "12345678900988765") { error in
//            log.error(error)
//        } successHandler: { res in
//
//        }

    }
    
    private func testContact() {
        let vc = XWHContactVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func testPostHeart() {
        let date = Date()
        var ts = (date.timeIntervalSince1970 / 600).int * 600
        ts -= 600 * 20
        
        var hData = [XWHHeartModel]()
        
        for i in 0 ..< 20 {
            let iTs = 600 * i + ts
            let iModel = XWHHeartModel()
            iModel.identifier = Self.testDeviceSn()
            iModel.value = Int(40 + arc4random() % 160)
            let iDate = Date(timeIntervalSince1970: iTs.double)
            iModel.time = iDate.string(withFormat: iModel.standardTimeFormat)
            hData.append(iModel)
        }
        
        if let lastHeart = hData.last {
            let cHeart = lastHeart.clone()
//            XWHHealthyDataManager.saveHeart(cHeart)
            XWHHealthyDataManager.saveHearts([cHeart])
        }
        
        
        guard let deviceMac = ddManager.getCurrentDevice()?.mac else {
            return
        }
        
        XWHServerDataManager.postHeart(deviceMac: deviceMac, deviceSn: Self.testDeviceSn(), data: hData) { error in
            log.error(error)
        } successHandler: { response in
            
        }
    }
    
    private func testGetHeart() {
//        let date = Date()
//        let dateType = XWHHealthyDateSegmentType.year
//        XWHHealthyVM().getHeart(date: date, dateType: dateType) { error in
//            log.error(error)
//        } successHandler: { response in
//
//        }
        
        let date = Date()
        let hearts = XWHHealthyDataManager.getHearts(identifier: Self.testDeviceSn(), bDate: date.dayBegin, eDate: date.dayEnd)
        
        log.debug(hearts)
    }
    
    private func testPostBloodOxygen() {
        let date = Date()
        var ts = (date.timeIntervalSince1970 / 600).int * 600
        ts -= 600 * 20
        
        var boData = [XWHBloodOxygenModel]()
        
        for i in 0 ..< 20 {
            let iTs = 600 * i + ts
            let iModel = XWHBloodOxygenModel()
            iModel.identifier = Self.testDeviceSn()
            iModel.value = Int(70 + arc4random() % 30)
            let iDate = Date(timeIntervalSince1970: iTs.double)
            iModel.time = iDate.string(withFormat: iModel.standardTimeFormat)
            boData.append(iModel)
        }
        
        if let lastBo = boData.last {
            let cBo = lastBo.clone()
            XWHHealthyDataManager.saveBloodOxygen(cBo)
        }
        
        guard let deviceMac = ddManager.getCurrentDevice()?.mac else {
            return
        }
        
        XWHServerDataManager.postBloodOxygen(deviceMac: deviceMac, deviceSn: Self.testDeviceSn(), data: boData) { error in
            log.error(error)
        } successHandler: { response in
            
        }
    }
    
    private func testPostMentalState() {
        guard let devSn = ddManager.getCurrentDeviceIdentifier() else {
            return
        }

        let date = Date()
        var ts = (date.timeIntervalSince1970 / 600).int * 600
        ts -= 600 * 20
        
        var postData = [XWHMentalStateModel]()
        
        for i in 0 ..< 20 {
            let iTs = 600 * i + ts
            let iModel = XWHMentalStateModel()
            iModel.identifier = devSn
            iModel.mood = Int(arc4random() % 3)
            iModel.fatigue = Int(arc4random() % 101)
            iModel.stress = Int(arc4random() % 101)
            let iDate = Date(timeIntervalSince1970: iTs.double)
            iModel.time = iDate.string(withFormat: iModel.standardTimeFormat)
            postData.append(iModel)
        }
        
        if let last = postData.last {
            let sItem = last.clone()
            XWHHealthyDataManager.saveMentalState(sItem)
        }
        
        let deviceMac = ""
        XWHServerDataManager.postMentalState(deviceMac: deviceMac, deviceSn: devSn, data: postData) { error in
            log.error(error)
            self.view.makeInsetToast("testPostMentalState 上传失败")
        } successHandler: { [unowned self] response in
            self.view.makeInsetToast("testPostMentalState 上传成功")
        }
    }
    
    private func testGetBloodOxygen() {
        let date = Date()
        let dateType = XWHHealthyDateSegmentType.year
        XWHHealthyVM().getBloodOxygen(date: date, dateType: dateType) { error in
            log.error(error)
        } successHandler: { response in

        }
    }
    
    private func testCalendar() {
        let calendarView = XWHCalendarView()
        calendarView.backgroundColor = .white
        calendarView.size = CGSize(width: XWHCalendarHelper.calendarWidth, height: 469)
        XWHCalendarPopupContainer.generatePopupWithView(calendarView).show()
        
//        calendarView.sDate = Date()
        calendarView.dateType = .day
        
//        XWHCalendar.show(Date(), .year, nil)
    }
    
    
    class func testDeviceSn() -> String {
        "1923190012204123456"
    }
    
}
