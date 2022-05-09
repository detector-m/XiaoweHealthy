//
//  XWHHealthyMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit
import Alamofire
import SwiftUI

/// 运动健康首页
class XWHHealthyMainVC: XWHTableViewBaseVC {
    
    private lazy var testItems: [XWHHealthyType] = [.heart, .bloodOxygen, .mentalStress, .sleep, .login, .test, .post, .sync]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationItems() {
        
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.backgroundColor = collectionBgColor
        
        // 大标题方式2
        setLargeTitleMode()
        
        tableView.backgroundColor = view.backgroundColor
        tableView.separatorStyle = .none
        largeTitleView.backgroundColor = tableView.backgroundColor
        
        largeTitleView.titleLb.text = R.string.xwhDisplayText.健康()
    }
    
    override func relayoutSubViews() {
        // 大标题方式2
        tableView.snp.remakeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        relayoutLargeTitle()
        
        relayoutLargeTitleContentView()
    }
        
    func relayoutLargeTitleContentView() {
        largeTitleView.relayout { ltView in
            ltView.button.snp.remakeConstraints { make in
                make.right.equalToSuperview().inset(28)
                make.size.equalTo(24)
                make.centerY.equalTo(ltView.titleLb)
            }

            ltView.titleLb.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.height.equalTo(40)
                make.left.equalToSuperview().inset(28)
                make.right.lessThanOrEqualTo(ltView.button.snp.left).offset(-10)
            }
        }
    }
    
    override func registerViews() {
        tableView.register(cellWithClass: XWHBaseTBCell.self)
    }

}

// MARK: - UITableViewDataSource & UITableViewDelegate & UITableViewRoundedProtocol
@objc extension XWHHealthyMainVC {
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testItems.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHBaseTBCell.self, for: indexPath)
        cell.titleLb.text = testItems[indexPath.row].rawValue
        
        return cell
    }
    
//   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//    }
    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }

//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.001
//    }
//
//    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tItem = testItems[indexPath.row]
        switch tItem {
        case .heart:
            gotoHeart()
            
        case .bloodOxygen:
            gotoBloodOxygen()
            
        case .mentalStress:
            gotoMentalStress()
            
        case .sleep:
            gotoSleep()
            
        case .login:
            gotoTestLogin()
            
        case .test:
            gotoTestTest()
            
        case .post:
            gotoTestPost()
            
        case .sync:
            gotoSync()
            
        case .none:
            break
        }
    }
    
    // MARK: - UIScrollViewDeletate
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleScrollLargeTitle(in: scrollView)
    }
    
}

// MARK: - Jump UI
extension XWHHealthyMainVC {
    
    // 去登录
    private func gotoLogin() {
        XWHLogin.present(at: self)
    }
    
    // 跳转到心率
    private func gotoHeart() {
        if !XWHUser.isLogined() {
            gotoLogin()
            
            return
        }
        
        let vc = XWHHealthyHeartCTVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 跳转到血氧
    private func gotoBloodOxygen() {
        if !XWHUser.isLogined() {
            gotoLogin()
            
            return
        }
        
        let vc = XWHHealthyBloodOxygenCTVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 跳转到压力
    private func gotoMentalStress() {
        if !XWHUser.isLogined() {
            gotoLogin()
            
            return
        }
        
        let vc = XWHHealthyMentalStressCTVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 跳转到睡眠
    private func gotoSleep() {
        if !XWHUser.isLogined() {
            gotoLogin()
            
            return
        }
        
        let vc = XWHHealthySleepCTVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: - Test
extension XWHHealthyMainVC {
    
    private func gotoTestLogin() {
        XWHLogin.presentPasswordLogin(at: self)
        
//        XWHCryptoAES.test()
        
//        testUserProfile()
    }
    
    private func gotoTestTest() {
        //        XWHLogin.present(at: self)
                
        //        testBridge()
                
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
    
    fileprivate func testBridge() {
        let vc = XWHTestWebViewBridgeVC()
        navigationController?.pushViewController(vc, animated: true)
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
        
        XWHServerDataManager.postHeart(deviceSn: Self.testDeviceSn(), data: hData) { error in
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
        
        log.info(hearts)
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
        
        XWHServerDataManager.postBloodOxygen(deviceSn: Self.testDeviceSn(), data: boData) { error in
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
        
        XWHServerDataManager.postMentalState(deviceSn: devSn, data: postData) { error in
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
