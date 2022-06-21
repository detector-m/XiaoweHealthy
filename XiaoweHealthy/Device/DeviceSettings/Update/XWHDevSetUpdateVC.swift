//
//  XWHDevSetUpdateVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/4/1.
//

import UIKit
import LinearProgressBar
import SwiftyJSON

class XWHDevSetUpdateVC: XWHDevSetBaseVC {
    
    lazy var headerView = XWHDevSetUpdateHeaderView()
    
    lazy var button = XWHProgressButton()
    
    var updateInfo: JSON?
    
    private lazy var downloader = XWHDownloader()
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
    
        view.addSubview(headerView)
        
        button.titleLabel?.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        button.setTitleColor(fontLightLightColor, for: .normal)
        button.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        
        button.progressView.capType = 1
        button.progressView.trackColor = btnBgColor
        button.progressView.barColor = btnBgColor
        
        view.addSubview(button)

        titleLb.text = R.string.xwhDeviceText.检查更新()
        
        button.setTitle(R.string.xwhDeviceText.下载升级包(), for: .normal)
        
        let verStr = updateInfo?["versionNo"].string ?? ""
        if !verStr.isEmpty {
            headerView.titleLb.text = verStr + "\n" + R.string.xwhDeviceText.发现新版本()
        }
    }
    
    override func relayoutSubViews() {
        relayoutTitleLb()
        headerView.snp.makeConstraints { make in
            make.top.equalTo(titleLb.snp.bottom).offset(40)
            make.height.equalTo((80 + 6 + 48))
            make.left.right.equalToSuperview().inset(28)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(button.snp.top)
        }
        
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }
    
    override func clickNavGlobalBackBtn() {
        if isInstalling {
            view.makeInsetToast(R.string.xwhDeviceText.固件更新中())
            return
        }
        
        super.clickNavGlobalBackBtn()
    }
    
    @objc private func clickButton() {
        installingUI()
        downloadInstall()
    }
    
    // MARK: - ConfigUI
    override func registerTableViewCell() {
        tableView.register(cellWithClass: XWHBaseTBCell.self)
        
        tableView.register(headerFooterViewClassWith: XWHTBHeaderFooterBaseView.self)
    }
    

    // MARK: - UITableViewDataSource, UITableViewDelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = updateInfo {
            return 1
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: XWHBaseTBCell.self)
        
        cell.titleLb.numberOfLines = 0
        cell.titleLb.font = XWHFont.harmonyOSSans(ofSize: 14)
        cell.relayoutOnlyTitleLb()
        
        if let updateDes = updateInfo?["versionDesc"].stringValue {
            cell.titleLb.text = updateDes
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        48
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withClass: XWHTBHeaderFooterBaseView.self)
        header.titleLb.font = XWHFont.harmonyOSSans(ofSize: 16, weight: .medium)
        header.titleLb.textColor = fontDarkColor
        header.titleLb.text = R.string.xwhDeviceText.固件更新日志()
        
        return header
    }

}

// MARK: - 下载安装UI
extension XWHDevSetUpdateVC {
    
    private func allowInstallUI() {
        button.isEnabled = true

        button.progressView.progressValue = 0
        button.progressView.trackColor = btnBgColor
        button.progressView.barColor = btnBgColor
        
        button.setTitle(R.string.xwhDeviceText.下载升级包(), for: .normal)
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
        
        button.setTitle(R.string.xwhDeviceText.安装成功(), for: .normal)
    }
    
}

extension XWHDevSetUpdateVC {

    private func downloadInstall() {
        guard let fileUrl = updateInfo?["fileUrl"].string else {
            log.error("固件升级失败 获取 fileUrl 失败")
            
            return
        }

//        XWHProgressHUD.show(title: R.string.xwhDeviceText.固件更新中())
        
        downloader.download(url: fileUrl) { [weak self] pRes in
            guard let self = self else {
                return
            }
            
            let cProgress = pRes.progress / 2
            self.button.progressView.progressValue = cProgress.cgFloat
        } failureHandler: { [weak self] error in
//            XWHProgressHUD.hide()
            guard let self = self else {
                return
            }
            self.isInstalling = false
            self.allowInstallUI()
            self.view.makeInsetToast(R.string.xwhDeviceText.下载固件包失败())
        } successHandler: { [weak self] sRes in
            guard let self = self else {
                return
            }
            
            if let fileUrl = sRes.data as? URL {
                self.install(fileUrl)
            } else {
//                XWHProgressHUD.hide()
                
                self.isInstalling = false

                self.allowInstallUI()
                self.view.makeInsetToast(R.string.xwhDeviceText.下载固件包失败())
            }
        }
    }
    
    private func install(_ fileUrl: URL ) {
//        let fileName = "D391901_pix360x360_rgb565"
//
//        guard let fileUrl = Bundle.main.url(forResource: fileName, withExtension: "bin") else {
//            return
//        }
        
        XWHDDMShared.sendFirmwareFile(fileUrl) { [weak self] progress in
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
                self.view.makeInsetToast(R.string.xwhDeviceText.安装成功())
                
            case .failure(_):
                self.isInstalling = false
                self.allowInstallUI()
                self.view.makeInsetToast(R.string.xwhDeviceText.安装固件包失败())
            }
        }
        
    }

}
