//
//  XWHHealthyMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

/// 运动健康首页
class XWHHealthyMainVC: XWHTableViewBaseVC {
    
    private lazy var testItems: [XWHHealthyType] = [.heart, .bloodOxygen, .login, .test]

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
            
        case .login:
            gotoTestLogin()
            
        case .test:
            gotoTestTest()
            
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
    
    // 跳转到心率
    private func gotoHeart() {
        let vc = XWHHealthyHeartCTVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 跳转到血氧
    private func gotoBloodOxygen() {
        let vc = XWHHealthyBloodOxygenCTVC()
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
        
        testGetHeartRate()
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
        XWHDeviceVM().firmwareUpdate(deviceSn: "1923190012204123456", version: "v1.2.32") { error in
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
        vc.deviceSn = "1923190012204123456"
        navigationController?.pushViewController(vc, animated: true)
        
        // Test
//        let deviceSn = "1923190012204123456"
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
    
    private func testGetHeartRate() {
        var date = Date()
        date.day = 18
        date.month = 1
        let dateType = XWHHealthyDateSegmentType.year
//        XWHHealthyVM().getHeart(date: date, dateType: dateType) { error in
//            log.error(error)
//        } successHandler: { response in
//
//        }

        XWHHealthyVM().getBloodOxygen(date: date, dateType: dateType) { error in
            log.error(error)
        } successHandler: { response in

        }
    }
    
}
