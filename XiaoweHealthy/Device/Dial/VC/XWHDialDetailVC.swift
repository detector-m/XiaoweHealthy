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
    
    private var isInstalling = false {
        didSet {
            rt_disableInteractivePop = isInstalling
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
        button.progressView.trackColor = btnBgColor
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
    
    override func clickNavGlobalBackBtn() {
        if isInstalling {
            view.makeInsetToast(R.string.xwhDialText.表盘安装中())
            return
        }
        
        super.clickNavGlobalBackBtn()
    }
    
    @objc private func clickButton() {
        installingUI()
        downloadInstall()
    }

}

// MARK: - 下载安装UI
extension XWHDialDetailVC {
    
    private func allowInstallUI() {
        button.isEnabled = true

        button.progressView.progressValue = 0
        button.progressView.trackColor = btnBgColor
        button.progressView.barColor = btnBgColor
        
        button.setTitle(R.string.xwhDialText.设置为当前表盘(), for: .normal)
    }
    
    private func installingUI() {
        button.isEnabled = false
        button.progressView.progressValue = 1
        button.progressView.trackColor = btnBgColor.withAlphaComponent(0.35)
        button.progressView.barColor = btnBgColor
        
        button.setTitle(R.string.xwhDialText.安装中(), for: .normal)
    }
    
    private func installedUI () {
        button.isEnabled = false
        
        button.progressView.progressValue = 0
        button.progressView.trackColor = btnBgColor.withAlphaComponent(0.35)
        button.progressView.barColor = btnBgColor
        
        button.setTitle(R.string.xwhDialText.已设置(), for: .normal)
    }
    
}
    


// MARK: - Api
extension XWHDialDetailVC {
    
    private func downloadInstall() {
        isInstalling = true
        XWHDialDownloadInstallManager.download(url: dial.file) { [weak self] pRes in
            guard let self = self else {
                return
            }
            
            let cProgress = pRes.progress / 2
            self.button.progressView.progressValue = cProgress.cgFloat
        } failureHandler: { [weak self] error in
            guard let self = self else {
                return
            }
            
            self.isInstalling = false
            self.allowInstallUI()
            self.view.makeInsetToast(error.message)
        } successHandler: { [weak self] sRes in
            guard let self = self else {
                return
            }
//            self.installedUI()
            if let fileUrl = sRes.data as? URL {
                self.install(fileUrl)
            } else {
                self.isInstalling = false

                self.allowInstallUI()
                self.view.makeInsetToast("下载失败")
            }
        }
    }
    
    private func install(_ dialUrl: URL) {
//        let fileName = "D391901_pix360x360_rgb565"
//
//        guard let dialUrl = Bundle.main.url(forResource: fileName, withExtension: "bin") else {
//            return
//        }
        
//        XWHProgressHUD.show(title: "表盘安装中...")
        log.debug("安装表盘的文件路径 = \(dialUrl.path)")
        XWHDDMShared.sendDialFile(dialUrl) { [weak self] progress in
            guard let self = self else {
                return
            }
            
            let cProgress = progress / 2 + 50
            self.button.progressView.progressValue = cProgress.cgFloat
        } handler: { [weak self] result in
            guard let self = self else {
                return
            }
//            XWHProgressHUD.hide()
            
            switch result {
            case .success(_):
                self.isInstalling = false
                self.installedUI()
                self.view.makeInsetToast("安装成功")
                
            case .failure(let error):
                self.isInstalling = false
                self.allowInstallUI()
                self.view.makeInsetToast(error.message)
            }
        }
    }
    
}
