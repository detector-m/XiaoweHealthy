//
//  XWHBindDeviceVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/28.
//

import UIKit

class XWHBindDeviceVC: XWHSearchBindDevBaseVC {

    lazy var devImageView = XWHDeviceFaceView()
    lazy var helpBtn = UIButton()
    
    lazy var bindDeviceModel = XWHDevWatchModel()
    
    private var isBindSuccess = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startBindDevice()
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        
        rt_disableInteractivePop = true
    }
    
    override func addSubViews() {
        super.addSubViews()
        
//        devImageView.image = R.image.devicePlaceholder()
        devImageView.bgImageView.contentMode = .scaleAspectFit
        devImageView.imageView.contentMode = .scaleAspectFit
        devImageView.bgImageView.image = R.image.devicePlacehodlerBg()
        devImageView.imageView.image = R.image.devicePlacehodlerCover()
        view.addSubview(devImageView)
        
        helpBtn.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 14, weight: .medium)
        helpBtn.setTitleColor(UIColor(hex: 0x000000, transparency: 0.9), for: .normal)
        helpBtn.addTarget(self, action: #selector(clickHelpBtn), for: .touchUpInside)
        view.addSubview(helpBtn)
    }
    
    override func relayoutSubViews() {
        relayoutTitleAndDetailLb()
        
        devImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(290).priority(.low)
            make.left.right.equalToSuperview().inset(43).priority(.high)

            make.top.equalTo(detailLb.snp.bottom).offset(20)
            make.height.equalTo(devImageView.snp.width)
        }
        
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(48)
        }
        
        helpBtn.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview().offset(-58)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(button.snp.top).offset(-16)
            make.height.equalTo(20)
        }
    }
    
    @objc override func clickNavGlobalBackBtn() {
        guard let vcs = navigationController?.viewControllers else {
            return
        }
        
        if XWHDDMShared.connectBindState != .disconnected, XWHDDMShared.connectBindState != .paired {
            view.makeInsetToast(R.string.xwhDeviceText.连接中())
            return
        }
        
        if isBindSuccess {
            gotoDeviceMain()
            return
        }
        
        for vc in vcs {
            if vc.isKind(of: XWHAddBrandDeviceVC.self) {
                navigationController?.popToViewController(vc, animated: true)
                
                return
            }
        }
    }
    
    override func clickButton() {
        if XWHDDMShared.connectBindState == .disconnected {
            startBindDevice()
        } else if XWHDDMShared.connectBindState == .paired {
            gotoDeviceMain()
        }
    }
    
    @objc func clickHelpBtn() {
        XWHDevice.gotoHelp(at: self)
    }

}

extension XWHBindDeviceVC {
    
    // 绑定
    private func startBindDevice() {
        connect(device: bindDeviceModel)
        startBindDeviceUI()
    }
    
    // 绑定成功
    private func bindDeviceSuccess(bindDevice: XWHDevWatchModel) {
        bindDevice.isCurrent = true
        isBindSuccess = true
        XWHDeviceDataManager.setCurrent(device: bindDevice)
        
        updateDeviceInfo { [weak self] connDev in
            guard let self = self else {
                return
            }
            
            self.bindDeviceSuccessUI()
            
            self.uploadBindDevice(connDev)
            
            XWHDevice.shared.syncData()
        }
    }
    
}

// MARK: - UI
extension XWHBindDeviceVC {
    
    private func startBindDeviceUI() {
        button.isHidden = true
        helpBtn.isHidden = true
        
        titleLb.text = R.string.xwhDeviceText.正在配对()
        
        detailLb.text = getDetailText(with: R.string.xwhDeviceText.正在对N进行配对())
    }
    
    private func bindDeviceFailedUI() {
        button.isHidden = false
        helpBtn.isHidden = false
        
        titleLb.text = R.string.xwhDeviceText.配对失败()
                
        detailLb.text = getDetailText(with: R.string.xwhDeviceText.与N配对失败())
        
        button.setTitle(R.string.xwhDeviceText.重试(), for: .normal)
        helpBtn.setTitle(R.string.xwhDeviceText.查看帮助(), for: .normal)
    }
    
    private func bindDeviceSuccessUI() {
        button.isHidden = false
        helpBtn.isHidden = true
        
        titleLb.text = R.string.xwhDeviceText.配对成功()
        detailLb.text = getDetailText(with: R.string.xwhDeviceText.与N配对成功())
        
        button.setTitle(R.string.xwhDisplayText.完成(), for: .normal)
    }
    
}

// MARK: - UI Jump
extension XWHBindDeviceVC {
    
    private func gotoDeviceMain() {
        let vc = XWHDeviceMainVC()
        navigationController?.setViewControllers([vc], animated: true)
    }
    
}

// MARK: - Api
extension XWHBindDeviceVC {
    
    // 连接设备
    private func connect(device: XWHDevWatchModel) {
        XWHDDMShared.connect(device: device, isReconnect: false) { [weak self] (result: Result<XWHDeviceConnectBindState, XWHBLEError>) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let connBindState):
                if connBindState == .paired {
                    self.bindDeviceSuccess(bindDevice: device)
                } else {
                    self.bind(device: device)
                }
                
            case .failure(_):
                self.bindDeviceFailedUI()
            }
        }
    }
    
    // 绑定（配对）设备
    private func bind(device: XWHDevWatchModel) {
        XWHDDMShared.bind(device: device) { [weak self] (result: Result<XWHDeviceConnectBindState, XWHBLEError>) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let connBindState):
                if connBindState == .paired {
                    self.bindDeviceSuccess(bindDevice: device)
                }
                
            case .failure(_):
                self.bindDeviceFailedUI()
            }
        }
    }
    
    private func updateDeviceInfo(_ completion: ((XWHDevWatchModel) -> Void)? = nil) {
        XWHDDMShared.getDeviceInfo { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let cModel):
                guard let connModel = cModel?.data as? XWHDevWatchModel else {
                    return
                }
                if let curModel = XWHDeviceDataManager.getCurrentWatch() {
                    connModel.isCurrent = curModel.isCurrent
                    connModel.type = curModel.type
                    connModel.category = curModel.category
                }
                
                XWHDeviceDataManager.setCurrent(device: connModel)
                completion?(connModel)
                
            case .failure(let error):
                self.view.makeInsetToast(error.message)
            }
        }
    }
    
    // 绑定设备上报
    func uploadBindDevice(_ device: XWHDevWatchModel) {
        // Test
        let deviceSn = XWHDeviceHelper.getStandardDeviceSn(device.identifier)
        XWHUserVM().bindDevice(deviceSn: deviceSn, deviceMode: device.type.rawValue, deviceName: device.name, macAddr: device.mac) { error in
            log.error(error)
        } successHandler: { res in
            
        }
    }
    
}

// MARK: - Private
extension XWHBindDeviceVC {
    
    private func getDetailText(with oString: String) -> String {
        let devName = bindDeviceModel.type.rawValue
        let detailText = oString.replacingOccurrences(of: "N", with: devName)
        
        return detailText
    }
    
}
