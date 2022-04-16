//
//  XWHHealthyMainVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/16.
//

import UIKit

class XWHHealthyMainVC: XWHBaseVC {
    
    lazy var loginBtn: UIButton = UIButton()
    lazy var loginBtn2: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupNavigationItems() {
        
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.addTarget(self, action: #selector(clickLoginBtn), for: .touchUpInside)
        loginBtn.backgroundColor = UIColor.red
        view.addSubview(loginBtn)
        
        
        loginBtn2.setTitle("密码登录", for: .normal)
        loginBtn2.addTarget(self, action: #selector(clickLoginBtn2), for: .touchUpInside)
        loginBtn2.backgroundColor = UIColor.red
        view.addSubview(loginBtn2)
    }
    
    override func relayoutSubViews() {
        loginBtn.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.center.equalToSuperview()
        }
        
        loginBtn2.snp.makeConstraints { make in
            make.centerX.size.equalTo(loginBtn)
            make.top.equalTo(loginBtn.snp.bottom).offset(20)
        }
    }
    

    @objc func clickLoginBtn() {
//        XWHLogin.present(at: self)
        
//        testBridge()
        
//        testFirmwareUpdate()
        
//        testCache()
        
//        testScan()
        
//        testDatabase()
//        testUTEWeatherApi()
        
        testDailVC()
    }
    
    @objc func clickLoginBtn2() {
        XWHLogin.presentPasswordLogin(at: self)
        
//        XWHCryptoAES.test()
        
//        testUserProfile()
    }

}


// MARK: - Test
extension XWHHealthyMainVC {
    
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
    
}
