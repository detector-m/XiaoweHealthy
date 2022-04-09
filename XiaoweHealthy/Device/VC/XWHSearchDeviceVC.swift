//
//  XWHSearchDeviceVC.swift
//  XiaoweHealthy
//
//  Created by Riven on 2022/3/28.
//

import UIKit

class XWHSearchDeviceVC: XWHSearchBindDevBaseVC {
    
    lazy var radarView = RLRadarView()
    
    lazy var tableView = UITableView()
    
    lazy var watchModel = XWHDevWatchModel()
    
    lazy var scanWatches = [XWHDevWatchModel]()
    
    deinit {
        stopSearchDevice()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.startSearching()
        }
    }
    
    override func setupNavigationItems() {
        super.setupNavigationItems()
        navigationItem.rightBarButtonItem = getNavItem(text: R.string.xwhDeviceText.帮助(), image: nil, target: self, action: #selector(clickNavRightBtn))
    }
    
    override func addSubViews() {
        super.addSubViews()
        
        view.addSubview(radarView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.rowHeight = 48
        tableView.separatorStyle = .none
        tableView.register(cellWithClass: XWHSearchDeviceTBCell.self)
        view.addSubview(tableView)
        
        titleLb.text = R.string.xwhDeviceText.正在搜索()
        detailLb.text = R.string.xwhDeviceText.请让设备贴近手机以便搜索到蓝牙设备()
        
        button.setTitle(R.string.xwhDeviceText.正在搜索(), for: .normal)
        button.isEnabled = false
        button.alpha = 0.24
    }
    
    override func relayoutSubViews() {
        relayoutTitleAndDetailLb()
        
        radarView.snp.makeConstraints { make in
            make.size.equalTo(280)
            make.centerX.equalToSuperview()
            make.top.equalTo(detailLb.snp.bottom).offset(20)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(radarView.snp.bottom).offset(10)
            make.bottom.equalTo(button.snp.top)
        }
        
        button.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(28)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
    
    @objc override func clickButton() {
        startSearching()
    }
    
    @objc func clickNavRightBtn() {
        gotoHelp()
    }

}

extension XWHSearchDeviceVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scanWatches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cWatchModel = scanWatches[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withClass: XWHSearchDeviceTBCell.self, for: indexPath)
        
        let rssi = (abs(cWatchModel.rssi + 100) / 25)
        let rssiImageStr = "SignalQuality_\(rssi)"
        
        cell.titleLb.text = cWatchModel.name
        cell.iconView.image = UIImage(named: rssiImageStr)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cWatchModel = scanWatches[indexPath.row]

        gotoBindDevice(bindDeviceModel: cWatchModel)
    }
    
}

// MARK: -
extension XWHSearchDeviceVC {
    
    private func startSearching() {
        startSearchDevice()

        startRadarSearching()
    }
    
    private func stopSearching() {
        stopSearchDevice()

        stopRadarSearching()
    }
    
//    private func searchingTimeout() {
//        radarSearchingTimeout()
//    }
    
}

// MARK: - Api
extension XWHSearchDeviceVC {
    
    private func startSearchDevice() {
        XWHDDMShared.config(device: watchModel)
        
        XWHDDMShared.startScan { [unowned self] result in
            switch result {
            case .success(let cWatches):
                self.scanWatches = cWatches
                self.stopSearching()
                self.reloadUIData()
                
            case .failure:
                self.radarSearchingTimeout()
            }
        }
    }
    
    private func stopSearchDevice() {
        XWHDDMShared.stopScan()
    }
    
}

// MARK: - UI
extension XWHSearchDeviceVC {
    
    private func reloadUIData() {
        button.isHidden = true
        button.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        
        tableView.reloadData()
    }
    
    private func startRadarSearching() {
        radarView.scan()
    
        button.isHidden = false
        button.snp.updateConstraints { make in
            make.height.equalTo(48)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.button.setTitle(R.string.xwhDeviceText.正在搜索(), for: .normal)
            self.button.isEnabled = false
            self.button.alpha = 0.24
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
////            self.searchingTimeout()
//            self.stopSearching()
////            self.scaleRadarScan()
//        }
    }
    
    private func stopRadarSearching() {
        radarView.stop()

//        var rRect = radarView.frame
//        radarView.snp.removeConstraints()
//        radarView.frame = rRect
//        rRect.size = CGSize(width: 160, height: 160)
        
        radarView.radarIndicatorView.isHidden = true
        UIView.animate(withDuration: 0.25, delay: 0, options: []) {
//            self.radarView.radarIndicatorView.isHidden = true

//            self.radarView.frame = rRect
//            self.radarView.center.x = self.view.center.x
            
            self.radarView.snp.updateConstraints { make in
                make.size.equalTo(160)
                make.centerX.equalToSuperview()
                make.top.equalTo(self.detailLb.snp.bottom).offset(20)
            }
            
            self.view.layoutIfNeeded()
            self.radarView.setNeedsDisplay()
            
//            self.radarView.radarIndicatorView.isHidden = false

//            DispatchQueue.main.async {
//                self.radarView.scan()
//            }
        } completion: { _ in
            self.radarView.radarIndicatorView.isHidden = false
        }
    }
    
    private func radarSearchingTimeout() {
        radarView.stop()
        
        UIView.animate(withDuration: 0.25) {
            self.button.isEnabled = true
            self.button.setTitle(R.string.xwhDeviceText.重试(), for: .normal)
            
            self.button.alpha = 1
        }
        
    }
    
    private func scaleRadarScan() {
//            self.radarView.snp.remakeConstraints { make in
//                make.size.equalTo(220)
//                make.centerX.equalToSuperview()
//                make.top.equalTo(self.detailLb.snp.bottom).offset(20)
//            }
//            self.radarView.size = CGSize(width: 220, height: 220)
//            self.radarView.setNeedsLayout()
        
        radarView.stop()
        self.radarView.radarIndicatorView.isHidden = true

        UIView.animate(withDuration: 0.25, delay: 0, options: []) {
            self.radarView.snp.updateConstraints { make in
                make.size.equalTo(180)
                make.centerX.equalToSuperview()
                make.top.equalTo(self.detailLb.snp.bottom).offset(20)
            }
            self.view.layoutIfNeeded()
            self.radarView.setNeedsDisplay()
        } completion: { _ in
            DispatchQueue.main.async {
                self.radarView.radarIndicatorView.isHidden = false
                self.radarView.scan()
            }
        }
    }
    
}

// MARK: - UI Jump
extension XWHSearchDeviceVC {
    
    fileprivate func gotoHelp() {
        XWHDevice.gotoHelp(at: self)
    }
    
    fileprivate func gotoBindDevice(bindDeviceModel: XWHDevWatchModel) {
        let devName = bindDeviceModel.type.rawValue
        let alertMsg = R.string.xwhDeviceText.要与N配对吗().replacingOccurrences(of: "N", with: devName)
        XWHAlert.show(message: alertMsg) { [unowned self] cType in
            if cType == .confirm {
                let vc = XWHBindDeviceVC()
                vc.bindDeviceModel = bindDeviceModel
                navigationController?.pushViewController(vc, animated: true)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
