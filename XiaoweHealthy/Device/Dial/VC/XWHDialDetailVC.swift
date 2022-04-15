//
//  XWHDialDetailVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/15.
//

import UIKit
import Kingfisher

class XWHDialDetailVC: XWHDeviceBaseVC {

    lazy var devImageView = XWHDeviceFaceView()
    lazy var button = XWHProgressButton()
    
    lazy var dial = XWHDialModel() {
        didSet {
            titleLb.text = dial.name
            devImageView.imageView.kf.setImage(with: dial.image.url, placeholder: R.image.devicePlacehodlerCover())
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        devImageView.bgImageView.contentMode = .scaleAspectFit
        devImageView.imageView.contentMode = .scaleAspectFit
        devImageView.bgImageView.image = R.image.devicePlacehodlerBg()
//        devImageView.imageView.image = R.image.devicePlacehodlerCover()
        view.addSubview(devImageView)
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(fontLightLightColor, for: .normal)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        button.progressView.capType = 1
        button.progressView.trackColor = btnBgColor.withAlphaComponent(0.35)
        button.progressView.barColor = btnBgColor
        view.addSubview(button)

        button.setTitle(R.string.xwhDialText.设置为当前表盘(), for: .normal)
        
        detailLb.isHidden = true
        titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        titleLb.textAlignment = .center
    }
    
    override func relayoutSubViews() {
        devImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
//            make.width.equalTo(240).priority(.low)
//            make.left.right.equalToSuperview().inset(43).priority(.high)
            make.width.height.equalTo(240)
            make.top.equalTo(112)
//            make.height.equalTo(devImageView.snp.width)
        }
        
        titleLb.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.top.equalTo(devImageView.snp.bottom).offset(16)
            make.height.equalTo(24)
        }
    
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
    
    @objc private func clickButton() {
        
    }

}
