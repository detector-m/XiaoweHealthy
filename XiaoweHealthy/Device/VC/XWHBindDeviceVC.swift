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
        if XWHDDMShared.connectState == .disconnected {
            startBindDevice()
        } else if XWHDDMShared.connectState == .connected {
            gotoDeviceMain()
        }
    }
    
    @objc func clickHelpBtn() {
        XWHDevice.gotoHelp(at: self)
    }

}

// MARK: - UI
extension XWHBindDeviceVC {
    
    static var rNum: UInt32 = 0
    private var rNum: UInt32 {
        return Self.rNum
    }
    
    // 绑定
    private func startBindDevice() {
        button.isHidden = true
        helpBtn.isHidden = true
        
        titleLb.text = R.string.xwhDeviceText.正在配对()
        
        detailLb.text = getDetailText(with: R.string.xwhDeviceText.正在对N进行配对())
        
        XWHDDMShared.connect(device: bindDeviceModel, isReconnect: false) { [weak self] (result: Result<XWHDeviceConnectState, XWHBLEError>, conState) in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(_):
                self.bindDeviceModel.isCurrent = true
                self.isBindSuccess = true
                XWHDataDeviceManager.saveWatch(self.bindDeviceModel)
                self.bindDeviceSuccess()
                
            case .failure(_):
                self.bindDeviceFailed()
            }
        }
    }
    
    private func bindDeviceFailed() {
        button.isHidden = false
        helpBtn.isHidden = false
        
        titleLb.text = R.string.xwhDeviceText.配对失败()
                
        detailLb.text = getDetailText(with: R.string.xwhDeviceText.与N配对失败())
        
        button.setTitle(R.string.xwhDeviceText.重试(), for: .normal)
        helpBtn.setTitle(R.string.xwhDeviceText.查看帮助(), for: .normal)
    }
    
    private func bindDeviceSuccess() {
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

// MARK: - Private
extension XWHBindDeviceVC {
    
    private func getDetailText(with oString: String) -> String {
        let devName = bindDeviceModel.type.rawValue
        let detailText = oString.replacingOccurrences(of: "N", with: devName)
        
        return detailText
    }
    
}
