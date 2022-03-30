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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testUI()
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
    
    override func clickButton() {
        if rNum != 0 {
//            startBindDevice()
            testUI()
            
            return
        }
        
        gotoDeviceMain()
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
    
    // Test
    private func testUI() {
        startBindDevice()
        
        Self.rNum = arc4random() % 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            if self.rNum == 0 {
                self.bindDeviceSuccess()
            } else {
                self.bindDeviceFailed()
            }
        }
    }
    
    // 绑定
    private func startBindDevice() {
        button.isHidden = true
        helpBtn.isHidden = true
        
        titleLb.text = R.string.xwhDeviceText.正在配对()
        detailLb.text = R.string.xwhDeviceText.正在对N进行配对()
    }
    
    private func bindDeviceFailed() {
        button.isHidden = false
        helpBtn.isHidden = false
        
        titleLb.text = R.string.xwhDeviceText.配对失败()
        detailLb.text = R.string.xwhDeviceText.与N配对失败()
        
        button.setTitle(R.string.xwhDeviceText.重试(), for: .normal)
        helpBtn.setTitle(R.string.xwhDeviceText.查看帮助(), for: .normal)
    }
    
    private func bindDeviceSuccess() {
        button.isHidden = false
        helpBtn.isHidden = true
        
        titleLb.text = R.string.xwhDeviceText.配对成功()
        detailLb.text = R.string.xwhDeviceText.与N配对成功()
        
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
