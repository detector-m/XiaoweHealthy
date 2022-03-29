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
        
        titleLb.text = R.string.xwhDeviceText.正在配对()
        detailLb.text = R.string.xwhDeviceText.正在对N进行配对()
        
        button.setTitle(R.string.xwhDeviceText.重试(), for: .normal)
        helpBtn.setTitle(R.string.xwhDeviceText.查看帮助(), for: .normal)
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
        let vc = XWHDeviceMainVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func clickHelpBtn() {
        XWHDevice.gotoHelp(at: self)
    }

}
